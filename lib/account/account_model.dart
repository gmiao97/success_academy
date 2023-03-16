import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:success_academy/services/shared_preferences_service.dart'
    as shared_preferences_service;
import 'package:success_academy/services/stripe_service.dart' as stripe_service;
import 'package:success_academy/services/user_service.dart' as user_service;

// Add loading state to display spinner while initializing user
enum AuthStatus { signedIn, signedOut, emailVerification, loading }

enum UserType { student, studentNoProfile, teacher, admin }

class AccountModel extends ChangeNotifier {
  AccountModel() {
    init();
  }

  void init() async {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      _authStatus = AuthStatus.loading;
      notifyListeners();
      if (firebaseUser != null) {
        try {
          await _initAccount(firebaseUser);
        } catch (err) {
          await FirebaseAnalytics.instance.logEvent(
            name: 'initAccount_failed',
            parameters: {
              'message': err.toString(),
            },
          );
        }
        if (!firebaseUser.emailVerified) {
          if (_authStatus != AuthStatus.emailVerification) {
            // Only send verification email once on initial auth status change
            firebaseUser.sendEmailVerification();
          }
          _authStatus = AuthStatus.emailVerification;
        } else {
          _authStatus = AuthStatus.signedIn;
        }
      } else {
        _signOut();
      }
      notifyListeners();
    });
    _locale = await shared_preferences_service.getLocale();
  }

  AuthStatus _authStatus = AuthStatus.signedOut;
  String _locale = 'en';
  User? _firebaseUser;
  MyUserModel? _myUser;
  StudentProfileModel? _studentProfile;
  TeacherProfileModel? _teacherProfile;
  AdminProfileModel? _adminProfile;
  List<StudentProfileModel>? _studentProfileList;
  Map<String, StudentProfileModel>? _studentProfileMap;
  List<TeacherProfileModel>? _teacherProfileList;
  Map<String, TeacherProfileModel>? _teacherProfileMap;
  List<QueryDocumentSnapshot<Object?>> _subscriptionDocs = [];
  SubscriptionPlan? _subscriptionPlan;

  AuthStatus get authStatus => _authStatus;
  // TODO: Add preferred language and customize welcome email and stripe based on it.
  String get locale => _locale;
  User? get firebaseUser => _firebaseUser;
  MyUserModel? get myUser => _myUser;
  StudentProfileModel? get studentProfile => _studentProfile;
  TeacherProfileModel? get teacherProfile => _teacherProfile;
  AdminProfileModel? get adminProfile => _adminProfile;
  List<StudentProfileModel>? get studentProfileList => _studentProfileList;
  Map<String, StudentProfileModel>? get studentProfileMap => _studentProfileMap;
  List<TeacherProfileModel>? get teacherProfileList => _teacherProfileList;
  Map<String, TeacherProfileModel>? get teacherProfileModelMap =>
      _teacherProfileMap;
  SubscriptionPlan? get subscriptionPlan => _subscriptionPlan;
  UserType get userType {
    if (_adminProfile != null) {
      return UserType.admin;
    }
    if (_teacherProfile != null) {
      return UserType.teacher;
    }
    if (_studentProfile == null) {
      return UserType.studentNoProfile;
    }
    return UserType.student;
  }

  set myUser(MyUserModel? myUser) {
    _myUser = myUser;
    notifyListeners();
  }

  set authStatus(AuthStatus authStatus) {
    _authStatus = authStatus;
    notifyListeners();
  }

  set locale(String locale) {
    _locale = locale;
    notifyListeners();
    shared_preferences_service.updateLocale(locale);
  }

  set studentProfile(StudentProfileModel? studentProfile) {
    _studentProfile = studentProfile;
    shared_preferences_service.updateStudentProfile(studentProfile);
    _subscriptionPlan =
        _getSubscriptionTypeForProfile(studentProfile?.profileId);
    notifyListeners();
  }

  /**
   * Initialize account model with firebase user data, data from 'myUsers'
   * collection, and profile data from shared preferences if existing.
   */
  Future<void> _initAccount(User firebaseUser) async {
    _firebaseUser = firebaseUser;
    _studentProfileList = await profile_service.getAllStudentProfiles();
    _studentProfileMap =
        StudentProfileModel.buildStudentProfileMap(_studentProfileList!);
    _teacherProfileList = await profile_service.getAllTeacherProfiles();
    _teacherProfileMap =
        TeacherProfileModel.buildTeacherProfileMap(_teacherProfileList!);
    _subscriptionDocs =
        await stripe_service.getSubscriptionsForUser(firebaseUser.uid);

    await user_service.createMyUserDocIfNotExist(firebaseUser.uid);
    _myUser = await user_service.getMyUserDoc(firebaseUser.uid);
    await _initProfile(firebaseUser.uid);
  }

  Future<void> _initProfile(String userId) async {
    final adminProfile = await profile_service.getAdminProfileForUser(userId);
    final teacherProfile =
        await profile_service.getTeacherProfileForUser(userId);
    if (adminProfile != null) {
      // Admin profile
      _adminProfile = adminProfile;
    } else if (teacherProfile != null) {
      // Teacher profile
      _teacherProfile = teacherProfile;
    } else {
      // Student profile
      final studentProfile =
          await shared_preferences_service.loadStudentProfile(userId: userId);
      final studentProfileBelongsToUser =
          await profile_service.studentProfileBelongsToUser(
              userId: userId, profileId: studentProfile?.profileId);
      if (studentProfileBelongsToUser) {
        _studentProfile = studentProfile;
        _subscriptionPlan =
            _getSubscriptionTypeForProfile(studentProfile!.profileId);
      }
    }
  }

  void _signOut() {
    _authStatus = AuthStatus.signedOut;
    _firebaseUser = null;
    _studentProfile = null;
    _teacherProfile = null;
    _adminProfile = null;
    shared_preferences_service.removeStudentProfile();
  }

  SubscriptionPlan? _getSubscriptionTypeForProfile(String? profileId) {
    if (profileId == null) {
      return null;
    }
    try {
      return EnumToString.fromString(
          SubscriptionPlan.values,
          _subscriptionDocs
              .firstWhere((doc) =>
                  doc.get('metadata.profile_id') as String == profileId)
              .get('items')[0]['plan']['metadata']['id']);
    } on StateError {
      debugPrint(
          'getSubscriptionTypeForProfile: No subscription found for profile $profileId');
      FirebaseAnalytics.instance.logEvent(
        name: 'getSubscriptionTypeForProfile',
        parameters: {
          'message': 'No subscription found for profile $profileId',
        },
      );
      return null;
    }
  }
}

class MyUserModel {
  MyUserModel({required this.referralCode, required this.timeZone});

  MyUserModel.fromJson(Map<String, Object?> json)
      : referralCode = json['referral_code'] as String,
        timeZone = json['time_zone'] as String;

  // TODO: Add check to prevent repeats
  final String referralCode;
  String timeZone;

  Map<String, Object?> toJson() {
    return {
      'referral_code': referralCode,
      'time_zone': timeZone,
    };
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:success_academy/services/shared_preferences_service.dart'
    as shared_preferences_service;
import 'package:success_academy/services/user_service.dart' as user_service;

// Add loading state to display spinner while initializing user
enum AuthStatus { signedIn, signedOut, emailVerification, loading }

class AccountModel extends ChangeNotifier {
  AccountModel() {
    init();
  }

  void init() async {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        await _initAccount(firebaseUser);
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

  AuthStatus _authStatus = AuthStatus.loading;
  String _locale = 'en';
  User? _firebaseUser;
  MyUserModel? _myUser;
  StudentProfileModel? _profile;
  TeacherProfileModel? _teacherProfile;

  AuthStatus get authStatus => _authStatus;
  // TODO: Add preferred language and customize welcome email and stripe based on it.
  String get locale => _locale;
  User? get firebaseUser => _firebaseUser;
  MyUserModel? get myUser => _myUser;
  StudentProfileModel? get profile => _profile;
  TeacherProfileModel? get teacherProfile => _teacherProfile;

  set authStatus(AuthStatus authStatus) {
    _authStatus = authStatus;
    notifyListeners();
  }

  set locale(String locale) {
    _locale = locale;
    notifyListeners();
    shared_preferences_service.updateLocale(locale);
  }

  set profile(StudentProfileModel? profile) {
    _profile = profile;
    shared_preferences_service.updateStudentProfile(profile);
    notifyListeners();
  }

  /**
   * Initialize account model with firebase user data, data from 'myUsers'
   * collection, and profile data from shared preferences if existing.
   */
  Future<void> _initAccount(User firebaseUser) async {
    _firebaseUser = firebaseUser;
    await user_service.createMyUserDocIfNotExist(firebaseUser.uid);
    _myUser = await user_service.getMyUserDoc(firebaseUser.uid);
    await _initProfile(firebaseUser.uid);
  }

  Future<void> _initProfile(String userId) async {
    final teacherProfile =
        await profile_service.getTeacherProfileForUser(userId);
    if (teacherProfile != null) {
      //Teacher profile
      _teacherProfile = teacherProfile;
    } else {
      // Student profile
      final profile = await shared_preferences_service.loadStudentProfile();
      final studentProfileBelongsToUser =
          await profile_service.studentProfileBelongsToUser(
              userId: userId, profileId: profile?.profileId);
      if (studentProfileBelongsToUser) {
        _profile = profile;
      }
    }
  }

  void _signOut() {
    _authStatus = AuthStatus.signedOut;
    _firebaseUser = null;
    _profile = null;
    _teacherProfile = null;
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

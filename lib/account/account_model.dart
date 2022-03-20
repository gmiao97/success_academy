import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:success_academy/profile/profile_model.dart';

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
    final prefs = await _getSharedPreferencesInstance();
    _locale = prefs?.getString('locale') ?? 'en';
  }

  AuthStatus _authStatus = AuthStatus.loading;
  String _locale = 'en';
  User? _user;
  MyUserModel? _myUser;
  ProfileModel? _profile;
  TeacherProfileModel? _teacherProfile;

  AuthStatus get authStatus => _authStatus;
  // TODO: Add preferred language and customize welcome email and stripe based on it.
  String get locale => _locale;
  User? get user => _user;
  MyUserModel? get myUser => _myUser;
  ProfileModel? get profile => _profile;
  TeacherProfileModel? get teacherProfile => _teacherProfile;

  set authStatus(AuthStatus authStatus) {
    _authStatus = authStatus;
    notifyListeners();
  }

  set locale(String locale) {
    _locale = locale;
    notifyListeners();
    _updateSharedPreferencesLocale(locale);
  }

  set profile(ProfileModel? profile) {
    _profile = profile;
    _updateSharedPreferencesProfile(profile);
    notifyListeners();
  }

  /**
   * Initialize account model with firebase user data, data from 'user'
   * collection, and profile data from shared preferences if existing.
   * 
   * Creates new document in 'users' collection if not already existing.
   */
  Future<void> _initAccount(User firebaseUser) async {
    _user = firebaseUser;
    _createUsersDocIfNotExist(firebaseUser.uid);
    _myUserModelRef.doc(firebaseUser.uid).get().then((documentSnapshot) {
      _myUser = documentSnapshot.data();
    });
    await _initProfile(firebaseUser.uid);
  }

  Future<void> _initProfile(String userId) async {
    //Teacher profile
    final teacherProfile = await getTeacherProfileForUser(userId);
    if (teacherProfile != null) {
      _teacherProfile = teacherProfile;
    } else {
      // Student profile
      final profile = await _loadSharedPreferencesProfile();
      final profileBelongsToUser = await _profileBelongsToUser(
          userId: userId, profileId: profile?.profileId);
      if (profileBelongsToUser) {
        _profile = profile;
      }
    }
  }

  void _signOut() {
    _authStatus = AuthStatus.signedOut;
    _user = null;
    _profile = null;
    _teacherProfile = null;
  }

  void _updateSharedPreferencesLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale);
  }

  Future<bool> _profileBelongsToUser(
      {required String userId, required String? profileId}) async {
    if (profileId == null) {
      return false;
    }
    return getProfilesForUser(userId)
        .then((documentRefs) => documentRefs.any((doc) => doc.id == profileId));
  }

  Future<ProfileModel?> _loadSharedPreferencesProfile() async {
    final prefs = await _getSharedPreferencesInstance();
    final profileJsonString = prefs?.getString('profile');
    if (profileJsonString != null) {
      final profileJson = jsonDecode(profileJsonString);
      if (profileJson != null) {
        return ProfileModel.fromJson(jsonDecode(profileJsonString));
      }
    }
    return null;
  }

  void _updateSharedPreferencesProfile(ProfileModel? profile) async {
    final prefs = await _getSharedPreferencesInstance();
    prefs?.setString('profile', jsonEncode(profile?.toJson()));
  }

  /// Create document in 'users' collection for user uid if not already existing
  void _createUsersDocIfNotExist(String userId) {
    _myUserModelRef.doc(userId).get().then((documentSnapshot) {
      if (!documentSnapshot.exists) {
        FlutterNativeTimezone.getLocalTimezone().then((localTimeZone) {
          _myUserModelRef.doc(userId).set(MyUserModel(
              referralCode: randomAlphaNumeric(8), timeZone: localTimeZone));
        });
      }
    });
  }

  /** 
   * Get list of query snapshots for all profiles under the user
   * 
   * Returns list of document snapshots for each profile under 'profiles 
   * subcollection in the user doc under 'users' collection. 
   */
  Future<List<QueryDocumentSnapshot<ProfileModel>>> getProfilesForUser(
      String userId) {
    return getProfileModelRefForUser(userId)
        .get()
        .then((querySnapshot) => querySnapshot.docs);
  }

  Future<TeacherProfileModel?> getTeacherProfileForUser(String userId) {
    return getTeacherProfileModelRefForUser(userId).limit(1).get().then(
        (querySnapshot) =>
            querySnapshot.size != 0 ? querySnapshot.docs[0].data() : null);
  }
}

class MyUserModel {
  MyUserModel({required this.referralCode, required this.timeZone});

  MyUserModel._fromJson(Map<String, Object?> json)
      : referralCode = json['referral_code'] as String,
        timeZone = json['time_zone'] as String;

  // TODO: Add check to prevent repeats
  final String referralCode;
  String timeZone;

  Map<String, Object?> _toJson() {
    return {
      'referral_code': referralCode,
      'time_zone': timeZone,
    };
  }
}

final CollectionReference<MyUserModel> _myUserModelRef =
    FirebaseFirestore.instance.collection('users').withConverter<MyUserModel>(
          fromFirestore: (snapshot, _) =>
              MyUserModel._fromJson(snapshot.data()!),
          toFirestore: (myUserModel, _) => myUserModel._toJson(),
        );

Future<SharedPreferences?> _getSharedPreferencesInstance() async {
  try {
    return await SharedPreferences.getInstance();
  } on Exception {
    return null;
  }
}

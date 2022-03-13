import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:success_academy/profile/profile_model.dart';

enum AuthStatus { signedIn, signedOut, emailVerification }

class AccountModel extends ChangeNotifier {
  AccountModel() {
    init();
  }

  void init() async {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        _initAccount(firebaseUser);
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
    final prefs = await SharedPreferences.getInstance();
    _locale = prefs.getString('locale') ?? 'en';
  }

  AuthStatus _authStatus = AuthStatus.signedOut;
  String _locale = 'en';
  User? _user;
  MyUserModel? _myUser;
  ProfileModel? _profile;

  AuthStatus get authStatus => _authStatus;
  String get locale => _locale;
  User? get user => _user;
  ProfileModel? get profile => _profile;
  MyUserModel? get myUser => _myUser;

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
    notifyListeners();
  }

  void _initAccount(User user) {
    _user = user;
    _myUserModelRef.doc(user.uid).get().then((documentSnapshot) {
      _myUser = documentSnapshot.data();
    });
    _createUsersDocIfNotExist(user.uid);
  }

  void _signOut() {
    _authStatus = AuthStatus.signedOut;
    _user = null;
    _profile = null;
  }

  void _updateSharedPreferencesLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale);
  }

  void _createUsersDocIfNotExist(String uid) {
    _myUserModelRef.doc(uid).get().then((documentSnapshot) {
      if (!documentSnapshot.exists) {
        _myUserModelRef.doc(uid).set(MyUserModel(randomAlphaNumeric(8)));
      }
    });
  }

  // Only called if user is not null
  Future<List<QueryDocumentSnapshot<ProfileModel>>> getProfilesForUser() {
    return getProfileModelRefForUser(_user!.uid)
        .get()
        .then((querySnapshot) => querySnapshot.docs);
  }
}

class MyUserModel {
  MyUserModel(this.referralCode);

  MyUserModel._fromJson(Map<String, Object?> json)
      : referralCode = json['referral_code'] as String;

// TODO: Add check to prevent repeats
  final String? referralCode;

  Map<String, Object?> _toJson() {
    return {
      'referral_code': referralCode,
    };
  }
}

final CollectionReference<MyUserModel> _myUserModelRef =
    FirebaseFirestore.instance.collection('users').withConverter<MyUserModel>(
          fromFirestore: (snapshot, _) =>
              MyUserModel._fromJson(snapshot.data()!),
          toFirestore: (myUserModel, _) => myUserModel._toJson(),
        );

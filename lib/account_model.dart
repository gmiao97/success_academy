import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:success_academy/profile/profile_model.dart';

enum AuthStatus { signedIn, signedOut, emailVerification }

class AccountModel extends ChangeNotifier {
  AccountModel() {
    init();
  }

  void init() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        if (!user.emailVerified) {
          if (_authStatus != AuthStatus.emailVerification) {
            user.sendEmailVerification();
          }
          _authStatus = AuthStatus.emailVerification;
          _user = user;
        } else {
          _authStatus = AuthStatus.signedIn;
          _user = user;
        }
      } else {
        _authStatus = AuthStatus.signedOut;
        _user = null;
        _profile = null;
      }
      notifyListeners();
    });
    final prefs = await SharedPreferences.getInstance();
    _locale = prefs.getString('locale') ?? 'en';
  }

  AuthStatus _authStatus = AuthStatus.signedOut;
  String _locale = 'en';
  User? _user;
  ProfileModel? _profile;

  AuthStatus get authStatus => _authStatus;
  User? get user => _user;
  ProfileModel? get profile => _profile;
  String get locale => _locale;

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

  void _updateSharedPreferencesLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale);
  }
}

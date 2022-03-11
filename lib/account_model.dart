import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:success_academy/profile/profile_model.dart';

class AccountModel extends ChangeNotifier {
  AccountModel() {
    init();
  }

  void init() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _isSignedIn = true;
        _user = user;
      } else {
        _isSignedIn = false;
        _user = null;
        _profile = null;
      }
      notifyListeners();
    });
    final prefs = await SharedPreferences.getInstance();
    _locale = prefs.getString('locale') ?? 'en';
  }

  bool _isSignedIn = false;
  String _locale = 'en';
  User? _user;
  ProfileModel? _profile;

  bool get isSignedIn => _isSignedIn;
  User? get user => _user;
  ProfileModel? get profile => _profile;
  String get locale => _locale;

  set profile(ProfileModel? profile) {
    _profile = profile;
    notifyListeners();
  }

  set locale(String locale) {
    _locale = locale;
    notifyListeners();
    _updateSharedPreferencesLocale(locale);
  }

  void _updateSharedPreferencesLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:success_academy/profile/profile_model.dart';

class AccountModel extends ChangeNotifier {
  AccountModel() {
    init();
  }

  void init() {
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
  }

  bool _isSignedIn = false;
  User? _user;
  ProfileModel? _profile;

  bool get isSignedIn => _isSignedIn;
  User? get user => _user;
  ProfileModel? get profile => _profile;
  set profile(ProfileModel? profile) {
    _profile = profile;
    notifyListeners();
  }
}

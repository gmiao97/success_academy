import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Authentication { loggedIn, loggedOut }

class AuthenticationState extends ChangeNotifier {
  AuthenticationState() {
    init();
  }

  void init() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _authenticationState = Authentication.loggedIn;
      } else {
        _authenticationState = Authentication.loggedOut;
      }
      notifyListeners();
    });
  }

  Authentication _authenticationState = Authentication.loggedOut;

  Authentication get status => _authenticationState;
}

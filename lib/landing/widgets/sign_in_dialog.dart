import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/data/account_model.dart';
import 'package:success_academy/constants.dart' as constants;

class SignInDialog extends StatelessWidget {
  const SignInDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    if (account.authStatus != AuthStatus.signedOut) {
      Navigator.of(context).pop();
    }

    return AlertDialog(
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 400,
          minHeight: 400,
          maxWidth: 500,
          maxHeight: 500,
        ),
        child: SignInScreen(
          providers: [
            EmailAuthProvider(),
            GoogleProvider(
              clientId: constants.googleAuthProviderConfigurationClientId,
            ),
          ],
        ),
      ),
    );
  }
}

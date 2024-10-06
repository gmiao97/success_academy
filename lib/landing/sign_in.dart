import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';

import '../account/account_model.dart';
import '../constants.dart' as constants;

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
        child: const SignInScreen(
          providerConfigs: [
            EmailProviderConfiguration(),
            GoogleProviderConfiguration(
              clientId: constants.googleAuthProviderConfigurationClientId,
            ),
          ],
        ),
      ),
    );
  }
}

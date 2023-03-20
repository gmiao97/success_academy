import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:success_academy/account/account_model.dart';

import 'package:success_academy/constants.dart' as constants;

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    if (account.authStatus != AuthStatus.signedOut) {
      Navigator.of(context).pop();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
          minWidth: 400, minHeight: 400, maxWidth: 500, maxHeight: 400),
      child: const SignInScreen(
        providerConfigs: [
          EmailProviderConfiguration(),
          GoogleProviderConfiguration(
            clientId: constants.googleAuthProviderConfigurationClientId,
          ),
        ],
      ),
    );
  }
}

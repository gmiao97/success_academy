import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../account/data/account_model.dart';
import '../../constants.dart' as constants;
import '../../generated/l10n.dart';
import 'sign_in_dialog.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 1,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 40,
              height: 40,
            ),
            Text(
              constants.homePageAppBarName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              account.locale = account.locale == 'en' ? 'ja' : 'en';
            },
            child: Text(account.locale == 'en' ? 'US' : 'JP'),
          ),
          TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const SignInDialog(),
            ),
            child: Text(
              S.of(context).signIn,
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Image.asset('assets/images/education.jpg'),
      ),
    );
  }
}

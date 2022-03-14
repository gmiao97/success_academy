import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';

Scaffold buildLoggedInScaffold(
    {required BuildContext context, required Widget body}) {
  final account = context.watch<AccountModel>();
  final style =
      TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

  return Scaffold(
    appBar: AppBar(
      title: const Text(constants.homePageAppBarName),
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          style: style,
          onPressed: () {
            account.locale = account.locale == 'en' ? 'ja' : 'en';
          },
          child: Text(
            account.locale == 'en' ? '🇺🇸' : '🇯🇵',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        TextButton(
          style: style,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          child: Text(S.of(context).signOut),
        )
      ],
    ),
    body: body,
  );
}

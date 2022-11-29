import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';

int timeOfDayToInt(TimeOfDay time) => time.hour * 60 + time.minute;

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

Scaffold buildStudentProfileScaffold(
    {required BuildContext context, required Widget body}) {
  final account = context.watch<AccountModel>();
  final style =
      TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

  return Scaffold(
    appBar: AppBar(
      title: const Text(constants.homePageAppBarName),
      centerTitle: false,
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
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              account.studentProfile!.firstName,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.change_circle),
            title: Text(S.of(context).changeProfile),
            onTap: () {
              account.studentProfile = null;
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(S.of(context).viewProfile),
            onTap: () {
              Navigator.pushNamed(context, constants.routeHome);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(S.of(context).lessonCalendar),
            onTap: () {
              Navigator.pushNamed(context, constants.routeCalendar);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(S.of(context).addPoints),
            onTap: () {
              Navigator.pushNamed(context, constants.routeAddPoints);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(S.of(context).settings),
            onTap: () {
              Navigator.pushNamed(context, constants.routeSettings);
            },
          ),
        ],
      ),
    ),
    body: body,
  );
}

Scaffold buildTeacherProfileScaffold(
    {required BuildContext context, required Widget body}) {
  final account = context.watch<AccountModel>();
  final style =
      TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

  return Scaffold(
    appBar: AppBar(
      title: const Text(constants.homePageAppBarName),
      centerTitle: false,
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
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              account.teacherProfile!.firstName,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(S.of(context).viewProfile),
            onTap: () {
              Navigator.pushNamed(context, constants.routeHome);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(S.of(context).lessonCalendar),
            onTap: () {
              Navigator.pushNamed(context, constants.routeCalendar);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(S.of(context).settings),
            onTap: () {
              Navigator.pushNamed(context, constants.routeSettings);
            },
          ),
        ],
      ),
    ),
    body: body,
  );
}

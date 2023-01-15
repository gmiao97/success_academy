import 'dart:html' as html;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';

int timeOfDayToInt(TimeOfDay time) => time.hour * 60 + time.minute;
const double _bottomSheetHeight = 60;

Scaffold buildLoggedOutScaffold(
    {required BuildContext context, required Widget body}) {
  final account = context.watch<AccountModel>();
  final style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary);

  return Scaffold(
    appBar: AppBar(
      title: InkWell(
        child: const Text(constants.homePageAppBarName),
        onTap: () {
          Navigator.pushNamed(context, constants.routeHome);
        },
      ),
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
          onPressed: () {
            Navigator.pushNamed(context, constants.routeSignIn);
          },
          child: Text(
            S.of(context).signIn,
          ),
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.only(bottom: _bottomSheetHeight),
      child: body,
    ),
    bottomSheet: _bottomSheet,
  );
}

Scaffold buildLoggedInScaffold(
    {required BuildContext context, required Widget body}) {
  final account = context.watch<AccountModel>();
  final style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary);

  return Scaffold(
    appBar: AppBar(
      title: InkWell(
        child: const Text(constants.homePageAppBarName),
        onTap: () {
          Navigator.pushNamed(context, constants.routeHome);
        },
      ),
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
    body: Padding(
      padding: const EdgeInsets.only(bottom: _bottomSheetHeight),
      child: body,
    ),
    bottomSheet: _bottomSheet,
  );
}

Scaffold buildStudentProfileScaffold(
    {required BuildContext context, required Widget body}) {
  final account = context.watch<AccountModel>();
  final style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary);

  return Scaffold(
    appBar: AppBar(
      title: InkWell(
        child: const Text(constants.homePageAppBarName),
        onTap: () {
          Navigator.pushNamed(context, constants.routeHome);
        },
      ),
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
            leading: const Icon(Icons.abc),
            title: Text(S.of(context).freeLessonInfo),
            onTap: () {
              Navigator.pushNamed(context, constants.routeFreeLesson);
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
    body: Padding(
      padding: const EdgeInsets.only(bottom: _bottomSheetHeight),
      child: body,
    ),
    bottomSheet: _bottomSheet,
  );
}

Scaffold buildTeacherProfileScaffold(
    {required BuildContext context, required Widget body}) {
  final account = context.watch<AccountModel>();
  final style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary);

  return Scaffold(
    appBar: AppBar(
      title: InkWell(
        child: const Text(constants.homePageAppBarName),
        onTap: () {
          Navigator.pushNamed(context, constants.routeHome);
        },
      ),
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
            leading: const Icon(Icons.abc),
            title: Text(S.of(context).freeLessonInfo),
            onTap: () {
              Navigator.pushNamed(context, constants.routeFreeLesson);
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
    body: Padding(
      padding: const EdgeInsets.only(bottom: _bottomSheetHeight),
      child: body,
    ),
    bottomSheet: _bottomSheet,
  );
}

Scaffold buildAdminProfileScaffold(
    {required BuildContext context, required Widget body}) {
  final account = context.watch<AccountModel>();
  final style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary);

  return Scaffold(
    appBar: AppBar(
      title: InkWell(
        child: const Text(constants.homePageAppBarName),
        onTap: () {
          Navigator.pushNamed(context, constants.routeHome);
        },
      ),
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
              "ADMIN",
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
            leading: const Icon(Icons.abc),
            title: Text(S.of(context).freeLessonInfo),
            onTap: () {
              Navigator.pushNamed(context, constants.routeFreeLesson);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(S.of(context).manageProfile),
            onTap: () {
              Navigator.pushNamed(context, constants.routeManageUsers);
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
    body: Padding(
      padding: const EdgeInsets.only(bottom: _bottomSheetHeight),
      child: body,
    ),
    bottomSheet: _bottomSheet,
  );
}

BottomSheet _bottomSheet = BottomSheet(
  onClosing: () {},
  builder: (context) => SizedBox(
    width: double.infinity,
    height: _bottomSheetHeight,
    child: Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).businessName,
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(width: 10),
                InkWell(
                  child: Text(
                    S.of(context).termsOfUse,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, constants.routeInfo);
                  },
                ),
                const SizedBox(width: 100),
                InkWell(
                  child: const Icon(
                    FontAwesomeIcons.instagram,
                    size: 20,
                  ),
                  onTap: () {
                    html.window.open(
                        'https://www.instagram.com/successacademy_7/',
                        'Success Academy');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../account/data/account_model.dart';
import '../../account/widgets/manage_users_page.dart';
import '../../account/widgets/settings_page.dart';
import '../../calendar/widgets/calendar_view.dart';
import '../../generated/l10n.dart';
import '../../lesson_info/widgets/lesson_info_page.dart';
import '../../profile/widgets/add_points_page.dart';
import '../../profile/widgets/profile_home_page.dart';

class PhoneScaffold extends StatefulWidget {
  const PhoneScaffold({super.key});

  @override
  State<PhoneScaffold> createState() => _PhoneScaffoldState();
}

class _PhoneScaffoldState extends State<PhoneScaffold> {
  late final List<Widget> _content;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    switch (context.read<AccountModel>().userType) {
      case UserType.admin:
        _content = [
          const ProfileHomePage(),
          const CalendarView(),
          const LessonInfoPage(),
          const ManageUsersPage(),
          const SettingsPage(),
        ];
        break;
      case UserType.teacher:
        _content = [
          const ProfileHomePage(),
          const CalendarView(),
          const LessonInfoPage(),
          const SettingsPage(),
        ];
        break;
      case UserType.student:
        _content = [
          const ProfileHomePage(),
          const CalendarView(),
          const LessonInfoPage(),
          const AddPointsPage(),
          const SettingsPage(),
        ];
        break;
      default:
        _content = [];
        break;
    }
  }

  void _drawerItemOnClick(int i) {
    setState(() {
      _selectedIndex = i;
      Navigator.pop(context);
    });
  }

  List<ListTile> _getDestinations() {
    switch (context.watch<AccountModel>().userType) {
      case UserType.admin:
        return [
          ListTile(
            leading: const Icon(Icons.account_box),
            title: Text(S.of(context).viewProfile),
            onTap: () => _drawerItemOnClick(0),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(S.of(context).lessonCalendar),
            onTap: () => _drawerItemOnClick(1),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(S.of(context).lessonInfo),
            onTap: () => _drawerItemOnClick(2),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(S.of(context).manageProfile),
            onTap: () => _drawerItemOnClick(3),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(S.of(context).settings),
            onTap: () => _drawerItemOnClick(4),
          ),
        ];
      case UserType.teacher:
        return [
          ListTile(
            leading: const Icon(Icons.account_box),
            title: Text(S.of(context).viewProfile),
            onTap: () => _drawerItemOnClick(0),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(S.of(context).lessonCalendar),
            onTap: () => _drawerItemOnClick(1),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(S.of(context).lessonInfo),
            onTap: () => _drawerItemOnClick(2),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(S.of(context).settings),
            onTap: () => _drawerItemOnClick(3),
          ),
        ];
      case UserType.student:
        return [
          ListTile(
            leading: const Icon(Icons.account_box),
            title: Text(S.of(context).viewProfile),
            onTap: () => _drawerItemOnClick(0),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(S.of(context).lessonCalendar),
            onTap: () => _drawerItemOnClick(1),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(S.of(context).lessonInfo),
            onTap: () => _drawerItemOnClick(2),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(S.of(context).addPoints),
            onTap: () => _drawerItemOnClick(3),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(S.of(context).settings),
            onTap: () => _drawerItemOnClick(4),
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 1,
        title: Image.asset(
          'assets/images/logo.png',
          width: 40,
          height: 40,
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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text(S.of(context).signOut),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: _getDestinations(),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _content,
      ),
      bottomSheet: account.shouldShowContent()
          ? null
          : MaterialBanner(
              leading: const Icon(Icons.block),
              content: Text(S.of(context).noPlan),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              actions: [
                FilledButton.tonal(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Text(S.of(context).addPlan),
                )
              ],
            ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/account/account_settings.dart';
import 'package:success_academy/calendar/calendar.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/free_lesson.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/add_points.dart';
import 'package:success_academy/profile/profile_home.dart';
import 'package:success_academy/profile/profile_manage.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key, required this.userType});

  final UserType userType;

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  List<Widget> _content = [];
  int _selectedIndex = 0;
  bool _extended = false;

  @override
  void initState() {
    super.initState();
    switch (widget.userType) {
      case UserType.admin:
        _content = [
          const ProfileHome(),
          const Calendar(),
          const FreeLesson(),
          const ManageUsers(),
          const Settings()
        ];
        break;
      case UserType.teacher:
        _content = [
          const ProfileHome(),
          const Calendar(),
          const FreeLesson(),
          const Settings()
        ];
        break;
      case UserType.student:
        _content = [
          const ProfileHome(),
          const Calendar(),
          const FreeLesson(),
          const AddPoints(),
          const Settings()
        ];
        break;
      default:
        _content = [];
        break;
    }
  }

  List<NavigationRailDestination> _getDestinations() {
    switch (widget.userType) {
      case UserType.admin:
        return [
          NavigationRailDestination(
            icon: const Icon(Icons.account_box_outlined),
            selectedIcon: const Icon(Icons.account_box),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).viewProfile),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).lessonCalendar),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.info_outline),
            selectedIcon: const Icon(Icons.info),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).freeLessonInfo),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.people_outlined),
            selectedIcon: const Icon(Icons.people),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).manageProfile),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).settings),
          ),
        ];
      case UserType.teacher:
        return [
          NavigationRailDestination(
            icon: const Icon(Icons.account_box_outlined),
            selectedIcon: const Icon(Icons.account_box),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).viewProfile),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).lessonCalendar),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.info_outline),
            selectedIcon: const Icon(Icons.info),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).freeLessonInfo),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).settings),
          ),
        ];
      case UserType.student:
        return [
          NavigationRailDestination(
            icon: const Icon(Icons.account_box_outlined),
            selectedIcon: const Icon(Icons.account_box),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).viewProfile),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).lessonCalendar),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.info_outline),
            selectedIcon: const Icon(Icons.info),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).freeLessonInfo),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.add_box_outlined),
            selectedIcon: const Icon(Icons.add_outlined),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).addPoints),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            padding: const EdgeInsets.symmetric(vertical: 5),
            label: Text(S.of(context).settings),
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
        title: const Text(constants.homePageAppBarName),
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
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: IconButton(
                    onPressed: () => setState(() {
                      _extended = !_extended;
                    }),
                    icon: Icon(_extended
                        ? Icons.arrow_back_ios_new
                        : Icons.arrow_forward_ios),
                  ),
                ),
                Expanded(
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    extended: _extended,
                    backgroundColor: Theme.of(context).backgroundColor,
                    groupAlignment: -0.8,
                    onDestinationSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    selectedLabelTextStyle: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    unselectedLabelTextStyle:
                        Theme.of(context).textTheme.labelLarge,
                    destinations: _getDestinations(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _content,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';

class MyScaffold extends StatefulWidget {
  const MyScaffold({super.key, required this.userType, required this.body});

  final Widget body;
  final UserType userType;

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  static const _breakpointExpanded = 1200;

  int _selectedIndex = 0;

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
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              extended: MediaQuery.of(context).size.width > _breakpointExpanded,
              backgroundColor: Theme.of(context).backgroundColor,
              groupAlignment: -0.5,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedLabelTextStyle: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold),
              unselectedLabelTextStyle: Theme.of(context).textTheme.labelLarge,
              destinations: [
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
              ],
            ),
          ),
          Expanded(
            child: widget.body,
          ),
        ],
      ),
    );
  }
}

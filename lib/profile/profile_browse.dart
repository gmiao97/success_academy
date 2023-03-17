import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;

// TODO: Make UI responsive for different screen sizes
class ProfileBrowse extends StatefulWidget {
  const ProfileBrowse({Key? key}) : super(key: key);

  @override
  State<ProfileBrowse> createState() => _ProfileBrowseState();
}

class _ProfileBrowseState extends State<ProfileBrowse> {
  List<StudentProfileModel> _studentProfiles = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initProfiles();
  }

  void initProfiles() async {
    final account = context.watch<AccountModel>();
    final studentProfiles = await profile_service
        .getStudentProfilesForUser(account.firebaseUser!.uid);
    setState(() {
      _studentProfiles = studentProfiles;
    });
  }

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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text(S.of(context).signOut),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).selectProfile,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 50),
            // TODO: Add error handling.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final profile in _studentProfiles)
                  _buildProfileCard(context, profile),
                _studentProfiles.length < constants.maxProfileCount
                    ? const _AddProfileWidget()
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Card _buildProfileCard(BuildContext context, StudentProfileModel profile) {
  final account = context.watch<AccountModel>();

  return Card(
    elevation: 10,
    child: InkWell(
      splashColor: Theme.of(context).colorScheme.primary.withAlpha(30),
      onTap: () {
        account.studentProfile = profile;
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width < 700 ? 100 : 200,
        height: MediaQuery.of(context).size.width < 700 ? 100 : 200,
        child: Center(
          child: Text(profile.firstName,
              style: Theme.of(context).textTheme.headlineMedium),
        ),
      ),
    ),
  );
}

class _AddProfileWidget extends StatelessWidget {
  const _AddProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.primary.withAlpha(30),
        onTap: () {
          Navigator.pushNamed(context, constants.routeCreateProfile);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width < 700 ? 100 : 200,
          height: MediaQuery.of(context).size.width < 700 ? 100 : 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: 50,
              ),
              Text(S.of(context).addProfile),
            ],
          ),
        ),
      ),
    );
  }
}

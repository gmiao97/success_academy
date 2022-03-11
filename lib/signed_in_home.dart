import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/profile/profile_model.dart';

class SignedInHome extends StatelessWidget {
  const SignedInHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    final profile = context
        .select<AccountModel, ProfileModel?>((account) => account.profile);

    if (profile == null) {
      return const ProfileBrowse();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.homePageAppBarName),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            style: style,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text(constants.signOutText),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Text(
              'Hi, my name is ${profile.firstName} ${profile.lastName} and I\'m in grade ${profile.studentProfile.dateOfBirth} and my referral code is ${profile.referralCode}'),
        ),
      ),
    );
  }
}

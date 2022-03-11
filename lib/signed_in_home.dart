import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account_model.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/utils.dart' as utils;

class SignedInHome extends StatelessWidget {
  const SignedInHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = context
        .select<AccountModel, ProfileModel?>((account) => account.profile);

    if (profile == null) {
      return const ProfileBrowse();
    }
    return utils.buildLoggedInScaffold(
      context,
      Center(
        child: SizedBox(
          width: 500,
          child: Text(
              'Hi, my name is ${profile.firstName} ${profile.lastName} and I\'m in grade ${profile.studentProfile.dateOfBirth} and my referral code is ${profile.referralCode}'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account_model.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/utils.dart' as utils;

class SignedInHome extends StatelessWidget {
  const SignedInHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AccountModel>();

    if (user.profile == null) {
      return const ProfileBrowse();
    }
    return utils.buildLoggedInScaffold(
      context: context,
      body: Center(
        child: SizedBox(
          width: 500,
          child: Text(
              'Hi, my name is ${user.profile?.firstName} ${user.profile?.lastName} and I\'m in grade ${user.profile?.studentProfile.dateOfBirth} and my referral code is ${user.myUser?.referralCode}'),
        ),
      ),
    );
  }
}

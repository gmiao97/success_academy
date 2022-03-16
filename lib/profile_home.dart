import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/utils.dart' as utils;

class ProfileHome extends StatelessWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    if (account.profile == null) {
      return const ProfileBrowse();
    }
    return utils.buildProfileScaffold(
      context: context,
      body: Center(
        child: SizedBox(
          width: 500,
          child: Text(
              'Hi, my name is ${account.profile?.firstName} ${account.profile?.lastName} and I\'m in grade ${account.profile?.studentProfile.dateOfBirth} and my referral code is ${account.myUser?.referralCode} and profile id is ${account.profile?.profileId}'),
        ),
      ),
    );
  }
}

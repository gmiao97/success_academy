import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/utils.dart' as utils;

class ProfileHome extends StatelessWidget {
  const ProfileHome({Key? key}) : super(key: key);

  Future<bool> hasSubscription(
      {required String userId, required String profileId}) async {
    final subscriptionsQuery = await FirebaseFirestore.instance
        .collection('customers')
        .doc(userId)
        .collection('subscriptions')
        .where('status', whereIn: ['trialing', 'active']).get();
    // Subscription metadata is written create profile widget.
    return subscriptionsQuery.docs.any((subscriptionDoc) =>
        subscriptionDoc.get('metadata.profile_id') as String == profileId);
  }

  void redirectToStripePortal() async {
    HttpsCallable getStripePortalCallable =
        FirebaseFunctions.instanceFor(region: 'us-west2')
            .httpsCallable('ext-firestore-stripe-payments-createPortalLink');
    try {
      final data = await getStripePortalCallable
          .call(<String, dynamic>{'returnUrl': html.window.location.origin});
      html.window.location.assign(data.data['url']);
    } catch (e) {
      // Collect client error logs to be viewable.
      debugPrint(e.toString());
    }
  }

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
          width: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).profile,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 25),
              RichText(
                text: TextSpan(
                  text: '${S.of(context).name}     ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text:
                          '${account.profile?.lastName}, ${account.profile?.firstName}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              RichText(
                text: TextSpan(
                  text: '${S.of(context).dateOfBirthLabel}     ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: constants.dateFormatter
                          .format(account.profile!.studentProfile.dateOfBirth),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              RichText(
                text: TextSpan(
                  text: '${S.of(context).myCode}     ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: account.myUser?.referralCode,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: account.myUser?.referralCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).copied),
                    ),
                  );
                },
                child: Text(S.of(context).copy),
              ),
              const SizedBox(height: 25),
              const Divider(),
              const SizedBox(height: 25),
              Text(
                S.of(context).manageSubscription,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 25),
              // BUG: Can't differentiate between multiple profile subscriptions.
              FutureBuilder<bool>(
                future: hasSubscription(
                    profileId: account.profile!.profileId,
                    userId: account.user!.uid),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Profile has subscription
                    if (snapshot.data == true) {
                      return ElevatedButton(
                        onPressed: () {
                          redirectToStripePortal();
                        },
                        child: Text(S.of(context).manageSubscription),
                      );
                    }
                    // TODO: Add redirect to purchase subscription
                    return const Text('No subscription');
                  }
                  return const CircularProgressIndicator(value: null);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

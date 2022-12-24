import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/profile/profile_create.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:success_academy/services/user_service.dart' as user_service;
import 'package:success_academy/services/stripe_service.dart' as stripe_service;
import 'package:success_academy/utils.dart' as utils;

class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  bool _stripeRedirectClicked = false;
  SubscriptionPlan? _subscriptionPlan = SubscriptionPlan.minimum;
  late final List<String> _referralCodes;
  bool _isReferral = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _referralCodes = await user_service.getMyUserReferralCodes();
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    if (account.userType == UserType.admin) {
      return utils.buildAdminProfileScaffold(
        context: context,
        body: Center(
          child: Text(
            'ADMIN',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      );
    }

    if (account.userType == UserType.teacher) {
      return utils.buildTeacherProfileScaffold(
        context: context,
        body: Center(
          child: SizedBox(
            width: 700,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).teacherProfile,
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
                            '${account.teacherProfile?.lastName}, ${account.teacherProfile?.firstName}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (account.userType == UserType.studentNoProfile) {
      return const ProfileBrowse();
    }
    return utils.buildStudentProfileScaffold(
      context: context,
      body: Center(
        child: SizedBox(
          width: 700,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).studentProfile,
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
                            '${account.studentProfile?.lastName}, ${account.studentProfile?.firstName}',
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
                            .format(account.studentProfile!.dateOfBirth),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                RichText(
                  text: TextSpan(
                    text: '${S.of(context).eventPointsLabel}     ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: '${account.studentProfile!.numPoints}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
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
                FutureBuilder<SubscriptionPlan?>(
                  future: profile_service.getSubscriptionTypeForProfile(
                      profileId: account.studentProfile!.profileId,
                      userId: account.firebaseUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // Profile has subscription
                      if (snapshot.data != null) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getSubscriptionPlanName(context, snapshot.data),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const SizedBox(height: 25),
                            RichText(
                              text: TextSpan(
                                text: '${S.of(context).myCode}     ',
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                    text: account.myUser?.referralCode,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: account.myUser?.referralCode));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(S.of(context).copied),
                                  ),
                                );
                              },
                              child: Text(S.of(context).copy),
                            ),
                            const SizedBox(height: 25),
                            _stripeRedirectClicked
                                ? const CircularProgressIndicator(value: null)
                                : ElevatedButton(
                                    child:
                                        Text(S.of(context).manageSubscription),
                                    onPressed: () {
                                      setState(() {
                                        _stripeRedirectClicked = true;
                                      });
                                      stripe_service.redirectToStripePortal();
                                    },
                                  ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getSubscriptionPlanName(context, snapshot.data),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 25),
                          StripeSubscriptionCreate(
                            subscriptionPlan: _subscriptionPlan,
                            stripeRedirectClicked: _stripeRedirectClicked,
                            onSubscriptionChange: (selectedSubscription) {
                              setState(() {
                                _subscriptionPlan = selectedSubscription;
                              });
                            },
                            setReferral: (code) {
                              if (_referralCodes.contains(code) &&
                                  account.myUser!.referralCode != code) {
                                _isReferral = true;
                                return true;
                              }
                              return false;
                            },
                            onStripeSubmitClicked: () async {
                              setState(() {
                                _stripeRedirectClicked = true;
                              });
                              // TODO: No trial (+reinitiation fee?) for people who already had trial
                              try {
                                await stripe_service
                                    .startStripeSubscriptionCheckoutSession(
                                  userId: account.firebaseUser!.uid,
                                  profileId: account.studentProfile!.profileId,
                                  subscriptionPlan: _subscriptionPlan!,
                                  isReferral: _isReferral,
                                );
                              } catch (e) {
                                setState(() {
                                  _stripeRedirectClicked = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                        ],
                      );
                    }
                    return const CircularProgressIndicator(value: null);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

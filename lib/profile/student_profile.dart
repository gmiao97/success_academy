import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:success_academy/services/stripe_service.dart' as stripe_service;
import 'package:success_academy/services/user_service.dart' as user_service;

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  bool _redirectClicked = false;
  bool _isReferral = false;
  String? _referrer;
  SubscriptionPlan _subscriptionPlan = SubscriptionPlan.minimum;

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                S.of(context).profile,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FilledButton.icon(
                icon: const Icon(Icons.rotate_left),
                label: Text(S.of(context).switchProfile),
                onPressed: () {
                  account.studentProfile = null;
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 30,
                        child: Text(account.studentProfile!.lastName[0],
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${account.studentProfile!.lastName}, ${account.studentProfile!.firstName}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      S.of(context).student,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Divider(),
                    RichText(
                      text: TextSpan(
                        text: '${S.of(context).dateOfBirthLabel} - ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: constants.dateFormatter
                                .format(account.studentProfile!.dateOfBirth),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '${S.of(context).eventPointsLabel} - ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: '${account.studentProfile!.numPoints}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '${S.of(context).myCode} - ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: account.myUser?.referralCode,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: account.myUser!.referralCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).copied),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy),
                        )
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        text: '${S.of(context).referrerLabel} - ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: account.studentProfile!.referrer ?? '',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    account.subscriptionPlan != null
                        ? ManageSubscription(
                            subscriptionPlan: account.subscriptionPlan!,
                          )
                        : CreateSubscription(
                            subscriptionPlan: _subscriptionPlan,
                            onSubscriptionPlanChange: (subscription) {
                              setState(() {
                                _subscriptionPlan = subscription!;
                              });
                            },
                            redirectClicked: _redirectClicked,
                            setIsReferral: (isReferral) {
                              _isReferral = isReferral;
                            },
                            setReferrer: (name) {
                              _referrer = name;
                            },
                            onStripeSubmitClicked: () async {
                              setState(() {
                                _redirectClicked = true;
                              });
                              final updatedStudentProfile =
                                  account.studentProfile!;
                              updatedStudentProfile.referrer = _referrer;
                              try {
                                await profile_service.updateStudentProfile(
                                    account.firebaseUser!.uid,
                                    updatedStudentProfile);
                                account.studentProfile = updatedStudentProfile;
                                await stripe_service
                                    .startStripeSubscriptionCheckoutSession(
                                  userId: account.firebaseUser!.uid,
                                  profileId: account.studentProfile!.profileId,
                                  subscriptionPlan: _subscriptionPlan,
                                  isReferral: _isReferral,
                                );
                              } catch (e) {
                                setState(() {
                                  _redirectClicked = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        S.of(context).stripeRedirectFailure),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                );
                                debugPrint(
                                    'Failed to start Stripe subscription checkout $e');
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ManageSubscription extends StatefulWidget {
  final SubscriptionPlan subscriptionPlan;

  const ManageSubscription({
    super.key,
    required this.subscriptionPlan,
  });

  @override
  State<ManageSubscription> createState() => _ManageSubscriptionState();
}

class _ManageSubscriptionState extends State<ManageSubscription> {
  bool _redirectClicked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).manageSubscription,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              getSubscriptionPlanName(context, widget.subscriptionPlan),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Row(
              children: [
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.exit_to_app),
                  label: Text(S.of(context).manageSubscription),
                  onPressed: _redirectClicked
                      ? null
                      : () {
                          setState(() {
                            _redirectClicked = true;
                          });
                          try {
                            stripe_service.redirectToStripePortal();
                          } catch (e) {
                            setState(() {
                              _redirectClicked = false;
                            });
                          }
                        },
                ),
                if (_redirectClicked)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreateSubscription extends StatefulWidget {
  final SubscriptionPlan subscriptionPlan;
  final Function(SubscriptionPlan?) onSubscriptionPlanChange;
  final bool redirectClicked;
  final Function(bool) setIsReferral;
  final Function(String?) setReferrer;
  final VoidCallback onStripeSubmitClicked;

  const CreateSubscription({
    super.key,
    required this.subscriptionPlan,
    required this.onSubscriptionPlanChange,
    required this.redirectClicked,
    required this.setIsReferral,
    required this.setReferrer,
    required this.onStripeSubmitClicked,
  });

  @override
  State<CreateSubscription> createState() => _CreateSubscriptionState();
}

class _CreateSubscriptionState extends State<CreateSubscription> {
  final List<String> _validCodes = [];
  final List<String> _thirtyOffCodes = ['TXFOLTBJ'];
  bool _isReferral = false;
  bool _invalidReferral = false;
  bool _termsOfUseChecked = false;
  bool _redirectClicked = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _validCodes.addAll(await user_service.getReferralCodes());
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.exit_to_app),
                  label: Text(S.of(context).managePayment),
                  onPressed: _redirectClicked
                      ? null
                      : () {
                          setState(() {
                            _redirectClicked = true;
                          });
                          try {
                            stripe_service.redirectToStripePortal();
                          } catch (e) {
                            setState(() {
                              _redirectClicked = false;
                            });
                          }
                        },
                ),
                if (_redirectClicked)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              S.of(context).pickPlan,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<SubscriptionPlan>(
                  title: Text(S.of(context).minimumCourse),
                  value: SubscriptionPlan.minimum,
                  groupValue: widget.subscriptionPlan,
                  onChanged: widget.onSubscriptionPlanChange,
                ),
                RadioListTile<SubscriptionPlan>(
                  title: Text(S.of(context).minimumPreschoolCourse),
                  value: SubscriptionPlan.minimumPreschool,
                  groupValue: widget.subscriptionPlan,
                  onChanged: widget.onSubscriptionPlanChange,
                ),
                RadioListTile<SubscriptionPlan>(
                  title: Text(S.of(context).monthlyCourse),
                  value: SubscriptionPlan.monthly,
                  groupValue: widget.subscriptionPlan,
                  onChanged: widget.onSubscriptionPlanChange,
                ),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: const Icon(Icons.percent),
                labelText: S.of(context).referralLabel,
                errorText:
                    _invalidReferral ? S.of(context).referralValidation : null,
                suffixIcon: _isReferral
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _isReferral = _validCodes.contains(value) &&
                      account.myUser!.referralCode != value;
                  widget.setIsReferral(_isReferral);
                  _invalidReferral = value.isNotEmpty && !_isReferral;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: const Icon(Icons.person_add_alt),
                labelText: S.of(context).referrerLabel,
                hintText: S.of(context).referrerHint,
              ),
              onChanged: (value) => widget.setReferrer(value),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Checkbox(
                  value: _termsOfUseChecked,
                  onChanged: (value) {
                    setState(() {
                      _termsOfUseChecked = value ?? false;
                    });
                  },
                ),
                InkWell(
                  child: Text(
                    S.of(context).agreeToTerms,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, constants.routeInfo);
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              S.of(context).freeTrial,
            ),
            Text(
              S.of(context).signUpFee,
              style: _isReferral
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
            if (_isReferral) Text(S.of(context).signUpFeeDiscount),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  FilledButton.tonalIcon(
                    label: Text(S.of(context).stripePurchase),
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: widget.redirectClicked || !_termsOfUseChecked
                        ? null
                        : widget.onStripeSubmitClicked,
                  ),
                  if (widget.redirectClicked)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

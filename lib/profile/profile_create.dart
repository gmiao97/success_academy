import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:success_academy/services/stripe_service.dart' as stripe_service;
import 'package:success_academy/utils.dart' as utils;

// TODO: Initiation fee
// TODO: Welcome email
class ProfileCreate extends StatelessWidget {
  const ProfileCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    if (account.authStatus == AuthStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    }
    if (account.authStatus == AuthStatus.signedOut) {
      return const HomePage();
    }
    if (account.authStatus == AuthStatus.emailVerification) {
      return const EmailVerificationPage();
    }
    return utils.buildLoggedInScaffold(
        context: context,
        body: Center(
          child: Column(
            children: [
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  child: Text(S.of(context).goBack),
                ),
                margin: const EdgeInsets.all(10),
              ),
              Card(
                child: Container(
                  width: 700,
                  height: 700,
                  padding: const EdgeInsets.all(20),
                  child: const _SignupForm(),
                ),
              ),
            ],
          ),
        ));
  }
}

class _SignupForm extends StatefulWidget {
  const _SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final StudentProfileModel _profileModel = StudentProfileModel();
  SubscriptionPlan? _subscriptionPlan = SubscriptionPlan.minimum;
  bool _stripeRedirectClicked = false;

  @override
  void initState() {
    super.initState();
    _profileModel.dateOfBirth = DateTime.now();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? dateOfBirth = await showDatePicker(
        context: context,
        initialDate: _profileModel.dateOfBirth,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (dateOfBirth != null) {
      setState(() {
        _dateOfBirthController.text = dateFormatter.format(dateOfBirth);
        _profileModel.dateOfBirth = dateOfBirth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).createProfile,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 25),
          TextFormField(
            decoration: InputDecoration(
              icon: const Icon(Icons.account_circle),
              labelText: S.of(context).lastNameLabel,
              hintText: S.of(context).lastNameHint,
            ),
            onChanged: (value) {
              setState(() {
                _profileModel.lastName = value;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return S.of(context).lastNameValidation;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              icon: const Icon(Icons.account_circle),
              labelText: S.of(context).firstNameLabel,
              hintText: S.of(context).firstNameHint,
            ),
            onChanged: (value) {
              setState(() {
                _profileModel.firstName = value;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return S.of(context).firstNameValidation;
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.datetime,
            readOnly: true,
            controller: _dateOfBirthController,
            decoration: InputDecoration(
              icon: const Icon(Icons.calendar_month),
              labelText: S.of(context).dateOfBirthLabel,
            ),
            onTap: () {
              _selectDate(context);
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return S.of(context).dateOfBirthValidation;
              }
              return null;
            },
          ),
          StripeSubscriptionCreate(
            subscriptionPlan: _subscriptionPlan,
            stripeRedirectClicked: _stripeRedirectClicked,
            onSubscriptionChange: (selectedSubscription) {
              setState(() {
                _subscriptionPlan = selectedSubscription;
              });
            },
            onStripeSubmitClicked: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _stripeRedirectClicked = true;
                });
                final profileDoc = await profile_service.addStudentProfile(
                    account.firebaseUser!.uid, _profileModel);
                await stripe_service.startStripeSubscriptionCheckoutSession(
                  userId: account.firebaseUser!.uid,
                  profileId: profileDoc.id,
                  subscriptionPlan: _subscriptionPlan!,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

typedef _SubscriptionChangedCallback = Function(SubscriptionPlan?);

class StripeSubscriptionCreate extends StatelessWidget {
  const StripeSubscriptionCreate({
    Key? key,
    required this.subscriptionPlan,
    required this.stripeRedirectClicked,
    required this.onSubscriptionChange,
    required this.onStripeSubmitClicked,
  }) : super(key: key);

  final SubscriptionPlan? subscriptionPlan;
  final bool stripeRedirectClicked;
  final _SubscriptionChangedCallback onSubscriptionChange;
  final VoidCallback onStripeSubmitClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            S.of(context).pickPlan,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Column(
          children: [
            RadioListTile<SubscriptionPlan>(
              title: Text(S.of(context).minimumCourse),
              value: SubscriptionPlan.minimum,
              groupValue: subscriptionPlan,
              onChanged: onSubscriptionChange,
            ),
            RadioListTile<SubscriptionPlan>(
              title: Text(S.of(context).minimumPreschoolCourse),
              value: SubscriptionPlan.minimumPreschool,
              groupValue: subscriptionPlan,
              onChanged: onSubscriptionChange,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: stripeRedirectClicked
              ? const CircularProgressIndicator(value: null)
              : ElevatedButton.icon(
                  label: Text(S.of(context).stripePurchase),
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: onStripeSubmitClicked,
                ),
        ),
      ],
    );
  }
}

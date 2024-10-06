import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:success_academy/services/stripe_service.dart' as stripe_service;

import '../account/account_model.dart';
import '../constants.dart';
import '../generated/l10n.dart';
import 'profile_model.dart';
import 'student_profile.dart';

class ProfileCreate extends StatelessWidget {
  const ProfileCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.maybePop(context);
                },
                label: Text(S.of(context).goBack),
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            Card(
              child: Container(
                width: 700,
                padding: const EdgeInsets.all(20),
                child: const _SignupForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignupForm extends StatefulWidget {
  const _SignupForm();

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final StudentProfileModel _profileModel = StudentProfileModel();
  SubscriptionPlan _subscriptionPlan = SubscriptionPlan.minimum;
  bool _isReferral = false;
  bool _redirectClicked = false;

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
              icon: const Icon(Icons.account_box),
              labelText: S.of(context).lastNameLabel,
              hintText: S.of(context).lastNameHint,
            ),
            onChanged: (value) {
              _profileModel.lastName = value;
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
              icon: const Icon(Icons.account_box),
              labelText: S.of(context).firstNameLabel,
              hintText: S.of(context).firstNameHint,
            ),
            onChanged: (value) {
              _profileModel.firstName = value;
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
          const SizedBox(height: 20),
          CreateSubscription(
            subscriptionPlan: _subscriptionPlan,
            redirectClicked: _redirectClicked,
            onSubscriptionPlanChange: (selectedSubscription) {
              setState(() {
                _subscriptionPlan = selectedSubscription!;
              });
            },
            setIsReferral: (isReferral) {
              _isReferral = isReferral;
            },
            setReferrer: (name) {
              _profileModel.referrer = name;
            },
            onStripeSubmitClicked: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _redirectClicked = true;
                });
                _profileModel.email = account.myUser!.email;
                final profileDoc = await profile_service.addStudentProfile(
                    account.firebaseUser!.uid, _profileModel);
                try {
                  await stripe_service.startStripeSubscriptionCheckoutSession(
                    userId: account.firebaseUser!.uid,
                    profileId: profileDoc.id,
                    subscriptionPlan: _subscriptionPlan,
                    isReferral: _isReferral,
                  );
                } catch (err) {
                  setState(() {
                    _redirectClicked = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).stripeRedirectFailure),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  });
                  debugPrint(
                      'Failed to start Stripe subscription checkout $err');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

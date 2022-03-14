import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/utils.dart' as utils;

class ProfileCreate extends StatelessWidget {
  const ProfileCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    if (account.authStatus == AuthStatus.signedOut) {
      return const HomePage();
    }
    if (account.authStatus == AuthStatus.emailVerification) {
      return const EmailVerificationPage();
    }
    return utils.buildLoggedInScaffold(
      context: context,
      body: Center(
        child: Card(
          child: Container(
            width: 700,
            height: 700,
            padding: const EdgeInsets.all(20),
            child: const _SignupForm(),
          ),
        ),
      ),
    );
  }
}

// Corresponds to metadata field 'id' in price in Stripe dashboard
enum _SubscriptionPlan { minimum, minimumPreschool }

class _SignupForm extends StatefulWidget {
  const _SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final ProfileModel _profileModel = ProfileModel();
  _SubscriptionPlan? _subscriptionPlan = _SubscriptionPlan.minimum;
  bool _stripeRedirectClicked = false;

  void _selectDate(BuildContext context) async {
    final DateTime? dateOfBirth = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (dateOfBirth != null) {
      setState(() {
        _dateOfBirthController.text =
            constants.dateFormatter.format(dateOfBirth);
        _profileModel.studentProfile.dateOfBirth = dateOfBirth;
      });
    }
  }

  Future<void> _startStripeSubscriptionCheckoutSession(
      {required String uid, required String profileId}) async {
    String? selectedPriceId;
    final stripeProductsDocList = await FirebaseFirestore.instance
        .collection('products')
        .where('active', isEqualTo: true)
        .get()
        .then((query) => query.docs);
    for (final productDoc in stripeProductsDocList) {
      final stripePricesDocList = await productDoc.reference
          .collection('prices')
          .get()
          .then((query) => query.docs);
      for (final priceDoc in stripePricesDocList) {
        if (priceDoc.get('metadata.id') ==
            EnumToString.convertToString(_subscriptionPlan)) {
          selectedPriceId = priceDoc.id;
        }
      }
    }

    final checkoutSessionDoc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .collection('checkout_sessions')
        .add(
      {
        'price': selectedPriceId,
        'success_url': html.window.location.origin,
        'cancel_url': html.window.location.origin,
        'metadata': {
          'profile_id': profileId,
        },
      },
    );
    checkoutSessionDoc.snapshots().listen(
      (doc) {
        if (doc.data()!.containsKey('url')) {
          html.window.location.replace(doc.data()!['url']);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountModel>();

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              S.of(context).pickPlan,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Column(
            children: [
              RadioListTile<_SubscriptionPlan>(
                title: Text(S.of(context).minimumCourse),
                value: _SubscriptionPlan.minimum,
                groupValue: _subscriptionPlan,
                onChanged: (value) {
                  setState(() {
                    _subscriptionPlan = value;
                  });
                },
              ),
              RadioListTile<_SubscriptionPlan>(
                title: Text(S.of(context).minimumPreschoolCourse),
                value: _SubscriptionPlan.minimumPreschool,
                groupValue: _subscriptionPlan,
                onChanged: (value) {
                  setState(() {
                    _subscriptionPlan = value;
                  });
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: _stripeRedirectClicked
                ? const CircularProgressIndicator(value: null)
                : ElevatedButton.icon(
                    label: Text(S.of(context).stripePurchase),
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _stripeRedirectClicked = true;
                        });
                        final profileDoc =
                            await getProfileModelRefForUser(account.user!.uid)
                                .add(_profileModel);
                        await _startStripeSubscriptionCheckoutSession(
                            uid: account.user!.uid, profileId: profileDoc.id);
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/constants.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;
import 'package:success_academy/services/user_service.dart' as user_service;
import 'package:success_academy/services/stripe_service.dart' as stripe_service;
import 'package:success_academy/utils.dart' as utils;

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
          child: SingleChildScrollView(
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
                    padding: const EdgeInsets.all(20),
                    child: const _SignupForm(),
                  ),
                ),
              ],
            ),
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
  late final List<String> _referralCodes;
  final StudentProfileModel _profileModel = StudentProfileModel();
  SubscriptionPlan? _subscriptionPlan = SubscriptionPlan.minimum;
  bool _isReferral = false;
  bool _stripeRedirectClicked = false;

  @override
  void initState() {
    super.initState();
    _init();
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

  void _init() async {
    _referralCodes = await user_service.getMyUserReferralCodes();
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
            setReferral: (code) {
              if (_referralCodes.contains(code) &&
                  account.myUser!.referralCode != code) {
                _isReferral = true;
                return true;
              }
              return false;
            },
            setReferrer: (name) {
              setState(() {
                _profileModel.referrer = name;
              });
            },
            onStripeSubmitClicked: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _stripeRedirectClicked = true;
                });
                final profileDoc = await profile_service.addStudentProfile(
                    account.firebaseUser!.uid, _profileModel);
                try {
                  await stripe_service.startStripeSubscriptionCheckoutSession(
                    userId: account.firebaseUser!.uid,
                    profileId: profileDoc.id,
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
              }
            },
          ),
        ],
      ),
    );
  }
}

typedef _SubscriptionChangedCallback = Function(SubscriptionPlan?);

class StripeSubscriptionCreate extends StatefulWidget {
  const StripeSubscriptionCreate({
    Key? key,
    required this.subscriptionPlan,
    required this.stripeRedirectClicked,
    required this.setReferral,
    required this.setReferrer,
    required this.onSubscriptionChange,
    required this.onStripeSubmitClicked,
  }) : super(key: key);

  final SubscriptionPlan? subscriptionPlan;
  final bool stripeRedirectClicked;
  final Function(String?) setReferral;
  final Function(String?) setReferrer;
  final _SubscriptionChangedCallback onSubscriptionChange;
  final VoidCallback onStripeSubmitClicked;

  @override
  State<StripeSubscriptionCreate> createState() =>
      _StripeSubscriptionCreateState();
}

class _StripeSubscriptionCreateState extends State<StripeSubscriptionCreate> {
  final FocusNode _focusNode = FocusNode();
  String? _referralCode;
  bool _showReferralError = false;
  bool _showReferralSucess = false;
  bool _termsOfUseChecked = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final isReferral = widget.setReferral(_referralCode);
        setState(() {
          _showReferralError =
              _referralCode != null && _referralCode!.isNotEmpty && !isReferral;
        });
      }
    });
  }

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
              groupValue: widget.subscriptionPlan,
              onChanged: widget.onSubscriptionChange,
            ),
            RadioListTile<SubscriptionPlan>(
              title: Text(S.of(context).minimumPreschoolCourse),
              value: SubscriptionPlan.minimumPreschool,
              groupValue: widget.subscriptionPlan,
              onChanged: widget.onSubscriptionChange,
            ),
            RadioListTile<SubscriptionPlan>(
              title: Text(S.of(context).monthlyCourse),
              value: SubscriptionPlan.monthly,
              groupValue: widget.subscriptionPlan,
              onChanged: widget.onSubscriptionChange,
            ),
          ],
        ),
        TextFormField(
          focusNode: _focusNode,
          decoration: InputDecoration(
            icon: const Icon(Icons.connect_without_contact),
            labelText: S.of(context).referralLabel,
            errorText:
                _showReferralError ? S.of(context).referralValidation : null,
            suffixIcon: _showReferralSucess
                ? const Icon(Icons.check)
                : const SizedBox(),
          ),
          onChanged: (value) async {
            _referralCode = value;
            final isReferral = await widget.setReferral(_referralCode);
            setState(() {
              _showReferralSucess = isReferral;
            });
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            icon: const Icon(Icons.person_add),
            labelText: S.of(context).referrerLabel,
            hintText: S.of(context).referrerHint,
          ),
          onChanged: (value) => widget.setReferrer(value),
        ),
        const SizedBox(
          height: 25,
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
                Navigator.pushNamed(context, routeInfo);
              },
            )
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          S.of(context).freeTrial,
        ),
        Text(
          S.of(context).signUpFee,
          style: _showReferralSucess
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        _showReferralSucess
            ? Text(S.of(context).signUpFeeDiscount)
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: widget.stripeRedirectClicked
              ? const CircularProgressIndicator(value: null)
              : ElevatedButton.icon(
                  label: Text(S.of(context).stripePurchase),
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: _termsOfUseChecked &&
                          ((_referralCode != null &&
                                  _referralCode!.isNotEmpty &&
                                  _showReferralSucess) ||
                              (_referralCode == null || _referralCode!.isEmpty))
                      ? widget.onStripeSubmitClicked
                      : null,
                ),
        ),
      ],
    );
  }
}

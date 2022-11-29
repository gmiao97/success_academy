import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_browse.dart';
import 'package:success_academy/services/stripe_service.dart' as stripe_service;
import 'package:success_academy/utils.dart' as utils;

class AddPoints extends StatelessWidget {
  const AddPoints({Key? key}) : super(key: key);

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
    if (account.authStatus == AuthStatus.emailVerification) {
      return const EmailVerificationPage();
    }
    if (account.authStatus == AuthStatus.signedOut) {
      return const HomePage();
    }
    if (account.userType == UserType.studentNoProfile) {
      return const ProfileBrowse();
    }

    return utils.buildStudentProfileScaffold(
        context: context, body: const _AddPointsForm());
  }
}

class _AddPointsForm extends StatefulWidget {
  const _AddPointsForm({Key? key}) : super(key: key);

  @override
  State<_AddPointsForm> createState() => _AddPointsFormState();
}

class _AddPointsFormState extends State<_AddPointsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _stripeRedirectClicked = false;
  int _numPoints = 0;

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Center(
      child: Card(
        child: Container(
          width: 700,
          height: 600,
          padding: const EdgeInsets.all(20),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    S.of(context).addPoints,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    initialValue: _numPoints.toString(),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.add),
                      labelText: S.of(context).eventPointsLabel,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _numPoints = int.parse(value);
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty || value == '0') {
                        return S.of(context).eventPointsValidation;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _stripeRedirectClicked
                      ? const CircularProgressIndicator(value: null)
                      : ElevatedButton.icon(
                          label: Text(S.of(context).stripePointsPurchase),
                          icon: const Icon(Icons.exit_to_app),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _stripeRedirectClicked = true;
                              });
                              try {
                                await stripe_service
                                    .startStripePointsCheckoutSession(
                                        userId: account.firebaseUser!.uid,
                                        quantity: _numPoints);
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
                ],
              )),
        ),
      ),
    );
  }
}

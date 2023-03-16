import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/services/stripe_service.dart' as stripe_service;

class AddPoints extends StatelessWidget {
  const AddPoints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _AddPointsForm();
  }
}

class _AddPointsForm extends StatefulWidget {
  const _AddPointsForm({Key? key}) : super(key: key);

  @override
  State<_AddPointsForm> createState() => _AddPointsFormState();
}

class _AddPointsFormState extends State<_AddPointsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _redirectClicked = false;
  int _numPoints = 100;
  final Map _pointsCouponMap = {
    1000: 'promo_1MaUbkK9gCxRnlEipn32mBEV',
    2000: 'promo_1MaUbzK9gCxRnlEi5Xd3CAdJ',
    5000: 'promo_1MaUc8K9gCxRnlEiiipU5lt3',
    10000: 'promo_1MaUcHK9gCxRnlEiK2ybiGGA',
  };

  void _onPointsChanged(value) {
    setState(() {
      _numPoints = value;
    });
  }

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
                  Column(
                    children: [
                      RadioListTile<int>(
                        title: Text(S.of(context).eventPointsPurchase(100, 10)),
                        value: 100,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title:
                            Text(S.of(context).eventPointsPurchase(1000, 98)),
                        value: 1000,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title:
                            Text(S.of(context).eventPointsPurchase(2000, 194)),
                        value: 2000,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title:
                            Text(S.of(context).eventPointsPurchase(5000, 480)),
                        value: 5000,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title:
                            Text(S.of(context).eventPointsPurchase(10000, 920)),
                        value: 10000,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _redirectClicked
                      ? const CircularProgressIndicator(value: null)
                      : ElevatedButton.icon(
                          label: Text(S.of(context).stripePointsPurchase),
                          icon: const Icon(Icons.exit_to_app),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _redirectClicked = true;
                              });
                              try {
                                await stripe_service
                                    .startStripePointsCheckoutSession(
                                        userId: account.firebaseUser!.uid,
                                        profileId:
                                            account.studentProfile!.profileId,
                                        quantity: _numPoints,
                                        coupon: _pointsCouponMap[_numPoints]);
                              } catch (err) {
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
                                    'Failed to start Stripe points purchase: $err');
                              }
                            }
                          },
                        ),
                ],
              )),
        ),
      ),
    );
  }
}

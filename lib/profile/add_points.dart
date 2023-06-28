import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/services/stripe_service.dart' as stripe_service;

class AddPoints extends StatefulWidget {
  const AddPoints({super.key});

  @override
  State<AddPoints> createState() => _AddPointsState();
}

class _AddPointsState extends State<AddPoints> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const Map<int, String> _pointsCouponMap = {
    700: 'promo_1NNqXoK9gCxRnlEiD3tVodGw',
    1000: 'promo_1MaUbkK9gCxRnlEipn32mBEV',
    1500: 'promo_1NNqYfK9gCxRnlEiHZ0Im4f0',
    2000: 'promo_1MaUbzK9gCxRnlEi5Xd3CAdJ',
    5000: 'promo_1MaUc8K9gCxRnlEiiipU5lt3',
    10000: 'promo_1MaUcHK9gCxRnlEiK2ybiGGA',
  };
  bool _redirectClicked = false;
  int _numPoints = 10;

  void _onPointsChanged(int? value) {
    setState(() {
      _numPoints = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();
    assert(account.userType == UserType.student);

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
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                      text: '${S.of(context).eventPointsLabel}     ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: '${account.studentProfile!.numPoints}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      RadioListTile<int>(
                        title: Text(S.of(context).pointsPurchase(10, 1)),
                        value: 10,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title: Text(S.of(context).pointsPurchase(100, 10)),
                        value: 100,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title: Text(S.of(context).pointsPurchase(700, 69)),
                        value: 700,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title: Text(S.of(context).pointsPurchase(1000, 98)),
                        value: 1000,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title: Text(S.of(context).pointsPurchase(1500, 147)),
                        value: 1500,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title: Text(S.of(context).pointsPurchase(2000, 194)),
                        value: 2000,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title: Text(S.of(context).pointsPurchase(5000, 480)),
                        value: 5000,
                        groupValue: _numPoints,
                        onChanged: _onPointsChanged,
                      ),
                      RadioListTile<int>(
                        title: Text(S.of(context).pointsPurchase(10000, 920)),
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
                      ? const CircularProgressIndicator()
                      : FilledButton.tonalIcon(
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

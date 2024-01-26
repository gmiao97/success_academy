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
  final List<bool> _selectedToggle = [true, false];

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();
    assert(account.userType == UserType.student);

    return Center(
      child: Card(
        child: Container(
          width: 700,
          height: 700,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                OverflowBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        S.of(context).addPoints,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ToggleButtons(
                        onPressed: (index) {
                          setState(() {
                            for (int i = 0; i < _selectedToggle.length; i++) {
                              _selectedToggle[i] = i == index;
                            }
                          });
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          minWidth: 160,
                        ),
                        isSelected: _selectedToggle,
                        children: [
                          Text(S.of(context).oneTimePointsPurchase),
                          Text(S.of(context).pointSubscriptionTitle),
                        ],
                      ),
                    ),
                  ],
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
                _selectedToggle[0]
                    ? const _OneTimePointsPurchase()
                    : const _SubscriptionPointsPurchase(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OneTimePointsPurchase extends StatefulWidget {
  const _OneTimePointsPurchase({super.key});

  @override
  State<_OneTimePointsPurchase> createState() => _OneTimePointsPurchaseState();
}

class _OneTimePointsPurchaseState extends State<_OneTimePointsPurchase> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _redirectClicked = false;
  int _numPoints = 10;
  static const Map<int, String> _pointsCouponMap = {
    700: 'promo_1NNqXoK9gCxRnlEiD3tVodGw',
    1000: 'promo_1MaUbkK9gCxRnlEipn32mBEV',
    1500: 'promo_1NNqYfK9gCxRnlEiHZ0Im4f0',
    2000: 'promo_1MaUbzK9gCxRnlEi5Xd3CAdJ',
    5000: 'promo_1MaUc8K9gCxRnlEiiipU5lt3',
    10000: 'promo_1MaUcHK9gCxRnlEiK2ybiGGA',
  };

  void _onPointsChanged(int? value) {
    setState(() {
      _numPoints = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                    onPressed: account.shouldShowContent()
                        ? () async {
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
                          }
                        : null,
                  ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionPointsPurchase extends StatefulWidget {
  const _SubscriptionPointsPurchase({super.key});

  @override
  State<_SubscriptionPointsPurchase> createState() =>
      _SubscriptionPointsPurchaseState();
}

class _SubscriptionPointsPurchaseState
    extends State<_SubscriptionPointsPurchase> {
  final String _orderPointSubscriptionPriceId =
      'price_1ORJuSK9gCxRnlEil2SsaBPY';
  final String _supplementaryPointSubscriptionPriceId =
      'price_1ORQnwK9gCxRnlEiVXVbQUk5';
  final int _orderPointsPerLesson = 280;
  final int _supplementaryPointsPerLesson = 170;
  String _selectedPrice = 'price_1ORJuSK9gCxRnlEil2SsaBPY';
  int _selectedNumber = 2;
  bool _redirectClicked = false;

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();

    return Form(
      child: Column(
        children: [
          account.pointSubscriptionPriceId != null
              ? Text(
                  S.of(context).currentPointSubscription(
                      account.pointSubscriptionQuantity!),
                  style: Theme.of(context).textTheme.titleMedium,
                )
              : Text(
                  S.of(context).currentPointSubscription('0'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
          const SizedBox(height: 25),
          Text(S.of(context).pointSubscriptionTrial),
          Text(S.of(context).removePointSubscription),
          const SizedBox(height: 25),
          DropdownMenu<String>(
            requestFocusOnTap: true,
            initialSelection: _orderPointSubscriptionPriceId,
            label: Text(S.of(context).type),
            onSelected: (value) {
              setState(() {
                _selectedPrice = value!;
              });
            },
            dropdownMenuEntries: [
              DropdownMenuEntry(
                  value: _orderPointSubscriptionPriceId,
                  label: S.of(context).orderPointSubscription),
              DropdownMenuEntry(
                  value: _supplementaryPointSubscriptionPriceId,
                  label: S.of(context).freeSupplementaryPointSubscription),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownMenu<int>(
            requestFocusOnTap: true,
            initialSelection: 2,
            width: 200,
            label: Text(S.of(context).blockCount),
            onSelected: (value) {
              setState(() {
                _selectedNumber = value!;
              });
            },
            dropdownMenuEntries: [0, 2, 4, 6, 8, 12]
                .map(
                  (e) => DropdownMenuEntry(value: e, label: e.toString()),
                )
                .toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          _redirectClicked
              ? const CircularProgressIndicator(
                  value: null,
                )
              : FilledButton.tonal(
                  onPressed: account.shouldShowContent()
                      ? () async {
                          try {
                            setState(() {
                              _redirectClicked = true;
                            });
                            int pointQuantity = _selectedNumber *
                                (_selectedPrice ==
                                        _orderPointSubscriptionPriceId
                                    ? _orderPointsPerLesson
                                    : _supplementaryPointsPerLesson);
                            await stripe_service.updateSubscription(
                              id: account.subscriptionId!,
                              deleted: _selectedNumber == 0,
                              priceId: _selectedNumber == 0
                                  ? account.pointSubscriptionPriceId ??
                                      _selectedPrice
                                  : _selectedPrice,
                              quantity: pointQuantity,
                            );
                            account.pointSubscriptionQuantity = pointQuantity;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).lessonInfoUpdated),
                              ),
                            );
                            setState(() {
                              _redirectClicked = false;
                            });
                          } catch (err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(S.of(context).lessonInfoUpdateFailed),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                            setState(() {
                              _redirectClicked = false;
                            });
                            debugPrint('Failed to update subscription: $err');
                          }
                        }
                      : null,
                  child: Text(S.of(context).addPointsSubscription),
                ),
        ],
      ),
    );
  }
}

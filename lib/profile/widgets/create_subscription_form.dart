import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/profile/services/purchase_service.dart'
    as stripe_service;
import 'package:success_academy/account/services/user_service.dart'
    as user_service;

import '../../account/data/account_model.dart';
import '../../constants.dart' as constants;
import '../../generated/l10n.dart';
import '../data/profile_model.dart';

class CreateSubscriptionForm extends StatefulWidget {
  final SubscriptionPlan subscriptionPlan;
  final Function(SubscriptionPlan?) onSubscriptionPlanChange;
  final bool redirectClicked;
  final Function(bool) setIsReferral;
  final Function(String?) setReferrer;
  final VoidCallback onStripeSubmitClicked;

  const CreateSubscriptionForm({
    super.key,
    required this.subscriptionPlan,
    required this.onSubscriptionPlanChange,
    required this.redirectClicked,
    required this.setIsReferral,
    required this.setReferrer,
    required this.onStripeSubmitClicked,
  });

  @override
  State<CreateSubscriptionForm> createState() => _CreateSubscriptionFormState();
}

class _CreateSubscriptionFormState extends State<CreateSubscriptionForm> {
  final List<String> _validCodes = ['SRNPUXON'];
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

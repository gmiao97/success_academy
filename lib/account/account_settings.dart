import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account/account_model.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/services/user_service.dart' as user_service;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return const Settings();
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _timeZoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedTimeZone;

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>();
    _timeZoneController.text = account.myUser!.timeZone.replaceAll('_', ' ');

    return Center(
      child: Container(
        width: 700,
        height: 700,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).settings,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 25),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _timeZoneController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.public),
                    labelText: S.of(context).timeZoneLabel,
                  ),
                ),
                onSuggestionSelected: <String>(suggestion) {
                  _timeZoneController.text = suggestion;
                  // Update timeZone in myUser model, Update in firestore.
                },
                onSaved: (value) {
                  _selectedTimeZone = value;
                },
                itemBuilder: (context, suggestion) => ListTile(
                  title: Text(suggestion as String),
                ),
                suggestionsCallback: (pattern) => tz
                    .timeZoneDatabase.locations.keys
                    .map((timezone) => timezone.replaceAll('_', ' '))
                    .where((timezone) =>
                        timezone.toLowerCase().contains(pattern.toLowerCase())),
                validator: (String? value) {
                  if (!tz.timeZoneDatabase.locations.keys
                      .contains(value?.replaceAll(' ', '_'))) {
                    return S.of(context).timeZoneValidation;
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final timeZone = _selectedTimeZone?.replaceAll(' ', '_');
                      user_service
                          .updateMyUser(
                              userId: account.firebaseUser!.uid,
                              timeZone: timeZone)
                          .then(
                        (unused) {
                          final updatedMyUser = account.myUser!;
                          updatedMyUser.timeZone =
                              timeZone ?? account.myUser!.timeZone;
                          account.myUser = updatedMyUser;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.of(context).accountUpdated),
                            ),
                          );
                        },
                      ).catchError((err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).failedAccountUpdate),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                        debugPrint("Failed to update account settings: $err");
                      });
                    }
                  },
                  child: Text(S.of(context).confirm),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

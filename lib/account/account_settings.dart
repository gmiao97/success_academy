import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:success_academy/generated/l10n.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final TextEditingController _timeZoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
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
      itemBuilder: (context, suggestion) => ListTile(
        title: Text(suggestion as String),
      ),
      suggestionsCallback: (pattern) => tz.timeZoneDatabase.locations.keys
          .where((timezone) => timezone
              .toLowerCase()
              .replaceAll('_', ' ')
              .contains(pattern.toLowerCase())),
      validator: (String? value) {
        if (!tz.timeZoneDatabase.locations.keys.contains(value)) {
          return S.of(context).timeZoneValidation;
        }
        return null;
      },
    );
  }
}

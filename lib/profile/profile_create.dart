import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/main.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

class ProfileCreate extends StatelessWidget {
  const ProfileCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    final account = context.watch<AccountModel>();

    if (!account.isSignedIn || account.profile != null) {
      return const HomePage();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.homePageAppBarName),
        centerTitle: false,
        actions: [
          TextButton(
            style: style,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text(S.of(context).signOut),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: SignupForm(),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  SignupForm({Key? key}) : super(key: key) {
    tz.initializeTimeZones();
  }

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _timeZoneController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final ProfileModel _profileModel = ProfileModel();

  void _selectDate(BuildContext context) async {
    final DateTime? dateOfBirth = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (dateOfBirth != null) {
      setState(() {
        _dateOfBirthController.text =
            constants.dateFormatter.format(dateOfBirth);
        _profileModel.studentProfile.dateOfBirth = dateOfBirth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountModel>();
    _profileModel.uid = account.user!.uid;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
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
              setState(() {
                _profileModel.timeZone = suggestion;
              });
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
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Process data.
                  await profileModelRef.add(_profileModel);
                  Navigator.pushNamed(context, constants.routeHome);
                }
              },
              child: Text(S.of(context).next),
            ),
          ),
        ],
      ),
    );
  }
}

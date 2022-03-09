import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
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
            child: const Text(constants.signOutText),
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
  final ProfileModel _profileModel = ProfileModel();

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
            decoration: const InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: constants.lastNameLabelText,
              hintText: constants.lastNameLabelText,
            ),
            onChanged: (value) {
              setState(() {
                _profileModel.lastName = value;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return constants.lastNameValidateText;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: constants.firstNameLabelText,
              hintText: constants.firstNameHintText,
            ),
            onChanged: (value) {
              setState(() {
                _profileModel.firstName = value;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return constants.firstNameValidateText;
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            hint: const Text(constants.timeZoneHintText),
            icon: const Icon(Icons.access_time),
            items: tz.timeZoneDatabase.locations.keys
                .map((value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: <String>(value) {
              setState(() {
                _profileModel.timeZone = value;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return constants.timeZoneValidateText;
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
              child: const Text(constants.nextText),
            ),
          ),
        ],
      ),
    );
  }
}

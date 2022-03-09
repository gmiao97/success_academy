import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:success_academy/account_model.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/profile/profile_model.dart';

class ProfileBrowse extends StatelessWidget {
  const ProfileBrowse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    final account = context.read<AccountModel>();

    return Scaffold(
        appBar: AppBar(
          title: const Text(constants.homePageAppBarName),
          centerTitle: false,
          automaticallyImplyLeading: false,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                constants.profileSelectionText,
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 50),
              FutureBuilder<List<QueryDocumentSnapshot<ProfileModel>>>(
                future: profileModelRef
                    .where('uid', isEqualTo: account.user!.uid)
                    .get()
                    .then((snapshot) => snapshot.docs),
                builder: (BuildContext context,
                    AsyncSnapshot<List<QueryDocumentSnapshot<ProfileModel>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var profileSnapshot in snapshot.data!)
                          buildProfileCard(context, profileSnapshot.data()),
                        const AddProfileCard(),
                      ],
                    );
                    // return Text(snapshot.data![0].data().lastName);
                  }
                  return const Text("loading");
                },
              ),
            ],
          ),
        ));
  }
}

Card buildProfileCard(BuildContext context, ProfileModel profile) {
  final account = context.read<AccountModel>();

  return Card(
    elevation: 10.0,
    child: InkWell(
      splashColor: Theme.of(context).colorScheme.primary.withAlpha(30),
      onTap: () {
        account.profile = profile;
      },
      child: SizedBox(
        width: 200,
        height: 200,
        child: Text('${profile.lastName}, ${profile.firstName}'),
      ),
    ),
  );
}

class AddProfileCard extends StatelessWidget {
  const AddProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.primary.withAlpha(30),
        onTap: () {
          Navigator.pushNamed(context, constants.routeCreateProfile);
        },
        child: SizedBox(
          width: 200,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: 50,
              ),
              const Text(constants.profileCreationText),
            ],
          ),
        ),
      ),
    );
  }
}

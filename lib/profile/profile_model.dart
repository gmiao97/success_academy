import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  ProfileModel();

  ProfileModel.fromJson(Map<String, Object?> json)
      : uid = json['uid'] as String,
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        timeZone = json['time_zone'] as String;

  late String uid;
  late String lastName;
  late String firstName;
  late String timeZone;

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'last_name': lastName,
      'first_name': firstName,
      'time_zone': timeZone,
    };
  }
}

final profileModelRef = FirebaseFirestore.instance
    .collection('users')
    .withConverter<ProfileModel>(
      fromFirestore: (snapshot, _) => ProfileModel.fromJson(snapshot.data()!),
      toFirestore: (signUpModel, _) => signUpModel.toJson(),
    );

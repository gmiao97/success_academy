import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:success_academy/constants.dart' as constants;

class ProfileModel {
  ProfileModel();

  ProfileModel._fromJson(Map<String, Object?> json)
      : studentProfile = _StudentProfileModel._fromJson(
            json['student_profile'] as Map<String, Object?>),
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        timeZone = json['time_zone'] as String;

  late _StudentProfileModel studentProfile = _StudentProfileModel();
  late String lastName;
  late String firstName;
  late String timeZone;
  // TODO: Add preferred language and customize welcome email and stripe based on it.

  Map<String, Object?> _toJson() {
    return {
      'student_profile': studentProfile._toJson(),
      'last_name': lastName,
      'first_name': firstName,
      'time_zone': timeZone,
    };
  }
}

class _StudentProfileModel {
  _StudentProfileModel();

  _StudentProfileModel._fromJson(Map<String, Object?> json)
      : dateOfBirth = DateTime.parse(json['date_of_birth'] as String);

  late DateTime dateOfBirth;

  Map<String, Object?> _toJson() {
    return {
      'date_of_birth': constants.dateFormatter.format(dateOfBirth),
    };
  }
}

CollectionReference<ProfileModel> getProfileModelRefForUser(uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('profiles')
      .withConverter<ProfileModel>(
        fromFirestore: (snapshot, _) =>
            ProfileModel._fromJson(snapshot.data()!),
        toFirestore: (profileModel, _) => profileModel._toJson(),
      );
}

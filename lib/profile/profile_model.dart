import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:success_academy/constants.dart' as constants;

class ProfileModel {
  ProfileModel();

  ProfileModel._fromJson(String id, Map<String, Object?> json)
      : _id = id,
        studentProfile = _StudentProfileModel._fromJson(
            json['student_profile'] as Map<String, Object?>),
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String;

  String _id = '';
  late _StudentProfileModel studentProfile = _StudentProfileModel();
  late String lastName;
  late String firstName;

  String get id => _id;

  Map<String, Object?> _toJson() {
    return {
      'student_profile': studentProfile._toJson(),
      'last_name': lastName,
      'first_name': firstName,
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
            ProfileModel._fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (profileModel, _) => profileModel._toJson(),
      );
}

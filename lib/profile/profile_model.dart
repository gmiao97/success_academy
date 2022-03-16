import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:success_academy/constants.dart' as constants;

class ProfileModel {
  ProfileModel();

  ProfileModel._fromFirestoreJson(String profileId, Map<String, Object?> json)
      : _profileId = profileId,
        studentProfile = _StudentProfileModel._fromJson(
            json['student_profile'] as Map<String, Object?>),
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String;

  ProfileModel.fromJson(Map<String, Object?> json)
      : _profileId = json['id'] as String,
        studentProfile = _StudentProfileModel._fromJson(
            json['student_profile'] as Map<String, Object?>),
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String;

  /// Store the profile document id in order to add it to subscription metadata
  String _profileId = '';
  late _StudentProfileModel studentProfile = _StudentProfileModel();
  late String lastName;
  late String firstName;

  String get profileId => _profileId;

  Map<String, Object?> _toFirestoreJson() {
    return {
      'student_profile': studentProfile._toJson(),
      'last_name': lastName,
      'first_name': firstName,
    };
  }

  Map<String, Object?> toJson() {
    return {
      'id': _profileId,
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

CollectionReference<ProfileModel> getProfileModelRefForUser(userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('profiles')
      .withConverter<ProfileModel>(
        fromFirestore: (snapshot, _) =>
            ProfileModel._fromFirestoreJson(snapshot.id, snapshot.data()!),
        toFirestore: (profileModel, _) => profileModel._toFirestoreJson(),
      );
}

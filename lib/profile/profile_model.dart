import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:success_academy/constants.dart' as constants;

class ProfileModel {
  ProfileModel();

  ProfileModel._fromFirestoreJson(String profileId, Map<String, Object?> json)
      : _profileId = profileId,
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        dateOfBirth = DateTime.parse(json['date_of_birth'] as String);

  ProfileModel.fromJson(Map<String, Object?> json)
      : _profileId = json['id'] as String,
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        dateOfBirth = DateTime.parse(json['date_of_birth'] as String);

  /// Store the profile document id in order to add it to subscription metadata
  String _profileId = '';
  late String lastName;
  late String firstName;
  late DateTime dateOfBirth;

  String get profileId => _profileId;

  Map<String, Object?> _toFirestoreJson() {
    return {
      'last_name': lastName,
      'first_name': firstName,
      'date_of_birth': constants.dateFormatter.format(dateOfBirth),
    };
  }

  Map<String, Object?> toJson() {
    return {
      'id': _profileId,
      'last_name': lastName,
      'first_name': firstName,
      'date_of_birth': constants.dateFormatter.format(dateOfBirth),
    };
  }
}

CollectionReference<ProfileModel> getProfileModelRefForUser(userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('student_profiles')
      .withConverter<ProfileModel>(
        fromFirestore: (snapshot, _) =>
            ProfileModel._fromFirestoreJson(snapshot.id, snapshot.data()!),
        toFirestore: (profileModel, _) => profileModel._toFirestoreJson(),
      );
}

class TeacherProfileModel {
  TeacherProfileModel();

  TeacherProfileModel.fromJson(Map<String, Object?> json)
      : lastName = json['last_name'] as String,
        firstName = json['first_name'] as String;

  late String lastName;
  late String firstName;

  Map<String, Object?> toJson() {
    return {
      'last_name': lastName,
      'first_name': firstName,
    };
  }
}

CollectionReference<TeacherProfileModel> getTeacherProfileModelRefForUser(
    userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('teacher_profile')
      .withConverter<TeacherProfileModel>(
        fromFirestore: (snapshot, _) =>
            TeacherProfileModel.fromJson(snapshot.data()!),
        toFirestore: (teacherProfileModel, _) => teacherProfileModel.toJson(),
      );
}

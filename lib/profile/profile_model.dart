import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:success_academy/constants.dart' as constants;

class ProfileModel {
  ProfileModel();

  ProfileModel.fromJson(Map<String, Object?> json)
      : uid = json['uid'] as String,
        referralCode = json['referral_code'] as String,
        studentProfile = StudentProfileModel.fromJson(
            json['student_profile'] as Map<String, Object?>),
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        timeZone = json['time_zone'] as String;

  late String uid;
  String referralCode = randomAlpha(8);
  late StudentProfileModel studentProfile = StudentProfileModel();
  late String lastName;
  late String firstName;
  late String timeZone;

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'referral_code': referralCode,
      'student_profile': studentProfile.toJson(),
      'last_name': lastName,
      'first_name': firstName,
      'time_zone': timeZone,
    };
  }
}

class StudentProfileModel {
  StudentProfileModel();

  StudentProfileModel.fromJson(Map<String, Object?> json)
      : dateOfBirth = DateTime.parse(json['date_of_birth'] as String);

  late DateTime dateOfBirth;

  Map<String, Object?> toJson() {
    return {
      'date_of_birth': constants.dateFormatter.format(dateOfBirth),
    };
  }
}

final profileModelRef = FirebaseFirestore.instance
    .collection('users')
    .withConverter<ProfileModel>(
      fromFirestore: (snapshot, _) => ProfileModel.fromJson(snapshot.data()!),
      toFirestore: (signUpModel, _) => signUpModel.toJson(),
    );

Future<List<QueryDocumentSnapshot<ProfileModel>>> getProfilesForUser(
    String uid) {
  return profileModelRef
      .where('uid', isEqualTo: uid)
      .get()
      .then((snapshot) => snapshot.docs);
}

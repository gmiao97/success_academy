import 'package:success_academy/constants.dart' as constants;

class StudentProfileModel {
  StudentProfileModel();

  StudentProfileModel.fromFirestoreJson(
      String profileId, Map<String, Object?> json)
      : _profileId = profileId,
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        dateOfBirth = DateTime.parse(json['date_of_birth'] as String);

  StudentProfileModel.fromJson(Map<String, Object?> json)
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

  Map<String, Object?> toFirestoreJson() {
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

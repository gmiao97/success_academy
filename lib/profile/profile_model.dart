import 'package:success_academy/constants.dart' as constants;

// Corresponds to metadata field 'id' in price in Stripe dashboard
enum SubscriptionPlan { minimum, minimumPreschool, monthly }

class StudentProfileModel {
  StudentProfileModel();

  StudentProfileModel.fromFirestoreJson(
      String profileId, Map<String, Object?> json)
      : _profileId = profileId,
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        dateOfBirth = DateTime.parse(json['date_of_birth'] as String);

  /// Used to read profile from shared preferences.
  StudentProfileModel.fromJson(Map<String, Object?> json)
      : _profileId = json['id'] as String,
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        dateOfBirth = DateTime.parse(json['date_of_birth'] as String);

  // TODO: Add field to indicate whether student has already had a subscription.

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

  /// Used to write profile to shared preferences.
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

  TeacherProfileModel.fromJson(String profileId, Map<String, Object?> json)
      : _profileId = profileId,
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String;

  String _profileId = '';
  late String lastName;
  late String firstName;

  String get profileId => _profileId;

  Map<String, Object?> toJson() {
    return {
      'last_name': lastName,
      'first_name': firstName,
    };
  }
}

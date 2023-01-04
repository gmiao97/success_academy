import 'package:flutter/material.dart';
import 'package:success_academy/constants.dart' as constants;
import 'package:success_academy/generated/l10n.dart';
import 'package:success_academy/services/profile_service.dart'
    as profile_service;

// Corresponds to metadata field 'id' in price in Stripe dashboard
enum SubscriptionPlan { minimum, minimumPreschool, monthly }

String getSubscriptionPlanName(BuildContext context, SubscriptionPlan? plan) {
  switch (plan) {
    case SubscriptionPlan.minimum:
      return S.of(context).minimumCourse;
    case SubscriptionPlan.minimumPreschool:
      return S.of(context).minimumPreschoolCourse;
    case SubscriptionPlan.monthly:
      return S.of(context).monthlyCourse;
    default:
      return S.of(context).noPlan;
  }
}

class StudentProfileModel {
  StudentProfileModel() : numPoints = 0;

  StudentProfileModel.fromFirestoreJson(
      String profileId, Map<String, Object?> json)
      : _profileId = profileId,
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        dateOfBirth = DateTime.parse(json['date_of_birth'] as String),
        numPoints = json['num_points'] as int,
        referrer = json['referrer'] as String?;

  /// Used to read profile from shared preferences.
  StudentProfileModel._fromJson(Map<String, Object?> json,
      {required String userId})
      : _profileId = json['id'] as String,
        lastName = json['last_name'] as String,
        firstName = json['first_name'] as String,
        dateOfBirth = DateTime.parse(json['date_of_birth'] as String),
        numPoints = json['num_points'] as int,
        referrer = json['referrer'] as String?;

  static Future<StudentProfileModel> create(Map<String, Object?> json,
      {required String userId}) async {
    StudentProfileModel profile =
        StudentProfileModel._fromJson(json, userId: userId);
    profile.numPoints = await profile_service.getNumberPoints(
        userId: userId, profileId: json['id'] as String);
    return profile;
  }

  // TODO: Add field to indicate whether student has already had a subscription.

  /// Store the profile document id in order to add it to subscription metadata
  String _profileId = '';
  late String lastName;
  late String firstName;
  late DateTime dateOfBirth;
  int numPoints;
  String? referrer;

  String get profileId => _profileId;

  Map<String, Object?> toFirestoreJson() {
    return {
      'last_name': lastName,
      'first_name': firstName,
      'date_of_birth': constants.dateFormatter.format(dateOfBirth),
      'num_points': numPoints,
      'referrer': referrer,
    };
  }

  /// Used to write profile to shared preferences.
  Map<String, Object?> toJson() {
    return {
      'id': _profileId,
      'last_name': lastName,
      'first_name': firstName,
      'date_of_birth': constants.dateFormatter.format(dateOfBirth),
      'num_points': numPoints,
      'referrer': referrer,
    };
  }

  static Map<String, StudentProfileModel> buildStudentProfileMap(
      List<StudentProfileModel> studentProfileList) {
    Map<String, StudentProfileModel> map = {};
    for (StudentProfileModel profile in studentProfileList) {
      map[profile._profileId] = profile;
    }
    return map;
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

  static Map<String, TeacherProfileModel> buildTeacherProfileMap(
      List<TeacherProfileModel> teacherProfileList) {
    Map<String, TeacherProfileModel> map = {};
    for (TeacherProfileModel profile in teacherProfileList) {
      map[profile._profileId] = profile;
    }
    return map;
  }
}

class AdminProfileModel {
  AdminProfileModel();

  AdminProfileModel.fromJson(String profileId, Map<String, Object?> json);

  Map<String, Object?> toJson() {
    return {};
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../profile/profile_model.dart';

void updateLocale(String locale) async {
  final prefs = await _getSharedPreferencesInstance();
  prefs?.setString('locale', locale);
}

Future<String> getLocale() async {
  final prefs = await _getSharedPreferencesInstance();
  return prefs?.getString('locale') ?? 'en';
}

Future<StudentProfileModel?> loadStudentProfile(
    {required String userId}) async {
  final prefs = await _getSharedPreferencesInstance();
  final profileJsonString = prefs?.getString('profile');
  if (profileJsonString != null) {
    final profileJson = jsonDecode(profileJsonString);
    if (profileJson != null) {
      return StudentProfileModel.create(jsonDecode(profileJsonString),
          userId: userId);
    }
  }
  return null;
}

void updateStudentProfile(StudentProfileModel? studentProfile) async {
  final prefs = await _getSharedPreferencesInstance();
  prefs?.setString('profile', jsonEncode(studentProfile?.toJson()));
}

void removeStudentProfile() async {
  final prefs = await _getSharedPreferencesInstance();
  prefs?.remove('profile');
}

Future<SharedPreferences?> _getSharedPreferencesInstance() async {
  try {
    return await SharedPreferences.getInstance();
  } on Exception {
    return null;
  }
}

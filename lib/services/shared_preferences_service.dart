import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:success_academy/profile/profile_model.dart';

void updateLocale(String locale) async {
  final prefs = await _getSharedPreferencesInstance();
  prefs?.setString('locale', locale);
}

Future<String> getLocale() async {
  final prefs = await _getSharedPreferencesInstance();
  return prefs?.getString('locale') ?? 'en';
}

Future<StudentProfileModel?> loadStudentProfile() async {
  final prefs = await _getSharedPreferencesInstance();
  final profileJsonString = prefs?.getString('profile');
  if (profileJsonString != null) {
    final profileJson = jsonDecode(profileJsonString);
    if (profileJson != null) {
      return StudentProfileModel.fromJson(jsonDecode(profileJsonString));
    }
  }
  return null;
}

void updateStudentProfile(StudentProfileModel? profile) async {
  final prefs = await _getSharedPreferencesInstance();
  prefs?.setString('profile', jsonEncode(profile?.toJson()));
}

Future<SharedPreferences?> _getSharedPreferencesInstance() async {
  try {
    return await SharedPreferences.getInstance();
  } on Exception {
    return null;
  }
}

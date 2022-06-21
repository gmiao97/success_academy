import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: 'us-west2');

Future<List<dynamic>> getAllEventsFromFreeLessonCalendar({
  required String timeZone,
  required String timeMin,
  required String timeMax,
}) async {
  HttpsCallable getEventsFromFreeLessonCalendarCallable =
      functions.httpsCallable('listAllEventsFromFreeLessonCalendar');

  try {
    final result = await getEventsFromFreeLessonCalendarCallable(
        {'timeZone': timeZone, 'timeMin': timeMin, 'timeMax': timeMax});
    return result.data;
  } catch (e) {
    debugPrint('listAllEventsFromFreeLessonCalendar failed: $e');
    rethrow;
  }
}

Future<List<dynamic>> getAllEventsFromPreschoolLessonCalendar({
  required String timeZone,
  required String timeMin,
  required String timeMax,
}) async {
  HttpsCallable getEventsFromFreeLessonCalendarCallable =
      functions.httpsCallable('listAllEventsFromPreschoolLessonCalendar');

  try {
    final result = await getEventsFromFreeLessonCalendarCallable(
        {'timeZone': timeZone, 'timeMin': timeMin, 'timeMax': timeMax});
    return result.data;
  } catch (e) {
    debugPrint('listAllEventsFromPreschoolLessonCalendar failed: $e');
    rethrow;
  }
}

Future<List<dynamic>> getAllEventsFromPrivateLessonCalendar({
  required String timeZone,
  required String timeMin,
  required String timeMax,
}) async {
  HttpsCallable getEventsFromFreeLessonCalendarCallable =
      functions.httpsCallable('listAllEventsFromPrivateLessonCalendar');

  try {
    final result = await getEventsFromFreeLessonCalendarCallable(
        {'timeZone': timeZone, 'timeMin': timeMin, 'timeMax': timeMax});
    return result.data;
  } catch (e) {
    debugPrint('listAllEventsFromPrivateLessonCalendar failed: $e');
    rethrow;
  }
}

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:success_academy/calendar/event_model.dart';

final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: 'us-west2');

Future<List<dynamic>> listEventsFromFreeLessonCalendar({
  required String timeZone,
  required String timeMin,
  required String timeMax,
  String? teacherId,
  List<String>? studentIdList,
}) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-listEventsFromFreeLessonCalendar');

  try {
    final result = await callable({
      'timeZone': timeZone,
      'timeMin': timeMin,
      'timeMax': timeMax,
      'teacherId': teacherId,
      'studentIdList': studentIdList,
    });
    return result.data;
  } catch (e) {
    debugPrint('listAllEventsFromFreeLessonCalendar failed: $e');
    rethrow;
  }
}

Future<List<dynamic>> listEventsFromPreschoolLessonCalendar({
  required String timeZone,
  required String timeMin,
  required String timeMax,
  String? teacherId,
  List<String>? studentIdList,
}) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-listEventsFromPreschoolLessonCalendar');

  try {
    final result = await callable({
      'timeZone': timeZone,
      'timeMin': timeMin,
      'timeMax': timeMax,
      'teacherId': teacherId,
      'studentIdList': studentIdList,
    });
    return result.data;
  } catch (e) {
    debugPrint('listAllEventsFromPreschoolLessonCalendar failed: $e');
    rethrow;
  }
}

Future<List<dynamic>> listEventsFromPrivateLessonCalendar({
  required String timeZone,
  required String timeMin,
  required String timeMax,
  String? teacherId,
  List<String>? studentIdList,
}) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-listEventsFromPrivateLessonCalendar');

  try {
    final result = await callable({
      'timeZone': timeZone,
      'timeMin': timeMin,
      'timeMax': timeMax,
      'teacherId': teacherId,
      'studentIdList': studentIdList,
    });
    return result.data;
  } catch (e) {
    debugPrint('listAllEventsFromPrivateLessonCalendar failed: $e');
    rethrow;
  }
}

Future<dynamic> deleteEventFromFreeLessonCalendar({
  required String eventId,
}) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-deleteEventFromFreeLessonCalendar');

  try {
    final result = await callable({
      'eventId': eventId,
    });
    return result.data;
  } catch (e) {
    debugPrint('deleteEventFromFreeLessonCalendar failed: $e');
    rethrow;
  }
}

Future<dynamic> deleteEventFromPreschoolLessonCalendar({
  required String eventId,
}) async {
  HttpsCallable callable = functions.httpsCallable(
      'calendarFunctions-deleteEventFromPreschoolLessonCalendar');

  try {
    final result = await callable({
      'eventId': eventId,
    });
    return result.data;
  } catch (e) {
    debugPrint('deleteEventFromPreschoolLessonCalendar failed: $e');
    rethrow;
  }
}

Future<dynamic> deleteEventFromPrivateLessonCalendar({
  required String eventId,
}) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-deleteEventFromPrivateLessonCalendar');

  try {
    final result = await callable({
      'eventId': eventId,
    });
    return result.data;
  } catch (e) {
    debugPrint('deleteEventFromPrivateLessonCalendar failed: $e');
    rethrow;
  }
}

Future<dynamic> addEventToFreeLessonCalendar(EventModel event) async {
  HttpsCallable callable =
      functions.httpsCallable('calendarFunctions-addEventToFreeLessonCalendar');

  try {
    final result = await callable(event.toJson());
    return result.data;
  } catch (e) {
    debugPrint('addEventToFreeLessonCalendar failed: $e');
    rethrow;
  }
}

Future<dynamic> addEventToPreschoolLessonCalendar(EventModel event) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-addEventToPreschoolLessonCalendar');

  try {
    final result = await callable(event.toJson());
    return result.data;
  } catch (e) {
    debugPrint('addEventToPreschoolLessonCalendar failed: $e');
    rethrow;
  }
}

Future<dynamic> addEventToPrivateLessonCalendar(EventModel event) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-addEventToPrivateLessonCalendar');

  try {
    final result = await callable(event.toJson());
    return result.data;
  } catch (e) {
    debugPrint('addEventToPrivateLessonCalendar failed: $e');
    rethrow;
  }
}

Future<dynamic> updateEventInFreeLessonCalendar({
  required String eventId,
  required String summary,
  required String description,
  required String startTime,
  required String endTime,
  required String timeZone,
  List<String>? recurrence,
  String? teacherId,
  List<String>? studentIdList,
}) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-updateEventInFreeLessonCalendar');

  try {
    final result = await callable({
      'eventId': eventId,
      'summary': summary,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'timeZone': timeZone,
      'recurrence': recurrence,
      'teacherId': teacherId,
      'studentIdList': studentIdList,
    });
    return result.data;
  } catch (e) {
    debugPrint('updateEventInFreeLessonCalendar failed: $e');
    rethrow;
  }
}

Future<dynamic> updateEventInPreschoolLessonCalendar({
  required String eventId,
  required String summary,
  required String description,
  required String startTime,
  required String endTime,
  required String timeZone,
  List<String>? recurrence,
  String? teacherId,
  List<String>? studentIdList,
}) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-updateEventInPreschoolLessonCalendar');

  try {
    final result = await callable({
      'eventId': eventId,
      'summary': summary,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'timeZone': timeZone,
      'recurrence': recurrence,
      'teacherId': teacherId,
      'studentIdList': studentIdList,
    });
    return result.data;
  } catch (e) {
    debugPrint('updateEventInPreschoolLessonCalendar failed: $e');
    rethrow;
  }
}

Future<dynamic> updateEventInPrivateLessonCalendar({
  required String eventId,
  required String summary,
  required String description,
  required String startTime,
  required String endTime,
  required String timeZone,
  List<String>? recurrence,
  required String teacherId,
  List<String>? studentIdList,
  required int numPoints,
}) async {
  HttpsCallable callable = functions
      .httpsCallable('calendarFunctions-updateEventInPrivateLessonCalendar');

  try {
    final result = await callable({
      'eventId': eventId,
      'summary': summary,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'timeZone': timeZone,
      'recurrence': recurrence,
      'teacherId': teacherId,
      'studentIdList': studentIdList,
      'numPoints': numPoints,
    });
    return result.data;
  } catch (e) {
    debugPrint('updateEventInPrivateLessonCalendar failed: $e');
    rethrow;
  }
}

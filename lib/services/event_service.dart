import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:success_academy/calendar/event_model.dart';

final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: 'us-west2');

Future<List<dynamic>> listEvents({
  required String timeZone,
  required String timeMin,
  required String timeMax,
  required bool singleEvents,
}) async {
  HttpsCallable callable =
      functions.httpsCallable('calendar_functions-list_events');

  try {
    final result = await callable({
      'timeZone': timeZone,
      'timeMin': timeMin,
      'timeMax': timeMax,
      'singleEvents': singleEvents,
    });
    return result.data;
  } catch (err) {
    debugPrint('listEvents failed: $err');
    rethrow;
  }
}

Future<dynamic> deleteEvent({
  required String eventId,
}) async {
  HttpsCallable callable =
      functions.httpsCallable('calendar_functions-delete_event');

  try {
    final result = await callable({
      'eventId': eventId,
    });
    return result.data;
  } catch (err) {
    debugPrint('deleteEvent failed: $err');
    rethrow;
  }
}

Future<dynamic> insertEvent(EventModel event) async {
  HttpsCallable callable =
      functions.httpsCallable('calendar_functions-insert_event');

  try {
    final result = await callable(event.toJson());
    return result.data;
  } catch (err) {
    debugPrint('insertEvent failed: $err');
    rethrow;
  }
}

Future<dynamic> updateEvent(EventModel event) async {
  HttpsCallable callable =
      functions.httpsCallable('calendar_functions-update_event');

  try {
    final result = await callable(event.toJson());
    return result.data;
  } catch (err) {
    debugPrint('updateEvent failed: $err');
    rethrow;
  }
}

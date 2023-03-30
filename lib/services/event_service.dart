import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:success_academy/calendar/event_model.dart';
import 'package:timezone/timezone.dart' as tz;

final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: 'us-west2');

Future<List<EventModel>> listEvents({
  required tz.Location location,
  required String timeMin,
  required String timeMax,
  required bool singleEvents,
}) async {
  HttpsCallable callable = functions.httpsCallable(
    'calendar_functions-list_events',
    options: HttpsCallableOptions(
      timeout: const Duration(seconds: 540),
    ),
  );

  try {
    final result = await callable({
      'timeZone': location.name,
      'timeMin': timeMin,
      'timeMax': timeMax,
      'singleEvents': singleEvents,
    });
    return (result.data as List<dynamic>)
        .where((e) => e['status'] != 'cancelled')
        .map((event) => EventModel.fromJson(event, location: location))
        .toList();
  } catch (err) {
    debugPrint('listEvents failed: $err');
    rethrow;
  }
}

Future<dynamic> deleteEvent({
  required String eventId,
}) async {
  HttpsCallable callable = functions.httpsCallable(
    'calendar_functions-delete_event',
    options: HttpsCallableOptions(
      timeout: const Duration(seconds: 540),
    ),
  );

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
  HttpsCallable callable = functions.httpsCallable(
    'calendar_functions-insert_event',
    options: HttpsCallableOptions(
      timeout: const Duration(seconds: 540),
    ),
  );

  try {
    final result = await callable(event.toJson());
    return result.data;
  } catch (err) {
    debugPrint('insertEvent failed: $err');
    rethrow;
  }
}

Future<dynamic> updateEvent(EventModel event) async {
  HttpsCallable callable = functions.httpsCallable(
    'calendar_functions-update_event',
    options: HttpsCallableOptions(
      timeout: const Duration(seconds: 540),
    ),
  );

  try {
    final result = await callable(event.toJson());
    return result.data;
  } catch (err) {
    debugPrint('updateEvent failed: $err');
    rethrow;
  }
}

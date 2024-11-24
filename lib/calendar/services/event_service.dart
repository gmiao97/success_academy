import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

import '../event_model.dart';

const isDev = kDebugMode;

final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: 'us-west2');

Future<EventModel> getEvent({
  required String eventId,
  required tz.Location location,
}) async {
  HttpsCallable callable = functions.httpsCallable(
    'calendar_functions-get_event',
    options: HttpsCallableOptions(
      timeout: const Duration(seconds: 60),
    ),
  );

  try {
    final result = await callable({
      'eventId': eventId,
      'isDev': isDev,
    });
    return EventModel.fromJson(result.data, location: location);
  } catch (err) {
    debugPrint('getEvent failed: $err');
    rethrow;
  }
}

Future<List<EventModel>> listEvents({
  required tz.Location location,
  required String timeMin,
  required String timeMax,
  required bool singleEvents,
}) async {
  HttpsCallable callable = functions.httpsCallable(
    'calendar_functions-list_events',
    options: HttpsCallableOptions(
      timeout: const Duration(seconds: 60),
    ),
  );

  try {
    final result = await callable({
      'timeZone': location.name,
      'timeMin': timeMin,
      'timeMax': timeMax,
      'singleEvents': singleEvents,
      'isDev': isDev,
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
      timeout: const Duration(seconds: 60),
    ),
  );

  try {
    final result = await callable({
      'eventId': eventId,
      'isDev': isDev,
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
      timeout: const Duration(seconds: 60),
    ),
  );

  try {
    final result = await callable({
      ...event.toJson(),
      'isDev': isDev,
    });
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
      timeout: const Duration(seconds: 60),
    ),
  );

  try {
    final result = await callable({
      ...event.toJson(),
      'isDev': isDev,
    });
    return result.data;
  } catch (err) {
    debugPrint('updateEvent failed: $err');
    rethrow;
  }
}

Future<dynamic> emailAttendees(
  EventModel event,
  String studentId, {
  bool isCancel = false,
}) async {
  HttpsCallable callable = functions.httpsCallable(
    'email_attendees',
    options: HttpsCallableOptions(
      timeout: const Duration(seconds: 60),
    ),
  );

  try {
    final result = await callable({
      ...event.toJson(),
      'studentId': studentId,
      'isCancel': isCancel,
    });
    return result.data;
  } catch (err) {
    debugPrint('emailAttendees failed: $err');
    rethrow;
  }
}

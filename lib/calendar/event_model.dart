import 'package:flutter/material.dart';
import 'package:success_academy/constants.dart';
import 'package:timezone/timezone.dart' as tz;

// If change, also change _filterNames in calendar_header.dart, _fillColorMap,
// _borderColorMap, _eventTypeNames in event_dialog.dart.
enum EventType { free, myFree, preschool, private, myPreschool, myPrivate }

Map<EventType, int> _fillColorMap = {
  EventType.free: grey,
  EventType.myFree: yellow,
  EventType.preschool: grey,
  EventType.myPreschool: blue,
  EventType.private: grey,
  EventType.myPrivate: purple,
};

Map<EventType, int> _borderColorMap = {
  EventType.free: yellow,
  EventType.myFree: yellow,
  EventType.preschool: blue,
  EventType.myPreschool: blue,
  EventType.private: purple,
  EventType.myPrivate: purple,
};

class EventModel {
  EventModel({
    required this.summary,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.timeZone,
    this.recurrence,
    this.teacherId,
    this.studentIdList,
    this.numPoints,
  });

  /// Build object from response returned by Google Calendar API.
  EventModel.fromJson(
      Map<String, Object?> json, tz.Location timeZone, this.eventType)
      : eventId = json['id'] as String?,
        recurrenceId = json['recurringEventId'] as String?,
        summary = json['summary'] as String,
        description = json['description'] as String,
        startTime =
            tz.TZDateTime.parse(timeZone, (json['start'] as Map)['dateTime']),
        endTime =
            tz.TZDateTime.parse(timeZone, (json['end'] as Map)['dateTime']),
        fillColor = _fillColorMap[eventType] ?? grey,
        bordercolor = _borderColorMap[eventType] ?? grey,
        recurrence = json['recurrence'] as List<String>?,
        timeZone = (json['start'] as Map)['timeZone'] as String {
    Map<String, dynamic>? extendedProperties = (json['extendedProperties']
        as Map?)?['shared'] as Map<String, dynamic>?;
    if (extendedProperties != null) {
      try {
        teacherId = extendedProperties.entries
            .singleWhere((entry) => entry.value == 'teacher')
            .key;
      } on StateError {
        debugPrint(
            'extendedProperties does not contain teacher id for event: $eventId');
      }
      studentIdList = extendedProperties.entries
          .where((entry) => entry.value == 'student')
          .map((entry) => entry.key)
          .toList();
    }
  }

  String? eventId;
  String? recurrenceId;
  String summary;
  String description;
  tz.TZDateTime startTime;
  tz.TZDateTime endTime;
  String timeZone;
  List<String>? recurrence;
  String? teacherId;
  List<String>? studentIdList;
  int? numPoints;
  EventType? eventType;
  int fillColor = grey;
  int bordercolor = grey;
  Map<String, Object?> toJson() {
    return {
      'summary': summary,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'timeZone': timeZone,
      'recurrence': recurrence,
      'teacherId': teacherId,
      'studentIdList': studentIdList,
      'numPoints': numPoints,
    };
  }
}

Map<DateTime, List<EventModel>> buildEventMap(List<EventModel> eventList) {
  Map<DateTime, List<EventModel>> eventMap = {};
  for (final event in eventList) {
    // table_calendar DateTimes for each day are in UTC, so this needs to match.
    final localStartDay = DateTime.utc(
        event.startTime.year, event.startTime.month, event.startTime.day);

    eventMap.putIfAbsent(localStartDay, () => []).add(event);
  }
  return eventMap;
}

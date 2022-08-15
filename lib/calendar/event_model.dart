import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:success_academy/constants.dart';

// If change, also change _filterNames in calendar_header.dart, _fillColorMap,
// _borderColorMap, _eventTypeNames in event_dialog.dart.
enum EventType {
  unknown,
  free,
  preschool,
  private,
}

Map<EventType, int> _eventColorMap = {
  EventType.unknown: grey,
  EventType.free: yellow,
  EventType.preschool: blue,
  EventType.private: purple,
};

class EventModel {
  EventModel({
    required this.eventType,
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
  EventModel.fromJson(Map<String, Object?> json)
      : eventId = json['id'] as String?,
        recurrenceId = json['recurringEventId'] as String?,
        summary = json['summary'] as String,
        description = json['description'] as String,
        startTime = DateTime.parse((json['start'] as Map)['dateTime']),
        endTime = DateTime.parse((json['end'] as Map)['dateTime']),
        recurrence = json['recurrence'] as List<String>?,
        timeZone = (json['start'] as Map)['timeZone'] as String {
    debugPrint((json['start'] as Map)['dateTime']);
    Map<String, dynamic> extendedProperties =
        (json['extendedProperties'] as Map)['shared'] as Map<String, dynamic>;
    eventType = EnumToString.fromString(
            EventType.values, extendedProperties['eventType']) ??
        EventType.unknown;
    teacherId = extendedProperties['teacherId'];
    studentIdList = extendedProperties['studentIdList'] != null
        ? jsonDecode(extendedProperties['studentIdList']!)
        : null;
    numPoints = extendedProperties['numPoints'] as int?;
    fillColor = _eventColorMap[eventType]!;
  }

  String? eventId;
  String? recurrenceId;
  String summary;
  String description;
  DateTime startTime;
  DateTime endTime;
  String timeZone;
  List<String>? recurrence;
  String? teacherId;
  List<String>? studentIdList;
  int? numPoints;
  EventType eventType = EventType.unknown;
  int fillColor = grey;

  Map<String, Object?> toJson() {
    return {
      'eventType': EnumToString.convertToString(eventType),
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

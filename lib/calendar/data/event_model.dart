import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rrule/rrule.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../generated/l10n.dart';

enum EventType {
  unknown,
  free,
  preschool,
  private;

  String getName(BuildContext context) {
    switch (this) {
      case unknown:
        return '¯\\_(ツ)_/¯';
      case free:
        return S.of(context).free;
      case preschool:
        return S.of(context).preschool;
      case private:
        return S.of(context).private;
    }
  }

  Color getColor(BuildContext context) {
    switch (this) {
      case unknown:
        return Colors.grey[100]!;
      case free:
        return Colors.amber[100]!;
      case preschool:
        return Colors.lightBlue[100]!;
      case private:
        return Colors.purple[100]!;
    }
  }

  Icon getIcon(BuildContext context) {
    switch (this) {
      case unknown:
        return const Icon(FontAwesomeIcons.question);
      case free:
        return const Icon(FontAwesomeIcons.personChalkboard);
      case preschool:
        return const Icon(FontAwesomeIcons.shapes);
      case private:
        return const Icon(FontAwesomeIcons.graduationCap);
    }
  }
}

enum EventDisplay {
  all,
  mine;

  String getName(BuildContext context) {
    switch (this) {
      case all:
        return S.of(context).allEvents;
      case mine:
        return S.of(context).myEvents;
    }
  }
}

List<Frequency> recurFrequencies = [
  Frequency.daily,
  Frequency.weekly,
  Frequency.monthly
];

class EventModel {
  String? eventId;
  String? recurrenceId;
  String summary;
  String description;
  tz.TZDateTime startTime;
  tz.TZDateTime endTime;
  String timeZone;

  List<String> recurrence;
  String? teacherId;
  List<String> studentIdList = [];
  late int numPoints;
  EventType eventType = EventType.unknown;

  EventModel({
    this.eventId,
    required this.eventType,
    required this.summary,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.timeZone,
    this.recurrence = const [],
    this.teacherId,
    this.studentIdList = const [],
    required this.numPoints,
  });

  /// Build object from response returned by Google Calendar API.
  EventModel.fromJson(
    Map<String, Object?> json, {
    required tz.Location location,
  })  : eventId = json['id'] as String,
        recurrenceId = json['recurringEventId'] as String?,
        summary = json['summary'] as String,
        description = json['description'] as String,
        startTime =
            tz.TZDateTime.parse(location, (json['start'] as Map)['dateTime']),
        endTime =
            tz.TZDateTime.parse(location, (json['end'] as Map)['dateTime']),
        recurrence = json['recurrence'] != null
            ? (json['recurrence'] as List<dynamic>)
                .map((e) => (e as String).replaceAll('WKST=SU', 'WKST=MO'))
                .toList()
            : [],
        timeZone = (json['start'] as Map)['timeZone'] as String {
    Map<String, dynamic> extendedProperties =
        (json['extendedProperties'] as Map)['shared'] as Map<String, dynamic>;
    eventType = EnumToString.fromString(
          EventType.values,
          extendedProperties['eventType'],
        ) ??
        EventType.unknown;
    teacherId = extendedProperties['teacherId'];
    studentIdList = extendedProperties['studentIdList'] != null
        ? jsonDecode(extendedProperties['studentIdList']).cast<String>()
        : [];
    numPoints = int.tryParse(extendedProperties['numPoints'] ?? 'none') ?? 0;
  }

  Map<String, Object?> toJson() {
    return {
      'eventId': eventId,
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
      event.startTime.year,
      event.startTime.month,
      event.startTime.day,
    );

    eventMap.putIfAbsent(localStartDay, () => []).add(event);
  }
  eventMap.forEach((key, value) {
    value.sort(((a, b) => a.startTime.compareTo(b.startTime)));
  });
  return eventMap;
}

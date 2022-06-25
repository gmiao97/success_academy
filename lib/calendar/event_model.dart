import 'package:timezone/timezone.dart' as tz;

enum EventType { free, preschool, private, myPreschool, myPrivate }

Map<EventType, int> _fillColorMap = {
  EventType.free: 0xfffbd75b, // yellow
  EventType.preschool: 0xffe1e1e1, // grey
  EventType.myPreschool: 0xffa4bdfc, // blue
  EventType.private: 0xffe1e1e1, // grey
  EventType.myPrivate: 0xffdbadff, // purple
};

Map<EventType, int> _borderColorMap = {
  EventType.free: 0xfffbd75b, // yellow
  EventType.preschool: 0xffa4bdfc, // blue
  EventType.myPreschool: 0xffa4bdfc, // blue
  EventType.private: 0xffdbadff, // purple
  EventType.myPrivate: 0xffdbadff, // purple
};

class EventModel {
  EventModel({
    required this.summary,
    required this.start,
    required this.end,
    required this.eventType,
  });

  /// Build object from response returned by Google Calendar API.
  EventModel.fromJson(
      Map<String, Object?> json, tz.Location timeZone, this.eventType)
      : summary = json['summary'] as String,
        start =
            tz.TZDateTime.parse(timeZone, (json['start'] as Map)['dateTime']),
        end = tz.TZDateTime.parse(timeZone, (json['end'] as Map)['dateTime']),
        fillColor = _fillColorMap[eventType] ?? 0xffe1e1e1, // grey
        bordercolor = _borderColorMap[eventType] ?? 0xffe1e1e1; // grey

  String summary;
  tz.TZDateTime start;
  tz.TZDateTime end;
  EventType eventType;
  int fillColor = 0xffe1e1e1; // grey
  int bordercolor = 0xffe1e1e1; // grey

  Map<String, Object?> toJson() {
    return {
      'summary': summary,
    };
  }
}

Map<DateTime, List<EventModel>> buildEventMap(List<EventModel> eventList) {
  Map<DateTime, List<EventModel>> eventMap = {};
  for (final event in eventList) {
    // table_calendar DateTimes for each day are in UTC, so this needs to match.
    final localStartDay =
        DateTime.utc(event.start.year, event.start.month, event.start.day);

    eventMap.putIfAbsent(localStartDay, () => []).add(event);
  }
  return eventMap;
}

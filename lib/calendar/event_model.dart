import 'package:timezone/timezone.dart' as tz;

enum CalendarType { free, preschool, private, myPreschool, myPrivate }

Map<CalendarType, int> _colorMap = {
  CalendarType.free: 0xfffbd75b,
  CalendarType.preschool: 0xffa4bdfc,
  CalendarType.myPreschool: 0xffa4bdfc,
  CalendarType.private: 0xffdbadff,
  CalendarType.myPrivate: 0xffdbadff,
};

class EventModel {
  EventModel({
    required this.summary,
    required this.start,
    required this.end,
  });

  EventModel.fromJson(Map<String, Object?> json, tz.Location timeZone,
      CalendarType calendarType)
      : summary = json['summary'] as String,
        start =
            tz.TZDateTime.parse(timeZone, (json['start'] as Map)['dateTime']),
        end = tz.TZDateTime.parse(timeZone, (json['end'] as Map)['dateTime']),
        color = _colorMap[calendarType] ?? 0xffe1e1e1;

  String summary;
  tz.TZDateTime start;
  tz.TZDateTime end;
  int color = 0xffe1e1e1;

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

import 'package:timezone/timezone.dart' as tz;

enum CalendarType { free, preschool, private }

class EventModel {
  EventModel({
    required this.summary,
    required this.start,
    required this.end,
  });

  EventModel.fromJson(
      Map<String, Object?> json, tz.Location timeZone, this.color)
      : summary = json['summary'] as String,
        start =
            tz.TZDateTime.parse(timeZone, (json['start'] as Map)['dateTime']),
        end = tz.TZDateTime.parse(timeZone, (json['end'] as Map)['dateTime']);

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

Map<DateTime, List<EventModel>> buildEventMap(
    CalendarType type, List<dynamic> eventList, tz.Location timeZone) {
  Map<DateTime, List<EventModel>> eventMap = {};
  for (final event in eventList) {
    final localStartTime =
        tz.TZDateTime.parse(timeZone, event['start']['dateTime']);
    // table_calendar DateTimes for each day are in UTC, so this needs to match.
    final localStartDay = DateTime.utc(
        localStartTime.year, localStartTime.month, localStartTime.day);

    int color;
    switch (type) {
      case CalendarType.free:
        color = 0xfffbd75b;
        break;
      case CalendarType.preschool:
        color = 0xffa4bdfc;
        break;
      case CalendarType.private:
        color = 0xffdbadff;
        break;
    }
    eventMap
        .putIfAbsent(localStartDay, () => [])
        .add(EventModel.fromJson(event, timeZone, color));
  }
  return eventMap;
}

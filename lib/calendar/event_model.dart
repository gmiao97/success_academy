import 'package:timezone/timezone.dart' as tz;

class EventModel {
  EventModel({
    required this.summary,
    required this.start,
    required this.end,
  });

  EventModel.fromJson(Map<String, Object?> json, tz.Location timeZone)
      : summary = json['summary'] as String,
        start =
            tz.TZDateTime.parse(timeZone, (json['start'] as Map)['dateTime']),
        end = tz.TZDateTime.parse(timeZone, (json['end'] as Map)['dateTime']);

  String summary;
  tz.TZDateTime start;
  tz.TZDateTime end;

  Map<String, Object?> toJson() {
    return {
      'summary': summary,
    };
  }
}

Map<DateTime, List<EventModel>> buildEventMap(
    List<dynamic> eventList, tz.Location timeZone) {
  Map<DateTime, List<EventModel>> eventMap = {};
  for (final event in eventList) {
    final localStartTime =
        tz.TZDateTime.parse(timeZone, event['start']['dateTime']);
    // table_calendar DateTimes for each day are in UTC, so this needs to match.
    final localStartDay = DateTime.utc(
        localStartTime.year, localStartTime.month, localStartTime.day);

    eventMap
        .putIfAbsent(localStartDay, () => [])
        .add(EventModel.fromJson(event, timeZone));
  }
  return eventMap;
}

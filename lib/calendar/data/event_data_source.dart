import 'package:flutter/material.dart';
import 'package:success_academy/helpers/tz_date_time_range.dart';
import 'package:timezone/timezone.dart' as tz show getLocation;
import 'package:timezone/timezone.dart' show TZDateTime;

import '../../data/data_source.dart';
import '../services/event_service.dart' as event_service;
import 'event_model.dart';

final class EventDataSource extends ChangeNotifier
    implements DataSource<Set<EventModel>, TZDateTimeRange> {
  EventDataSource({required this.timeZone});

  final String timeZone;
  final Set<EventModel> _eventsCache = {};

  TZDateTimeRange? _dateTimeRange;

  /// Loads event data that has a start timestamp between [dateTimeRange].
  @override
  Future<Set<EventModel>> loadData(TZDateTimeRange dateTimeRange) async {
    if (_dateTimeRange == null) {
      _dateTimeRange = dateTimeRange;
      await fetchAndStoreData();
      return Future.value(_eventsCache);
    }

    TZDateTime newStart = _dateTimeRange!.start;
    TZDateTime newEnd = _dateTimeRange!.end;
    if (dateTimeRange.start.isBefore(_dateTimeRange!.start)) {
      await _fetchAndStoreData(
        TZDateTimeRange(
          start: dateTimeRange.start,
          end: _dateTimeRange!.start,
        ),
      );
      newStart = dateTimeRange.start;
    }
    if (dateTimeRange.end.isAfter(_dateTimeRange!.end)) {
      await _fetchAndStoreData(
        DateTimeRange(
          start: dateTimeRange.end,
          end: _dateTimeRange!.end,
        ),
      );
      newEnd = dateTimeRange.end;
    }
    _dateTimeRange = TZDateTimeRange(start: newStart, end: newEnd);
    return Future.value(
      _eventsCache
          .where(
            (event) =>
                event.startTime.isAtSameMomentAs(dateTimeRange.start) ||
                (event.startTime.isAfter(dateTimeRange.start) &&
                    event.startTime.isBefore(dateTimeRange.end)),
          )
          .toSet(),
    );
  }

  @override
  Future<void> fetchAndStoreData() async {
    _eventsCache.clear();
    _eventsCache.addAll(
      await event_service.listEvents(
        location: tz.getLocation(timeZone),
        dateTimeRange: _dateTimeRange!,
        singleEvents: true,
      ),
    );
    return;
  }

  Future<void> _fetchAndStoreData(DateTimeRange dateTimeRange) async {
    _eventsCache.addAll(
      await event_service.listEvents(
        location: tz.getLocation(timeZone),
        dateTimeRange: _dateTimeRange!,
        singleEvents: true,
      ),
    );
    return;
  }
}

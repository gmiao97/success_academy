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

  TZDateTimeRange? _cacheDateTimeRange;

  @override
  Future<Set<EventModel>> loadData() async {
    return _eventsCache;
  }

  /// Loads event data that falls within [dateTimeRange].
  ///
  /// Includes events with an end timestamp greater than `dateTimeRange.start`
  /// and with a start timestamp less than `dateTimeRange.end`.
  @override
  Future<Set<EventModel>> loadDataByKey(TZDateTimeRange dateTimeRange) async {
    if (_cacheDateTimeRange == null) {
      _cacheDateTimeRange = dateTimeRange;
      await fetchAndStoreData();
      return Future.value(_eventsCache);
    }

    TZDateTime newStart = _cacheDateTimeRange!.start;
    TZDateTime newEnd = _cacheDateTimeRange!.end;
    if (dateTimeRange.start.isBefore(_cacheDateTimeRange!.start)) {
      await fetchAndStoreDataByKey(
        TZDateTimeRange(
          start: dateTimeRange.start,
          end: _cacheDateTimeRange!.start,
        ),
      );
      newStart = dateTimeRange.start;
    }
    if (dateTimeRange.end.isAfter(_cacheDateTimeRange!.end)) {
      await fetchAndStoreDataByKey(
        TZDateTimeRange(
          start: _cacheDateTimeRange!.end,
          end: dateTimeRange.end,
        ),
      );
      newEnd = dateTimeRange.end;
    }
    _cacheDateTimeRange = TZDateTimeRange(start: newStart, end: newEnd);
    return Future.value(
      _eventsCache
          .where(
            (event) =>
                event.endTime.isAfter(dateTimeRange.start) &&
                event.startTime.isBefore(dateTimeRange.end),
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
        dateTimeRange: _cacheDateTimeRange!,
        singleEvents: true,
      ),
    );
    return;
  }

  @override
  Future<void> fetchAndStoreDataByKey(TZDateTimeRange dateTimeRange) async {
    _eventsCache.addAll(
      await event_service.listEvents(
        location: tz.getLocation(timeZone),
        dateTimeRange: dateTimeRange,
        singleEvents: true,
      ),
    );
    return;
  }
}

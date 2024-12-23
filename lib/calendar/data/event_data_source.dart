import 'package:flutter/material.dart';
import 'package:success_academy/helpers/tz_date_time_range.dart';

import '../../data/data_source.dart';
import '../services/event_service.dart' as event_service;
import 'event_model.dart';

final class EventDataSource extends ChangeNotifier
    implements DataSource<Set<EventModel>, TZDateTimeRange> {
  EventDataSource._();

  factory EventDataSource() {
    return _instance;
  }

  static final EventDataSource _instance = EventDataSource._();

  final Set<EventModel> _eventsCache = {};
  final List<TZDateTimeRange> _cachedDateTimeRanges = [];

  @override
  Future<Set<EventModel>> loadData() async {
    return _eventsCache;
  }

  /// Loads event data that falls within [dateTimeRange].
  ///
  /// Includes events with any overlap with [dateTimeRange] i.e. an end
  /// timestamp greater than `dateTimeRange.start` and a start timestamp less
  /// than `dateTimeRange.end`.
  @override
  Future<Set<EventModel>> loadDataByKey(TZDateTimeRange dateTimeRange) async {
    await fetchAndStoreDataByKey(dateTimeRange);
    debugPrint('$_cachedDateTimeRanges');
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
    for (final dateTimeRange in _cachedDateTimeRanges) {
      _eventsCache.addAll(
        await event_service.listEvents(
          location: dateTimeRange.start.location,
          dateTimeRange: dateTimeRange,
          singleEvents: true,
        ),
      );
    }
    return;
  }

  @override
  Future<void> fetchAndStoreDataByKey(TZDateTimeRange dateTimeRange) async {
    _eventsCache.addAll(
      await event_service.listEvents(
        location: dateTimeRange.start.location,
        dateTimeRange: dateTimeRange,
        singleEvents: true,
      ),
    );
    _cachedDateTimeRanges.add(dateTimeRange);
    mergeTZDateTimeRanges(_cachedDateTimeRanges);
    return;
  }
}

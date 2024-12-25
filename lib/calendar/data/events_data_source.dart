import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:success_academy/calendar/data/event_model.dart';
import 'package:success_academy/calendar/data/events_cache.dart';
import 'package:success_academy/calendar/services/event_service.dart'
    as event_service;
import 'package:success_academy/data/data_source.dart';
import 'package:success_academy/helpers/tz_date_time_range.dart';

/// [DataSource] to handle fetching and caching of event data.
final class EventsDataSource extends ChangeNotifier
    implements DataSource<Set<EventModel>, TZDateTimeRange> {
  static final Logger _logger = Logger();

  final EventsCache _eventsCache = EventsCache();
  final List<TZDateTimeRange> _cachedDateTimeRanges = [];

  List<TZDateTimeRange> get cachedDateTimeRanges => _cachedDateTimeRanges;

  /// Loads all currently stored events.
  @override
  Future<Set<EventModel>> loadData() async {
    return _eventsCache.events;
  }

  /// Loads event data that falls within [dateTimeRange].
  ///
  /// Includes events with any overlap with [dateTimeRange] i.e. an end
  /// timestamp greater than `dateTimeRange.start` and a start timestamp less
  /// than `dateTimeRange.end`.
  @override
  Future<Set<EventModel>> loadDataByKey(TZDateTimeRange dateTimeRange) async {
    if (_cachedDateTimeRanges
        .every((range) => !range.contains(dateTimeRange))) {
      await fetchAndStoreDataByKey(dateTimeRange);
    }
    return Future.value(
      _eventsCache.events
          .where(
            (event) =>
                event.endTime.isAfter(dateTimeRange.start) &&
                event.startTime.isBefore(dateTimeRange.end),
          )
          .toSet(),
    );
  }

  /// Refetches and stores events according to [_cachedDateTimeRanges].
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

  /// Fetches and stores event data by [dateTimeRange].
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

  /// Stores [event] in local storage.
  void storeEvent(EventModel event) {
    if (_eventsCache.add(event)) {
      notifyListeners();
    }
  }

  /// Fetches instances of recurring [event] and stores them in local storage.
  Future<void> storeInstances(EventModel event) async {
    if (event.recurrence.isEmpty) {
      _logger.w('Called storeInstances with a non-recurrence event');
      return Future.value();
    }
    for (final dateTimeRange in _cachedDateTimeRanges) {
      _eventsCache.addAll(
        await event_service.listInstances(
          eventId: event.eventId!,
          location: dateTimeRange.start.location,
          dateTimeRange: dateTimeRange,
        ),
      );
    }
    notifyListeners();
  }
}

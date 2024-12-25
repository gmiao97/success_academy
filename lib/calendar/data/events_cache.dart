import 'package:success_academy/calendar/data/event_model.dart';

/// Cache for [EventModel] data.
///
/// TODO: Implement a better caching solution rather than in-memory cache.
class EventsCache {
  EventsCache._();

  factory EventsCache() {
    return _instance;
  }

  static final EventsCache _instance = EventsCache._();

  final Set<EventModel> _eventsCache = {};

  Set<EventModel> get events => _eventsCache;

  void clear() {
    _eventsCache.clear();
  }

  bool add(EventModel event) {
    return _eventsCache.add(event);
  }

  void addAll(Iterable<EventModel> events) {
    _eventsCache.addAll(events);
  }
}

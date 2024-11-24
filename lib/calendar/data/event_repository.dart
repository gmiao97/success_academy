import 'package:flutter/material.dart';

import 'event_model.dart';

class EventRepository extends ChangeNotifier {
  final List<EventModel> _eventsCache = [];
}

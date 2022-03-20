import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  EventModel({required this.title, required this.start, required this.end});

  EventModel._fromJson(Map<String, Object?> json)
      : title = json['title'] as String,
        start = (json['start'] as Timestamp).toDate(),
        end = (json['end'] as Timestamp).toDate();

  String title;
  DateTime start;
  DateTime end;

  Map<String, Object?> _toJson() {
    return {
      'title': title,
      'start': Timestamp.fromDate(start),
      'end': Timestamp.fromDate(end),
    };
  }
}

final CollectionReference<EventModel> eventModelRef = FirebaseFirestore.instance
    .collection('events')
    .withConverter<EventModel>(
        fromFirestore: (snapshot, _) => EventModel._fromJson(snapshot.data()!),
        toFirestore: (eventModel, _) => eventModel._toJson());

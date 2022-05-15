import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  EventModel({required this.title, required this.start, required this.end});

  EventModel.fromJson(Map<String, Object?> json)
      : title = json['title'] as String,
        start = (json['start'] as Timestamp).toDate(),
        end = (json['end'] as Timestamp).toDate();

  String title;
  DateTime start;
  DateTime end;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'start': Timestamp.fromDate(start),
      'end': Timestamp.fromDate(end),
    };
  }
}

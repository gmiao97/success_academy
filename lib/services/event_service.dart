import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:success_academy/calendar/event_model.dart';

final CollectionReference<EventModel> eventModelRef = FirebaseFirestore.instance
    .collection('events')
    .withConverter<EventModel>(
        fromFirestore: (snapshot, _) => EventModel.fromJson(snapshot.data()!),
        toFirestore: (eventModel, _) => eventModel.toJson());

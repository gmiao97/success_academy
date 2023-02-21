import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

/**  
  * Get list of all lesson information.
  */
Future<List<Map<String, Object?>>> getLessons({bool includePreschool = true}) {
  if (!includePreschool) {
    return db
        .collection('lessons')
        .where('visibility', isNotEqualTo: 'preschool')
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((queryDocumentSnapshot) => queryDocumentSnapshot.data())
            .toList());
  } else {
    return db.collection('lessons').get().then((querySnapshot) => querySnapshot
        .docs
        .map((queryDocumentSnapshot) => queryDocumentSnapshot.data())
        .toList());
  }
}

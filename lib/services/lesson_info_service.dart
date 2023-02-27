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
        .then(
            (querySnapshot) => querySnapshot.docs.map((queryDocumentSnapshot) {
                  final data = queryDocumentSnapshot.data();
                  data['id'] = queryDocumentSnapshot.id;
                  return data;
                }).toList());
  } else {
    return db.collection('lessons').get().then(
        (querySnapshot) => querySnapshot.docs.map((queryDocumentSnapshot) {
              final data = queryDocumentSnapshot.data();
              data['id'] = queryDocumentSnapshot.id;
              return data;
            }).toList());
  }
}

/**  
  * Update given lesson.
  */
Future<void> updateLesson(String id, Map<String, Object?> data) {
  return db.collection('lessons').doc(id).update(data);
}

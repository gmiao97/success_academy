import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:success_academy/lesson_info/lesson_model.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

CollectionReference<LessonModel> _lessonModelRef = db
    .collection('lessons')
    .withConverter<LessonModel>(
      fromFirestore: (snapshot, _) => LessonModel.fromJson(snapshot.data()!),
      toFirestore: (profileModel, _) => profileModel.toJson(),
    );

/**  
  * Get list of all lesson information.
  */
Future<List<LessonModel>> getLessons(
    {required bool includePreschool, required bool includeEnglish}) {
  return _lessonModelRef.get().then((querySnapshot) => querySnapshot.docs
          .map((queryDocumentSnapshot) => queryDocumentSnapshot.data())
          .where((lesson) {
        if (!includePreschool && lesson.visibility == 'preschool') {
          return false;
        }
        if (!includeEnglish && lesson.visibility == 'english') {
          return false;
        }
        return true;
      }).toList());
}

/**  
  * Update given lesson.
  */
Future<void> updateLesson(String id, LessonModel data) {
  return db.collection('lessons').doc(id).update(data.toJson());
}

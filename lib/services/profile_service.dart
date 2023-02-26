import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:success_academy/profile/profile_model.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

CollectionReference<StudentProfileModel> _studentProfileModelRefForUser(
    userId) {
  return db
      .collection('myUsers')
      .doc(userId)
      .collection('student_profiles')
      .withConverter<StudentProfileModel>(
        fromFirestore: (snapshot, _) => StudentProfileModel.fromFirestoreJson(
            snapshot.id, snapshot.data()!),
        toFirestore: (profileModel, _) => profileModel.toFirestoreJson(),
      );
}

CollectionReference<TeacherProfileModel> _teacherProfileModelRefForUser(
    userId) {
  return db
      .collection('myUsers')
      .doc(userId)
      .collection('teacher_profile')
      .withConverter<TeacherProfileModel>(
        fromFirestore: (snapshot, _) =>
            TeacherProfileModel.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (teacherProfileModel, _) => teacherProfileModel.toJson(),
      );
}

CollectionReference<AdminProfileModel> _adminProfileModelRefForUser(userId) {
  return db
      .collection('myUsers')
      .doc(userId)
      .collection('admin_profile')
      .withConverter<AdminProfileModel>(
        fromFirestore: (snapshot, _) =>
            AdminProfileModel.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (adminProfileModel, _) => adminProfileModel.toJson(),
      );
}

/**  
  * Get list of query snapshots for all profiles under the user
  * 
  * Returns list of document snapshots for each profile under 'profiles 
  * subcollection in the user doc under 'myUsers' collection. 
  */
Future<List<StudentProfileModel>> getStudentProfilesForUser(String userId) {
  return _studentProfileModelRefForUser(userId).get().then(
      (querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList());
}

/**  
  * Get teacher profile under the user
  * 
  * There should only be a single teacher profile under a user. 
  */
Future<TeacherProfileModel?> getTeacherProfileForUser(String userId) {
  return _teacherProfileModelRefForUser(userId).limit(1).get().then(
      (querySnapshot) =>
          querySnapshot.size != 0 ? querySnapshot.docs[0].data() : null);
}

/**  
  * Get admin profile under the user
  * 
  * There should only be a single admin profile under a user. 
  */
Future<AdminProfileModel?> getAdminProfileForUser(String userId) {
  return _adminProfileModelRefForUser(userId).limit(1).get().then(
      (querySnapshot) =>
          querySnapshot.size != 0 ? querySnapshot.docs[0].data() : null);
}

/**  
  * Get all teacher profiles
  */
Future<List<TeacherProfileModel>> getAllTeacherProfiles() {
  return db
      .collectionGroup('teacher_profile')
      .withConverter<TeacherProfileModel>(
        fromFirestore: (snapshot, _) =>
            TeacherProfileModel.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (teacherProfileModel, _) => teacherProfileModel.toJson(),
      )
      .get()
      .then((querySnapshot) =>
          querySnapshot.docs.map(((e) => e.data())).toList());
}

/**  
  * Get all student profiles
  */
Future<List<StudentProfileModel>> getAllStudentProfiles() {
  return db
      .collectionGroup('student_profiles')
      .withConverter<StudentProfileModel>(
        fromFirestore: (snapshot, _) => StudentProfileModel.fromFirestoreJson(
            snapshot.id, snapshot.data()!),
        toFirestore: (profileModel, _) => profileModel.toFirestoreJson(),
      )
      .get()
      .then((querySnapshot) =>
          querySnapshot.docs.map(((e) => e.data())).toList());
}

/// Check if saved profile in local storage belongs to user
Future<bool> studentProfileBelongsToUser(
    {required String userId, required String? profileId}) async {
  if (profileId == null) {
    return false;
  }
  return getStudentProfilesForUser(userId)
      .then((profiles) => profiles.any((p) => p.profileId == profileId));
}

/// Get number of points for student profile
Future<int> getNumberPoints(
    {required String userId, required String profileId}) async {
  return _studentProfileModelRefForUser(userId)
      .doc(profileId)
      .get()
      .then((profile) => profile.data()!.numPoints);
}

/// Add student profile for specified user
Future<DocumentReference<StudentProfileModel>> addStudentProfile(
    String userId, StudentProfileModel profileModel) async {
  final profileDoc =
      await _studentProfileModelRefForUser(userId).add(profileModel);
  return profileDoc;
}

/// Update student profile for specified user
Future<void> updateStudentProfile(
    String userId, StudentProfileModel profileModel) async {
  final profileDoc = await _studentProfileModelRefForUser(userId)
      .doc(profileModel.profileId)
      .update(profileModel.toFirestoreJson());
  return profileDoc;
}

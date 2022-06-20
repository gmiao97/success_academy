import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:success_academy/profile/profile_model.dart';
import 'package:success_academy/services/stripe_service.dart' as stripe_service;

final FirebaseFirestore db = FirebaseFirestore.instance;

CollectionReference<StudentProfileModel> _getStudentProfileModelRefForUser(
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

CollectionReference<TeacherProfileModel> _getTeacherProfileModelRefForUser(
    userId) {
  return db
      .collection('myUsers')
      .doc(userId)
      .collection('teacher_profile')
      .withConverter<TeacherProfileModel>(
        fromFirestore: (snapshot, _) =>
            TeacherProfileModel.fromJson(snapshot.data()!),
        toFirestore: (teacherProfileModel, _) => teacherProfileModel.toJson(),
      );
}

/**  
  * Get list of query snapshots for all profiles under the user
  * 
  * Returns list of document snapshots for each profile under 'profiles 
  * subcollection in the user doc under 'myUsers' collection. 
  */
Future<List<QueryDocumentSnapshot<StudentProfileModel>>>
    getStudentProfilesForUser(String userId) {
  return _getStudentProfileModelRefForUser(userId)
      .get()
      .then((querySnapshot) => querySnapshot.docs);
}

/**  
  * Get teacher profile under the user
  * 
  * There should only be a single teacher profile under a user. 
  */
Future<TeacherProfileModel?> getTeacherProfileForUser(String userId) {
  return _getTeacherProfileModelRefForUser(userId).limit(1).get().then(
      (querySnapshot) =>
          querySnapshot.size != 0 ? querySnapshot.docs[0].data() : null);
}

/// Check if saved profile in local storage belongs to user
Future<bool> studentProfileBelongsToUser(
    {required String userId, required String? profileId}) async {
  if (profileId == null) {
    return false;
  }
  return getStudentProfilesForUser(userId)
      .then((documentRefs) => documentRefs.any((doc) => doc.id == profileId));
}

/// Add student profile for specified user
Future<DocumentReference<StudentProfileModel>> addStudentProfile(
    String userId, StudentProfileModel profileModel) async {
  final profileDoc =
      await _getStudentProfileModelRefForUser(userId).add(profileModel);
  return profileDoc;
}

Future<bool> profileHasSubscription(
    {required String userId, required String profileId}) async {
  final subscriptionDocs = await stripe_service.getSubscriptionsForUser(userId);
  // Subscription metadata is written in startStripeSubscriptionCheckoutSession.
  return subscriptionDocs
      .any((doc) => doc.get('metadata.profile_id') as String == profileId);
}

Future<SubscriptionPlan?> getSubscriptionTypeForProfile(
    {required String userId, required String profileId}) async {
  final subscriptionDocs = await stripe_service.getSubscriptionsForUser(userId);
  // Subscription metadata is written in startStripeSubscriptionCheckoutSession.
  return EnumToString.fromString(
      SubscriptionPlan.values,
      subscriptionDocs
          .firstWhere(
              (doc) => doc.get('metadata.profile_id') as String == profileId)
          .get('items')[0]['plan']['metadata']['id']);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:random_string/random_string.dart';
import 'package:success_academy/account/account_model.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

final CollectionReference<MyUserModel> _myUserModelRef = db
    .collection('myUsers')
    .withConverter<MyUserModel>(
      fromFirestore: (snapshot, _) => MyUserModel.fromJson(snapshot.data()!),
      toFirestore: (myUserModel, _) => myUserModel.toJson(),
    );

/// Create document in 'myUsers' collection for user uid if not already existing
Future<void> createMyUserDocIfNotExist(String userId) async {
  final userDoc = await _myUserModelRef.doc(userId).get();
  if (!userDoc.exists) {
    final localTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    await _myUserModelRef.doc(userId).set(MyUserModel(
        referralCode: randomAlphaNumeric(8), timeZone: localTimeZone));
  }
}

/// Get specified MyUser instance
Future<MyUserModel?> getMyUserDoc(String userId) async {
  final userDoc = await _myUserModelRef.doc(userId).get();
  return userDoc.data();
}

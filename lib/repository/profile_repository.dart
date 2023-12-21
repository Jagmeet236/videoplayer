import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:videoplayer/constant/global_constant.dart';

import 'package:videoplayer/model/models.dart';

class ProfileRepository {
  final FirebaseFirestore firebaseFirestore;

  ProfileRepository({required this.firebaseFirestore});

  Future<UserData> getProfile({required String uid}) async {
    try {
      final DocumentSnapshot userDoc = await userRef.doc(uid).get();

      if (userDoc.exists) {
        final currentUser = UserData.fromDoc(userDoc);
        return currentUser;
      }

      throw 'User not found';
    } on FirebaseException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> addVideoUrlsToUserProfile({
    required String uid,
    required List<String> videoUrls,
  }) async {
    try {
      final DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      await userDocRef.update({
        'videoUrls': FieldValue.arrayUnion(videoUrls),
      });
    } on FirebaseException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}

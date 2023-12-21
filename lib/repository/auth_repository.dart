import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:videoplayer/constant/global_constant.dart';
import 'package:videoplayer/model/custom_error.dart';

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fbAuth.FirebaseAuth firebaseAuth;

  AuthRepository({required this.firebaseFirestore, required this.firebaseAuth});

  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<fbAuth.User?> get user => firebaseAuth.userChanges();

  Future<fbAuth.UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = fbAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      fbAuth.UserCredential? userCredential =
          await firebaseAuth.signInWithCredential(credential);

      final signedInUser = userCredential.user!;

      await userRef.doc(signedInUser.uid).set({
        'name': signedInUser.displayName,
        'email': signedInUser.email,
        'video': '',
      });

      return userCredential;
    } on fbAuth.FirebaseAuthException catch (e) {
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

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}

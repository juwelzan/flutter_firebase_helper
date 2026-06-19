// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, unused_element, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  static _EmailAndPasswordWithLoginOrCreate emailAndPasswordWithLoginOrCreate =
      _EmailAndPasswordWithLoginOrCreate();
}

class _EmailAndPasswordWithLoginOrCreate {
  final _auth = FirebaseAuth.instance;
  Future register({
    required String displayName,
    required String email,
    required String password,
    bool sendEmailVerification = false,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(displayName);
      if (sendEmailVerification) await cred.user?.sendEmailVerification();

      return cred.user!;
    } on FirebaseAuthException catch (e) {}
  }

  Future signIn({required String email, required String password}) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {}
  }
}

class _GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();

      if (googleUser == null) return;
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      return result.user!;
    } on FirebaseAuthException catch (e) {}
  }

  Future signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

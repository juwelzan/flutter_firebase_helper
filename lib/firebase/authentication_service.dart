// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, unused_element, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  ///
  ///
  ///
  ///
  ///
  ///
  ///    Register With Email password
  ///
  ///
  Future registerWithEmailPass({
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
    } on FirebaseAuthException {}
  }

  ///
  ///
  ///
  ///
  ///      SignIn With Email and password
  ///
  ///

  Future signInWithEmailPass({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException {}
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///    SignIn With Google
  ///
  ///

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
    } on FirebaseAuthException {}
  }

  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future verifyPasswordResetCode(String code) async {
    await _auth.verifyPasswordResetCode(code);
  }

  Future updatePassword(String newPassword) async {
    await _auth.currentUser?.updatePassword(newPassword);
  }

  ///
  ///
  ///
  /// login With Phone number
  ///
  ///
  Future sendOTPPhoneNumber({
    required String phoneNumber,
    Duration? timeout,
    required Function(String verificationId) onCodeSend,
    required Function(String error) onError,
    Function(PhoneAuthCredential phoneAuthCredential)? onAutoVerified,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,

        timeout: timeout ?? Duration(seconds: 120),
        verificationCompleted: (phoneAuthCredential) async {
          if (onAutoVerified != null) {
            onAutoVerified(phoneAuthCredential);
          } else {
            await _auth.signInWithCredential(phoneAuthCredential);
          }
        },
        verificationFailed: (error) {
          onError(error.message ?? "smutting wring");
        },
        codeSent: (verificationId, forceResendingToken) {
          onCodeSend(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {}
  }

  ///
  ///
  ///
  ///
  ///Sing out
  ///
  ///

  Future signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

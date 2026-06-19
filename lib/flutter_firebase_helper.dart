import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_helper/firebase/authentication_service.dart';
import 'package:flutter_firebase_helper/firebase/firebase_auth_state.dart';
export 'package:firebase_core/firebase_core.dart';

class FlutterFirebaseHelper {
  static final AuthenticationService authenticationService =
      AuthenticationService();
  static final FirebaseAuthState firebaseAuthState = FirebaseAuthState();
  static Future initializeApp({
    String? name,
    String? demoProjectId,
    FirebaseOptions? options,
  }) async {
    await Firebase.initializeApp(
      demoProjectId: demoProjectId,
      name: name,
      options: options,
    );
  }
}

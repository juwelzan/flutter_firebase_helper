import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_helper/firebase/authentication_service.dart';
export 'package:firebase_core/firebase_core.dart';

class FlutterFirebaseHelper {
  static AuthenticationService authenticationService = AuthenticationService();
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

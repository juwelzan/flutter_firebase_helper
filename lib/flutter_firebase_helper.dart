import 'package:firebase_core/firebase_core.dart';
export 'package:firebase_core/firebase_core.dart';

class FlutterFirebaseHelper {
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

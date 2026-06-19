// ignore_for_file: strict_top_level_inference

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthState {
  static FirebaseAuth fire = FirebaseAuth.instance;
  static Future<Widget> stateChanges({
    Widget? Function(BuildContext)? loadingScreen,
    required Widget Function(BuildContext, User) homeScreen,
    required Widget Function(BuildContext) loginScreen,
  }) async {
    return StreamBuilder(
      stream: fire.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingScreen!(context) ??
              Scaffold(
                body: Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
        }
        if (snapshot.hasData) {
          User user = fire.currentUser!;
          return homeScreen(context, user);
        }

        return loginScreen(context);
      },
    );
  }
}

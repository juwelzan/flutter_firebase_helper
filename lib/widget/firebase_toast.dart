import 'package:flutter/material.dart';

class FirebaseToast {
  static void showTop({required BuildContext context}) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(top: 100, left: 20, right: 20, child: Material());
      },
    );
  }
}

import 'package:flutter/material.dart';

class HelperWidget extends StatelessWidget {
  final Size size;
  final double height, sizeTween, opacityTween, borderRadiusTween, borderRadius;
  final bool isSlide, bubble, widgetShow;
  const HelperWidget({
    super.key,
    required this.size,
    required this.height,
    required this.sizeTween,
    required this.opacityTween,
    required this.isSlide,
    required this.bubble,
    required this.widgetShow,
    required this.borderRadiusTween,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSlide
          ? (bubble
              ? (height * sizeTween).clamp(40, height)
              : height * sizeTween)
          : (height * sizeTween),
      width: isSlide
          ? (bubble
              ? (size.width * sizeTween).clamp(40, size.width)
              : (size.width * sizeTween))
          : size.width * sizeTween,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(
          bubble
              ? (100 * borderRadiusTween).clamp(borderRadius, 100)
              : borderRadius,
        ),
      ),
      child: bubble
          ? (widgetShow
              ? Opacity(
                  opacity: opacityTween,
                  child: Center(child: Text("data")),
                )
              : SizedBox())
          : Center(child: Text("data")),
    );
  }
}

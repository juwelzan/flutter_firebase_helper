// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_firebase_helper/widget/firebase_toast/helper_widget.dart';

class ToastWidget extends StatefulWidget {
  final bool isSlide, bubble;
  final VoidCallback onEnd;
  final Offset position;
  final double height, width, borderRadius;
  const ToastWidget({
    super.key,
    this.isSlide = true,
    this.position = Offset.zero,
    this.height = 50,
    this.width = 50,
    this.bubble = true,
    required this.onEnd,
    this.borderRadius = 10,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with TickerProviderStateMixin {
  ///
  ///
  /// AnimationController
  late AnimationController _slideTransitionController;
  late AnimationController _sizeController;
  late AnimationController _showWidgetController;

  ///
  ///
  ///
  /// Animation
  late Animation<Offset> _slideTransition;
  late Animation<double> _size;
  late Animation<double> _borderRadius;

  late Animation<double> _showWidgetOpacity;

  ///
  ///
  /// ValueNotifier
  ValueNotifier<bool> _isShowWidget = ValueNotifier<bool>(false);

  ///
  ///
  ///
  /// initState setup
  @override
  void initState() {
    super.initState();

    ///
    ///
    /// AnimationController setup
    _slideTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _sizeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _showWidgetController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    ///
    ///
    /// Animation and Tween setup
    _slideTransition = Tween<Offset>(
      begin: widget.isSlide ? widget.position : Offset.zero,
      end: Offset.zero,
    ).animate(_slideTransitionController);

    _size = Tween<double>(
      begin: widget.bubble ? 0 : 1,
      end: 1,
    ).animate(_sizeController);
    _borderRadius = Tween<double>(begin: 1, end: 0).animate(_sizeController);
    _showWidgetOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_showWidgetController);

    _animationStart();
  }

  Future<void> _animationStart() async {
    await _slideTransitionController.forward();
    await _sizeController.forward();
    _isShowWidget.value = true;
    await _showWidgetController.forward();
    await Future.delayed(Duration(milliseconds: 400));
    _animationEnd();
  }

  Future<void> _animationEnd() async {
    if (!mounted) return;
    _showWidgetController.reverse();
    await _sizeController.reverse();
    _isShowWidget.value = false;
    await _slideTransitionController.reverse();
    await Future.delayed(Duration(milliseconds: 200));
    widget.onEnd();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: Listenable.merge([
        _showWidgetController,
        _slideTransitionController,
        _sizeController,
      ]),
      builder: (context, childS) {
        return ValueListenableBuilder(
          valueListenable: _isShowWidget,
          builder: (context, value, child) {
            return child!;
          },
          child: SlideTransition(
            position: _slideTransition,
            child: Column(
              children: [
                HelperWidget(
                  size: size,
                  height: widget.height,
                  sizeTween: _size.value,
                  opacityTween: _showWidgetOpacity.value,
                  isSlide: widget.isSlide,
                  bubble: widget.bubble,
                  widgetShow: _isShowWidget.value,
                  borderRadiusTween: _borderRadius.value,
                  borderRadius: widget.borderRadius,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///
  ///
  /// Disposing controller
  @override
  void dispose() {
    _showWidgetController.dispose();
    _sizeController.dispose();
    _slideTransitionController.dispose();
    _isShowWidget.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';
import 'package:yelpax_pro/main.dart';

class CustomFlutterToast {
  static OverlayEntry? _currentToast;

  static void showToast({
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _currentToast?.remove();
    _currentToast = null;

    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    Color backgroundColor;
    Color textColor = Colors.white;
    IconData? icon;

    switch (type) {
      case ToastType.success:
        backgroundColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = AppColors.error;
        icon = Icons.error;
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      case ToastType.info:
      default:
        backgroundColor = AppColors.primary;
        icon = Icons.info;
        break;
    }

    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: _ToastAnimation(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentToast!);

    Future.delayed(duration, () {
      _currentToast?.remove();
      _currentToast = null;
    });
  }

  static void showSuccessToast(String message, {Duration? duration}) {
    showToast(
      message: message,
      type: ToastType.success,
      duration: duration ?? Duration(seconds: 3),
    );
  }

  static void showErrorToast(String message, {Duration? duration}) {
    showToast(
      message: message,
      type: ToastType.error,
      duration: duration ?? Duration(seconds: 3),
    );
  }

  static void showWarningToast(String message, {Duration? duration}) {
    showToast(
      message: message,
      type: ToastType.warning,
      duration: duration ?? Duration(seconds: 3),
    );
  }

  static void showInfoToast(String message, {Duration? duration}) {
    showToast(
      message: message,
      type: ToastType.info,
      duration: duration ?? Duration(seconds: 3),
    );
  }
}

enum ToastType { success, error, warning, info }

class _ToastAnimation extends StatefulWidget {
  final Widget child;

  const _ToastAnimation({required this.child});

  @override
  State<_ToastAnimation> createState() => _ToastAnimationState();
}

class _ToastAnimationState extends State<_ToastAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(opacity: _fade, child: widget.child),
    );
  }
}

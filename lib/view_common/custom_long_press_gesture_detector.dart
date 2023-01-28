import 'dart:async';

import 'package:flutter/material.dart';

class CustomLongPressGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const CustomLongPressGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  static Timer? _timer;
  static const int _longPressTimeMs = 300;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _timer = Timer(
          const Duration(milliseconds: _longPressTimeMs),
          () {
            onLongPress?.call();
          },
        );
      },
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapUp(),
      onDoubleTap: onDoubleTap,
      child: child,
    );
  }

  void _onTapUp() {
    _invokeTapAction();
  }

  void _invokeTapAction() {
    if (_timer == null) {
      return;
    }

    if (_timer!.isActive) {
      onTap?.call();
    }
    _timer!.cancel();
  }
}

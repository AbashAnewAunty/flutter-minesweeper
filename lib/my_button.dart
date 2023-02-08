import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const MyButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isSelected = false;
  static const double _unselectedSize = 20;
  static const double _selectedSize = 40;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        widget.onPressed?.call();
        setState(() => _isSelected = !_isSelected);
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      enableFeedback: false,
      child: Container(
        width: _isSelected ? _selectedSize : _unselectedSize,
        height: _isSelected ? _selectedSize : _unselectedSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.backgroundColor ?? Colors.red,
        ),
      ),
    );
  }
}

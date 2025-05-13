import 'package:flutter/material.dart';

class CustomIconBtn extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final double buttonWidth;
  final double buttonheight;
  final Color backgroundColor;
  final double borderRadius;
  const CustomIconBtn({
    super.key,
    required this.onPressed,
    required this.child,
    this.buttonWidth = double.infinity,
    this.buttonheight = 60,
    this.backgroundColor = const Color(0xffF3B4C4),
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonheight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}

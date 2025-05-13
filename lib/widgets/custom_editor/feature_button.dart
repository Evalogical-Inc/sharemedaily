import 'package:flutter/material.dart';

class FeatureButton extends StatelessWidget {
  final double? width;
  final Widget? widget;
  final IconData? icon;
  final String buttonText;
  final void Function() onPressed;
  final bool isActive;
  const FeatureButton({
    super.key,
    required this.onPressed,
    this.width,
    this.icon,
    required this.buttonText,
    this.widget,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        side: BorderSide(
          color: isActive ? Colors.white : Colors.white54,
          width: isActive ? 1.5 : 1,
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 3.21,
          children: [
            widget ??
                Icon(icon, color: isActive ? Colors.white : Colors.white54),
            Text(
              buttonText,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white54,
                fontWeight: isActive ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

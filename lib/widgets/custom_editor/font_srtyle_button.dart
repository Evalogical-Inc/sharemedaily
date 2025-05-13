import 'package:flutter/material.dart';

class FontStyleButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final String fontFamily;
  final bool isActive;
  const FontStyleButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.fontFamily,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.white : Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: fontFamily,
            color: isActive ? Colors.black : Colors.white,
            fontWeight: isActive ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}

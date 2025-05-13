import 'package:flutter/material.dart';

class TextAlignButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  final String text;
  final bool isActive;
  const TextAlignButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.65),
        ),
        side: BorderSide(
          color: isActive ? Colors.white : Colors.white54,
          width: isActive ? 1.5 : 1,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.white54),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white54,
              fontWeight: isActive ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}

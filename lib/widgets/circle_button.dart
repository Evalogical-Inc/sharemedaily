import 'package:flutter/material.dart';
import 'package:quotify/config/constants/colors.dart';

class CircleButton extends StatelessWidget {
  final double diameter;
  final Widget child;
  final Color? backgroundColor;
  final void Function()? onTap;
  const CircleButton({
    super.key,
    required this.diameter,
    required this.child,
    this.backgroundColor = AppColors.lightGrey,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        color: backgroundColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: diameter,
              height: diameter,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

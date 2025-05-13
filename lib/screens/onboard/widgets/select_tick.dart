import 'package:flutter/material.dart';
import 'package:quotify/config/constants/colors.dart';

class SelectedTick extends StatelessWidget {
  const SelectedTick({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 14,
      backgroundColor: AppColors.defaultPink,
      child: Icon(
        Icons.done,
        color: AppColors.black,
        size: 18,
      ),
    );
  }
}
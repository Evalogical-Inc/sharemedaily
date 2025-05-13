import 'package:flutter/material.dart';
import 'package:quotify/config/constants/colors.dart';

class ScrollHandle extends StatelessWidget {
  const ScrollHandle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.defaultGrey,
              borderRadius: BorderRadius.circular(50),
            ),
          )
        ],
      ),
    );
  }
}

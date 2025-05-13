import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/provider/theme_provider.dart';

class Shimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  const Shimmer(
      {super.key, this.width = 10, this.height = 10, this.borderRadius = 16});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvier>(builder: (context, themeProvider, _) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          color: themeProvider.brightness == Brightness.light
              ? AppColors.black.withOpacity(0.04)
              : AppColors.white.withOpacity(0.4),
        ),
      );
    });
  }
}

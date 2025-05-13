import 'package:flutter/material.dart';
import 'package:quotify/widgets/clippers.dart';

class SplashBackgroundEllips extends StatelessWidget {
  const SplashBackgroundEllips({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: BackgroundClipper(),
          child: Container(
            color: const Color(0xffF7F5FD),
          ),
        ),
        ClipPath(
          clipper: ForgroundClipper(),
          child: Container(
            color: const Color(0xffF1EDFB),
          ),
        ),
      ],
    );
  }
}
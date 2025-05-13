import 'package:flutter/material.dart';
import 'package:quotify/widgets/clippers.dart';

class LoginBgEllips extends StatelessWidget {
  const LoginBgEllips({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: LoginBgClipper(),
      child: Container(
        color: const Color(0xffF7F5FD),
      ),
    );
  }
}

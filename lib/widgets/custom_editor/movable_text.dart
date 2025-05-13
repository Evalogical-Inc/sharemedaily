import 'package:flutter/material.dart';

class _MovableText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _MovableText({required this.text, required this.style});

  @override
  State<_MovableText> createState() => _MovableTextState();
}

class _MovableTextState extends State<_MovableText> {
  Offset position = const Offset(100, 100);
  double scale = 1.0;
  double rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        onScaleUpdate: (details) {
          setState(() {
            scale = details.scale;
            rotation = details.rotation;
          });
        },
        child: Transform(
          transform: Matrix4.identity()
            ..scale(scale)
            ..rotateZ(rotation),
          alignment: Alignment.center,
          child: Text(widget.text, style: widget.style),
        ),
      ),
    );
  }
}
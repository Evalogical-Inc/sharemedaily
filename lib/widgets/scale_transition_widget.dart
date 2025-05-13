import 'package:flutter/material.dart';


class ScaleTransitionWidget extends StatefulWidget {
  final Widget child;
  final int? duration;
  final double? begin;
  final double? end;
  final bool isSelected;
  final Function()? onTap;
  const ScaleTransitionWidget({
    super.key,
    required this.child,
    this.duration = 300,
    this.begin = 1.0,
    this.end = 0.9,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<ScaleTransitionWidget> createState() => _ScaleTransitionWidgetState();
}

class _ScaleTransitionWidgetState extends State<ScaleTransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: widget.begin, end: widget.end)
        .animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void select() {
    _animationController.forward();
  }

  void deSelect() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    widget.isSelected
        ? _animationController.forward()
        : _animationController.reverse();
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

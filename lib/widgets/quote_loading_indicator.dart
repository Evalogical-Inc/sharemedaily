import 'package:flutter/material.dart';

class QuoteLoadingIndicator extends StatefulWidget {
  const QuoteLoadingIndicator({super.key});

  @override
  State<QuoteLoadingIndicator> createState() => _QuoteLoadingIndicatorState();
}

class _QuoteLoadingIndicatorState extends State<QuoteLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Tween<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = Tween<double>(begin: 0.6, end: 1);

    animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation.animate(animationController),
      child: Image.asset('assets/images/placeholder.png'),
    );
  }
}

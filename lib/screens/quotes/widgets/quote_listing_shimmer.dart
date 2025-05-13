import 'package:flutter/material.dart';
import 'package:quotify/widgets/shimmer.dart';

class QuoteListingShimmer extends StatelessWidget {
  const QuoteListingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: 10,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
      ),
      itemBuilder: (context, index) => const Shimmer(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/widgets/shimmer.dart';

class QuoteListingLoadingIndicator extends StatelessWidget {
  const QuoteListingLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      primary: false,
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, index) => Column(
        children: [
          AppSpacing.height40,
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer(
                width: 160,
                height: 15,
                borderRadius: 10,
              ),
              Shimmer(
                width: 60,
                height: 10,
                borderRadius: 10,
              ),
            ],
          ),
          AppSpacing.height20,
          SizedBox(
            height: deviceSize.height * 0.2,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) =>  Shimmer(
                width: deviceSize.width / 2,
              ),
              separatorBuilder: (context, index) => AppSpacing.width20,
            ),
          ),
        ],
      ),
      separatorBuilder: (context, index) => AppSpacing.height10,
    );
  }
}

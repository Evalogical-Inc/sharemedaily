import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/widgets/custom_icon_btn.dart';

class OnboardEndScreen extends StatelessWidget {
  const OnboardEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _topSection(context),
                _bottomSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomSection(BuildContext context) {
    return CustomIconBtn(
      buttonWidth: MediaQuery.of(context).size.width * 0.8,
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'landing');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Take me to home',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
          ),
          AppSpacing.width10,
          const Icon(
            Icons.arrow_forward,
            color: AppColors.black,
          )
        ],
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          'Hurray!  Get in to the world\nof Your Affirmations!',
          style: textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          'You can also add a widget of your daily affirmation in your home screen. Check the widgets in your phone and look for QuoteZen Widget, add and enjoy!',
          style: textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        AppSpacing.height40,
        SvgPicture.asset(
          'assets/images/onboard_end_img.svg',
          width: MediaQuery.of(context).size.width * 0.8,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/onboard/widgets/scheddule_bottom_sheet.dart';
import 'package:quotify/widgets/app_bottom_sheet.dart';
import 'package:quotify/widgets/custom_icon_btn.dart';

class OnboardScheduleScreen extends StatelessWidget {
  const OnboardScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
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
    );
  }

  Row _bottomSection(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.onboardEnd);
          },
          child: Text(
            'Skip',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        CustomIconBtn(
          buttonWidth: deviceSize.width * 0.4,
          buttonheight: 65,
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.onboardEnd);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next',
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
        )
      ],
    );
  }

  Widget _topSection(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Choose a time for you to\nsee the Quotes',
            style: textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'You can also choose a time, time period to see\nthe quotes as notification in your phone lock\nscreen.',
            style: textTheme.bodySmall,
          ),
        ),
        AppSpacing.height40,
        SvgPicture.asset(
          'assets/images/schedule.svg',
          width: deviceSize.width * 0.5,
        ),
        AppSpacing.height20,
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            side: const BorderSide(color: AppColors.lightPurple),
          ),
          onPressed: () {
            _showModalBottomSheet(context, deviceSize);
          },
          child: SizedBox(
            width: deviceSize.width * 0.5,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 12,
                  child: Icon(
                    Icons.add,
                    color: AppColors.purple,
                    size: 15,
                  ),
                ),
                AppSpacing.width10,
                Text(
                  'Create your reminder',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.purple),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _showModalBottomSheet(BuildContext context, Size deviceSize) {
    AppBottomSheet.showBottomSheet(
      context: context,
      isScrollControlled: true,
      body: const OnboardScheduleBottomSheet(),
    );
  }
}

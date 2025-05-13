import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/add_reminder/widgets/remider_card.dart';
import 'package:quotify/widgets/custom_icon_btn.dart';

class AddReminderScreen extends StatefulWidget {
  final bool isOnBoarded;
  final bool isBackBtnEnabled;

  const AddReminderScreen(
      {super.key, this.isOnBoarded = true, this.isBackBtnEnabled = true});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.isOnBoarded ? _appBar(context) : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: 18,
              top: widget.isOnBoarded ? 0 : 18,
              right: 18,
              bottom: 18),
          child: Column(
            children: [
              _titleSection(context, widget.isOnBoarded),
              _reminderList(context),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.isOnBoarded
          ? FloatingActionButton(
              backgroundColor: AppColors.defaultPink,
              onPressed: () {},
              child: const Icon(
                Icons.add,
                color: AppColors.black,
              ),
            )
          : CustomIconBtn(
              buttonWidth: deviceSize.width * 0.4,
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
                  AppSpacing.width5,
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      leading: widget.isBackBtnEnabled
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color:
                    Provider.of<ThemeProvier>(context, listen: false).isDarkMode
                        ? Colors.white
                        : Colors.black,
              ),
            )
          : null,
      title: Text(
        'Set your Reminders',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _reminderList(BuildContext context) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return ReminderCard(index: index);
      },
      separatorBuilder: (context, index) => AppSpacing.height10,
    );
  }

  Widget _titleSection(BuildContext context, bool isOnBoarded) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isOnBoarded
            ? const SizedBox()
            : Text(
                'Choose a time for you to\n see the Quotes',
                style: textTheme.titleLarge,
              ),
        Text(
          'You can also choose a time, time period to see the quotes as notification in your phone lock screen.',
          style: textTheme.bodySmall,
        ),
        AppSpacing.height10,
      ],
    );
  }
}

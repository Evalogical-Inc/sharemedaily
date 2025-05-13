import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/onbord_schedule_provider.dart';
import 'package:quotify/screens/add_reminder/add_reminder_screen.dart';
import 'package:quotify/widgets/circle_button.dart';
import 'package:quotify/screens/onboard/widgets/select_tick.dart';
import 'package:quotify/widgets/custom_icon_btn.dart';
import 'package:quotify/widgets/custom_page_route.dart';
import 'package:quotify/widgets/image_container.dart';
import 'package:quotify/widgets/scale_transition_widget.dart';
import 'package:quotify/widgets/scroll_handle.dart';

class OnboardScheduleBottomSheet extends StatelessWidget {
  const OnboardScheduleBottomSheet({super.key, required});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Stack(
                  children: [
                    const ScrollHandle(),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Create your reminder',
                                  style: textTheme.titleLarge,
                                ),
                              ],
                            ),
                            AppSpacing.height10,
                            Consumer2<OnboardScheduleProvider,
                                CategoryProvider>(
                              builder: (context, onboardScheduleProvider,
                                  categoryProvider, _) {
                                return Column(
                                  children: [
                                    AppSpacing.height10,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CustomIconBtn(
                                          backgroundColor: AppColors.lightGrey,
                                          buttonWidth: deviceSize.width * 0.4,
                                          onPressed: () {
                                            showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now());
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Set your time',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                        letterSpacing: 0,
                                                        fontSize: 12,
                                                        color: AppColors.black),
                                              ),
                                              AppSpacing.width5,
                                              const Icon(
                                                Icons.access_time,
                                                size: 22,
                                                color: AppColors.defaultGrey,
                                              )
                                            ],
                                          ),
                                        ),
                                        CustomIconBtn(
                                          backgroundColor: AppColors.lightGrey,
                                          buttonWidth: deviceSize.width * 0.4,
                                          onPressed: () {
                                            showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 1));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 22,
                                                color: AppColors.defaultGrey,
                                              ),
                                              AppSpacing.width5,
                                              Text(
                                                'Select Month',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      letterSpacing: 0,
                                                      fontSize: 12,
                                                      color: AppColors.black,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppSpacing.height10,
                                    const Divider(),
                                    AppSpacing.height10,
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Select the days you want the reminder',
                                        style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    AppSpacing.height10,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleButton(
                                          onTap: () {},
                                          diameter: 40,
                                          child: const Text('M'),
                                        ),
                                        CircleButton(
                                          onTap: () {},
                                          diameter: 40,
                                          child: const Text('Tu'),
                                        ),
                                        CircleButton(
                                          onTap: () {},
                                          diameter: 40,
                                          child: const Text('W'),
                                        ),
                                        CircleButton(
                                          onTap: () {},
                                          diameter: 40,
                                          child: const Text('Th'),
                                        ),
                                        CircleButton(
                                          onTap: () {},
                                          diameter: 40,
                                          child: const Text('Fr'),
                                        ),
                                        CircleButton(
                                          onTap: () {},
                                          diameter: 40,
                                          child: const Text('Sa'),
                                        ),
                                        CircleButton(
                                          onTap: () {},
                                          diameter: 40,
                                          child: const Text('S'),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                              ),
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                onboardScheduleProvider
                                                        .isWhoeWeekSelected
                                                    ? AppColors.purple
                                                    : AppColors.lightGrey,
                                              ),
                                              value: onboardScheduleProvider
                                                  .isWhoeWeekSelected,
                                              onChanged: (val) {
                                                onboardScheduleProvider
                                                    .isWhoeWeekSelected = val!;
                                              },
                                            ),
                                            AppSpacing.width5,
                                            const Text('Whole Week')
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                              ),
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                onboardScheduleProvider
                                                        .isWhoeMonthSelected
                                                    ? AppColors.purple
                                                    : AppColors.lightGrey,
                                              ),
                                              value: onboardScheduleProvider
                                                  .isWhoeMonthSelected,
                                              onChanged: (val) {
                                                onboardScheduleProvider
                                                    .isWhoeMonthSelected = val!;
                                              },
                                            ),
                                            AppSpacing.width5,
                                            const Text('Whole Month')
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    AppSpacing.height10,
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Select Categories',
                                        style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    AppSpacing.height20,
                                    GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      itemCount: categoryProvider
                                          .categoryResponse.result.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 0,
                                        crossAxisSpacing: 0,
                                        childAspectRatio: 2 / 1,
                                      ),
                                      itemBuilder: (context, index) {
                                        return ScaleTransitionWidget(
                                          isSelected: categoryProvider
                                              .categoryResponse
                                              .result[index]
                                              .isSelected,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 8.0),
                                                child: ImageContainer(
                                                  imgPath: categoryProvider
                                                      .categoryResponse
                                                      .result[index]
                                                      .categoryImage,
                                                  child: Text(
                                                    categoryProvider
                                                        .categoryResponse
                                                        .result[index]
                                                        .category,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color:
                                                              AppColors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  onTap: () {
                                                    if (categoryProvider
                                                            .categoryResponse
                                                            .result[index]
                                                            .isSelected ==
                                                        false) {
                                                      categoryProvider
                                                          .handleOnboardCategorySelection(
                                                              index);
                                                    } else {
                                                      categoryProvider
                                                          .handleOnboardCategorySelection(
                                                              index,);
                                                    }
                                                  },
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    categoryProvider
                                                        .categoryResponse
                                                        .result[index]
                                                        .isSelected,
                                                child: const Positioned(
                                                  top: 1,
                                                  left: 1,
                                                  child: SelectedTick(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      child: CustomIconBtn(
                        buttonWidth: deviceSize.width - 36,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            CustomPageRoute(
                              child: const AddReminderScreen(
                                isOnBoarded: false,
                                isBackBtnEnabled: false,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_alarms,
                              color: AppColors.black,
                            ),
                            AppSpacing.width10,
                            Text(
                              'Set reminder',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}

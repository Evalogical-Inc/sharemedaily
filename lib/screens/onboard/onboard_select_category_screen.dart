import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/helpers/helpers.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/daily_quotes_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/onboard/widgets/select_tick.dart';
import 'package:quotify/widgets/custom_icon_btn.dart';
import 'package:quotify/widgets/image_container.dart';
import 'package:quotify/widgets/scale_transition_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardSelectCategoryScreen extends StatefulWidget {
  final bool isOnBoarded;
  const OnboardSelectCategoryScreen({super.key, this.isOnBoarded = true});

  @override
  State<OnboardSelectCategoryScreen> createState() =>
      _OnboardSelectCategoryScreenState();
}

class _OnboardSelectCategoryScreenState
    extends State<OnboardSelectCategoryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.isCategoryUpdated = false;
    });
    fetchUserCategories();
    super.initState();
  }

  CategoryProvider categoryProvider =
      Provider.of<CategoryProvider>(scaffoldKey.currentContext!, listen: false);

  fetchUserCategories() async {
    var connectionResult = await Helpers().checkConnectivity(context);
    if (connectionResult) {
      final sp = await SharedPreferences.getInstance();
      var tokenData = sp.getString(SP.tokenData);
      if (tokenData != null) {
        await categoryProvider.fetchUserCategories();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isOnBoarded ? _appBar(context) : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _topSection(context, widget.isOnBoarded),
              _centerSection(context),
              _bottomSection(context, widget.isOnBoarded),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Provider.of<ThemeProvier>(context, listen: false).isDarkMode
              ? Colors.white
              : Colors.black,
        ),
      ),
      title: Text(
        'Select your Category',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _bottomSection(BuildContext context, bool isOnBoarded) {
    var deviceSize = MediaQuery.of(context).size;
    return Consumer2<CategoryProvider, DailyQuotesProvider>(
        builder: (context, categoryProvider, dailyQuotesProvider, _) =>
            isOnBoarded
                ? categoryProvider.isCategoryUpdated
                    ? ElevatedButton.icon(
                        onPressed: (categoryProvider.saveUserCategoryStatus ==
                                ApiStatus.isLoading)
                            ? null
                            : () async {
                                await categoryProvider
                                    .saveUserSelectedCategories();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content:
                                        Text('Categories updated successfully'),
                                  ),
                                );
                                categoryProvider.isCategoryUpdated = false;
                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffF3B4C4),
                            minimumSize: Size(
                                MediaQuery.of(context).size.width - 54, 50),
                            padding:
                                const EdgeInsets.symmetric(vertical: 10.0)),
                        icon: (categoryProvider.saveUserCategoryStatus ==
                                ApiStatus.isLoading)
                            ? Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2.0),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : SizedBox(),
                        label: const Text(
                          'SAVE',
                          style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold),
                        ),
                      )
                    : const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.onboardEnd);
                          },
                          child: Text(
                            'Skip',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        CustomIconBtn(
                          buttonWidth: deviceSize.width * 0.4,
                          buttonheight: 65,
                          onPressed: () async {
                            await categoryProvider.saveUserSelectedCategories();
                            await Future.delayed(
                                const Duration(microseconds: 50), () async {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.onboardEnd);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                              ),
                              AppSpacing.width10,
                              if (categoryProvider.saveUserCategoryStatus ==
                                  ApiStatus.isLoading)
                                Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 3,
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.black,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
  }

  void categorySavingSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        onVisible: () {},
        behavior: SnackBarBehavior.floating,
        content: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Updating categories...'),
            CircularProgressIndicator(
              color: AppColors.facebookBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _centerSection(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var containerWidth = deviceSize.width - 18;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Consumer<CategoryProvider>(
          builder: (context, dataClass, _) {
            return ListView.builder(
              itemCount: dataClass.categoryResponse.result.length,
              itemBuilder: (context, index) {
                return _categoryWidget(
                    dataClass, index, containerWidth, context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _categoryWidget(CategoryProvider dataClass, int index,
      double containerWidth, BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
      // var isSelected = dataClass.userCategoryResponse.result.any((item) =>
      //     item.categoryId == dataClass.categoryResponse.result[index].id);
      var isSelected = dataClass.userCategoryLocal.any((item) {
        var category = item as Map<String, dynamic>; // Cast item to a map
        return category['category_id'] ==
            dataClass.categoryResponse.result[index].id;
      });

      return ScaleTransitionWidget(
        isSelected: isSelected,
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
              child: ImageContainer(
                imgPath: categoryProvider
                    .categoryResponse.result[index].categoryImage,
                width: containerWidth,
                height: 120,
                onTap: () {
                  categoryProvider.handleOnboardCategorySelection(index);
                  categoryProvider.isCategoryUpdated = true;
                  // if (isSelected) {
                  //   categoryProvider.removeUserCategories(
                  //       categoryId:
                  //           categoryProvider.categoryResponse.result[index].id);
                  // } else {
                  //   categoryProvider.addUserCategories(
                  //       categoryId:
                  //           categoryProvider.categoryResponse.result[index].id);
                  // }
                },
                child: Text(
                  dataClass.categoryResponse.result[index].category,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.white),
                ),
              ),
            ),
            Visibility(
              visible: isSelected,
              child: const Positioned(
                top: 0,
                left: 2,
                child: SelectedTick(),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _topSection(BuildContext context, bool isOnBoarded) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Consumer2<CategoryProvider, DailyQuotesProvider>(
          builder: (context, categoryProvider, dailyQuotesProvider, _) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isOnBoarded
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Your Quotes\nCategory',
                          style: textTheme.titleLarge,
                        ),
                      ),
              ],
            ),
            AppSpacing.height10,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'You can also check all categories in your search\noption or from home page itself.',
                style: textTheme.bodySmall,
              ),
            ),
          ],
        );
      }),
    );
  }
}

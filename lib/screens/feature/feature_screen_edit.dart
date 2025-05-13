import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/globals/ad_manager.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/login/login.dart';
import 'package:quotify/screens/quote_edit/quote_edit.dart';
import 'package:quotify/services/screenshot_services.dart';
import 'package:quotify/widgets/circle_button.dart';
import 'package:quotify/widgets/custom_page_route.dart';
import 'package:quotify/widgets/image_container.dart';
import 'package:quotify/widgets/quote_screen_top_bar.dart';
import 'package:screenshot/screenshot.dart';

class FeatureScreenEditArguments {
  final String tagName;
  final String imagePath;
  final String imageAuthor;
  final String quote;
  final int categoryId;
  final bool isFavorite;
  int? editId;
  final dynamic editJson;
  final String quoteEditThumbnail;

  FeatureScreenEditArguments(
      {required this.tagName,
      required this.imagePath,
      required this.imageAuthor,
      required this.quote,
      required this.categoryId,
      this.isFavorite = false,
      this.editId,
      this.editJson = '',
      required this.quoteEditThumbnail});
}

class FeatureScreenEdit extends StatefulWidget {
  const FeatureScreenEdit({super.key});

  @override
  State<FeatureScreenEdit> createState() => _FeatureScreenEditState();
}

class _FeatureScreenEditState extends State<FeatureScreenEdit>
    with SingleTickerProviderStateMixin {
  ScreenshotController screenshotController = ScreenshotController();
  QuoteListingProvider favoritesProvider =
      Provider.of<QuoteListingProvider>(scaffoldKey.currentContext!);
  var adManager = Provider.of<AdManager>(scaffoldKey.currentContext!);
  late bool isFavorite;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInQuad, // smoother than easeIn
      ),
    );

    _controller.forward();
  }

  // Use didChangeDependencies to safely fetch arguments
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access arguments from ModalRoute safely
    final arguments = ModalRoute.of(context)!.settings.arguments
        as FeatureScreenEditArguments;

    // Initialize isFavorite once arguments are available
    isFavorite = arguments.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var arguments = ModalRoute.of(context)?.settings.arguments
        as FeatureScreenEditArguments;
    log(arguments.editId.toString());
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppSpacing.height10,
            QuoteScreenTopBar(),
            AppSpacing.height20,
            Expanded(child: _centerSection(context, arguments, deviceSize))
          ],
        ),
      ),
    );
  }

  Column _centerSection(BuildContext context,
      FeatureScreenEditArguments arguments, Size deviceSize) {
    return Column(
      children: [
        Expanded(
          child: Hero(
            tag: arguments.tagName,
            child: Stack(
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: ImageContainer(
                    height: double.infinity,
                    width: deviceSize.width * 0.88,
                    imgPath: arguments.quoteEditThumbnail,
                    hasOverlay: false,
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: _author(deviceSize, arguments, context),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.height40,
        _bottomSection(context),
        AppSpacing.height40
      ],
    );
  }

  Row _bottomSection(BuildContext context) {
    return Row(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleButton(
          onTap: () async {
            await ScreenshotServices.download(
              context: context,
              screenshotController: screenshotController,
            );
          },
          backgroundColor: AppColors.lightPink,
          diameter: 50,
          child: const Icon(
            Icons.file_download_outlined,
            color: AppColors.darkPink,
          ),
        ),
        CircleButton(
          onTap: () async {
            await ScreenshotServices.share(
              context: context,
              screenshotController: screenshotController,
            );
          },
          backgroundColor: AppColors.lightGreen,
          diameter: 50,
          child: Icon(
            Icons.adaptive.share,
            color: AppColors.green,
          ),
        ),
      ],
    );
  }

  Widget _author(Size deviceSize, FeatureScreenEditArguments arguments,
      BuildContext context) {
    return Visibility(
      visible: arguments.imageAuthor.isNotEmpty,
      child: FadeTransition(
        opacity: _animation,
        child: SizedBox(
          width: deviceSize.width * 0.88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photo by ${arguments.imageAuthor}',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                'Unsplash',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

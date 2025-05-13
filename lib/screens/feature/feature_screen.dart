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
import 'package:quotify/widgets/custom_editor/story_maker.dart';
import 'package:quotify/widgets/custom_page_route.dart';
import 'package:quotify/widgets/image_container.dart';
import 'package:quotify/widgets/quote_screen_top_bar.dart';
import 'package:screenshot/screenshot.dart';

class FeatureScreenArguments {
  final String tagName;
  final String imagePath;
  final String imageAuthor;
  final String quote;
  final int categoryId;
  final bool isFavorite;
  int? editId;

  FeatureScreenArguments({
    required this.tagName,
    required this.imagePath,
    this.imageAuthor = '',
    required this.quote,
    required this.categoryId,
    this.isFavorite = false,
    this.editId,
  });
}

class FeatureScreen extends StatefulWidget {
  const FeatureScreen({super.key});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen>
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
    final arguments =
        ModalRoute.of(context)!.settings.arguments as FeatureScreenArguments;

    // Initialize isFavorite once arguments are available
    isFavorite = arguments.isFavorite;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var arguments =
        ModalRoute.of(context)?.settings.arguments as FeatureScreenArguments;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppSpacing.height10,
            QuoteScreenTopBar(screenshotController: screenshotController),
            AppSpacing.height20,
            Expanded(child: __centerSection(context, arguments, deviceSize)),
          ],
        ),
      ),
    );
  }

  Widget __centerSection(
      BuildContext context, FeatureScreenArguments arguments, Size deviceSize) {
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
                    imgPath: arguments.imagePath,
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Text(
                        arguments.quote,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.white,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
        _bottomSection(context, arguments),
        AppSpacing.height40
      ],
    );
  }

  Widget _bottomSection(
      BuildContext context, FeatureScreenArguments arguments) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleButton(
          onTap: () {
            Navigator.pop(context);
          },
          backgroundColor: AppColors.lightPink,
          diameter: 50,
          child: const Icon(
            Icons.close,
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
        CircleButton(
          onTap: () {
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            if (userProvider.isAuthenticated) {
              if (isFavorite) {
                // favoritesProvider.removeFromFavorite()
                favoritesProvider.removeFromFavorites(
                    quote: arguments.quote,
                    quoteImage: arguments.imagePath,
                    categoryId: arguments.categoryId);
                setState(() {
                  isFavorite = false;
                });
              } else {
                favoritesProvider.addToFavorite(
                    quote: arguments.quote,
                    quoteImage: arguments.imagePath,
                    imageAuthor: arguments.imageAuthor,
                    categoryId: arguments.categoryId);
                setState(() {
                  isFavorite = true;
                });
              }
            } else {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: LoginScreen(
                      arguments: LoginArguments(isOnboarding: false)),
                ),
              );
            }
          },
          backgroundColor: isFavorite
              ? AppColors.darkPink
              : Provider.of<ThemeProvier>(context, listen: false).isDarkMode
                  ? Colors.white
                  : Colors.grey[100],
          diameter: 50,
          child: Icon(Icons.favorite_border,
              color: isFavorite ? AppColors.white : AppColors.darkPink),
        ),
        CircleButton(
          onTap: () async {
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            if (userProvider.isAuthenticated) {
              await _showQuoteEditor(context, arguments);
            } else {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: LoginScreen(
                      arguments: LoginArguments(isOnboarding: false)),
                ),
              );
            }
          },
          backgroundColor:
              Provider.of<ThemeProvier>(context, listen: false).isDarkMode
                  ? Colors.white
                  : Colors.grey[100],
          diameter: 50,
          child: const Icon(
            Icons.edit,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _author(
      Size deviceSize, FeatureScreenArguments arguments, BuildContext context) {
    return Visibility(
      visible: arguments.imageAuthor.isNotEmpty,
      child: FadeTransition(
        opacity: _animation,
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
    );
  }

  Future<void> _showQuoteEditor(
      BuildContext context, FeatureScreenArguments arguments) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unlock Editing'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Check out an ad and tweak it?'),
                Text('It\'ll help us add more free features for everyone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Watch Ad'),
              onPressed: () async {
                await adManager.showAd(context, () async {
                  // Do something when user earns reward
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Editor(
                        arguments: EditorArgumetns(
                          tagName: arguments.tagName,
                          imagePath: arguments.imagePath,
                          imageAuthor: arguments.imageAuthor,
                          quote: arguments.quote,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



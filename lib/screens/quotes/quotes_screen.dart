import 'dart:async';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/config/constants/enums/quote_actions.dart';
import 'package:quotify/config/constants/globals/ad_manager.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/daily_quotes_provider.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/screens/feature/feature_screen.dart';
import 'package:quotify/screens/login/login.dart';
import 'package:quotify/services/screenshot_services.dart';
import 'package:quotify/widgets/circle_button.dart';
import 'package:quotify/widgets/app_bottom_sheet.dart';
import 'package:quotify/widgets/custom_editor/story_maker.dart';
import 'package:quotify/widgets/custom_page_route.dart';
import 'package:quotify/widgets/image_container.dart';
import 'package:quotify/widgets/scroll_handle.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  QuoteActions quoteAction = QuoteActions.none;
  final AppinioSwiperController appinioSwiperController =
      AppinioSwiperController();
  ScreenshotController screenshotController = ScreenshotController();
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  DailyQuotesProvider dailyQuotesProvider =
      Provider.of<DailyQuotesProvider>(scaffoldKey.currentContext!);
  QuoteListingProvider favoritesProvider =
      Provider.of<QuoteListingProvider>(scaffoldKey.currentContext!);
  CategoryProvider categoryProvider =
      Provider.of<CategoryProvider>(scaffoldKey.currentContext!, listen: false);
  final adManager = Provider.of<AdManager>(scaffoldKey.currentContext!);
  bool isFavorite = false;
  bool isFavoriteActionLoading = false;

  final GlobalKey _topSectionKey = GlobalKey();

  double _cardHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _calculateCardHeight();
      final sp = await preferences;
      var selectedCategory = dailyQuotesProvider.selectedCategory;
      if (selectedCategory['category'] == 'Category') {
        selectedCategory = {
          'id': categoryProvider.categoryResponse.result[0].id,
          'category': categoryProvider.categoryResponse.result[0].category
        };
      }

      dailyQuotesProvider.fetchCategoryQuotes(category: selectedCategory);
      Timer(const Duration(milliseconds: 100), () {
        init(context, sp);
        // MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        //     testDeviceIds: ['34348A1B503DE537655E22EC6E3C2AD5']));
        // loadAd();
      });

      // final ModalRoute? modalRoute = ModalRoute.of(context);
      // if (modalRoute is PageRoute<dynamic>) {
      //   routeObserver.subscribe(this, modalRoute);
      // }
    });
  }

  void _calculateCardHeight() {
    final context = scaffoldKey.currentContext;
    if (context == null) return;

    final mediaQuery = MediaQuery.of(context);

    // Safe area insets
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    // Widget height
    final topBox =
        _topSectionKey.currentContext?.findRenderObject() as RenderBox?;
    final topHeight = topBox?.size.height ?? 0;

    final screenHeight = mediaQuery.size.height;
    final bottomNavBarHeight = kBottomNavigationBarHeight;

    setState(() {
      _cardHeight = screenHeight -
          topHeight -
          bottomNavBarHeight -
          topPadding -
          bottomPadding -
          30;
    });
  }

  init(BuildContext context, SharedPreferences sp) async {
    bool? isGuided = sp.getBool(SP.isUserGuided);
    if (isGuided == null || isGuided == false) {
      showUserGuide(context);
    }
  }

  addToFavorite(String quote, String quoteImage, String imageAuthor,
      int categoryId) async {
    Response? response = await favoritesProvider.addToFavorite(
        quote: quote,
        quoteImage: quoteImage,
        imageAuthor: imageAuthor,
        categoryId: categoryId);
    print(response);
  }

  // Called when coming back to this screen
  // @override
  // void didPopNext() {
  //   print('${_cardHeight} ===========didPopNext============');
  //   _calculateCardHeight(); // Recalculate height on return
  //   ModalRoute<dynamic>? previousRoute = ModalRoute.of(context);
  //   String? previousRouteName = previousRoute?.settings.name;
  //   print("Previous Route: $previousRouteName");
  //   super.didPopNext();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final route = ModalRoute.of(context);
  //   if (route is PageRoute) {
  //     routeObserver.subscribe(this, route);
  //   }
  // }

  @override
  void dispose() {
    appinioSwiperController.dispose();
    isFavorite = false;
    // routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> _refreshPage() async {
    dailyQuotesProvider.fetchCategoryQuotes(
        category: dailyQuotesProvider.selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _topSection(context),
                _centerSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        key: _topSectionKey,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE').format(DateTime.now()),
                    style: textTheme.titleLarge?.copyWith(
                        fontSize: 18), // Dynamically gets the current day
                  ),
                  // AppSpacing.height10,
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -18,
                        right: -20,
                        child: SvgPicture.asset(
                          'assets/images/quote_screen_title_bg.svg',
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: textTheme.titleLarge,
                          children: [
                            TextSpan(
                                text:
                                    'Quotes for' // Dynamically gets the current day
                                ),
                            const TextSpan(text: '   '),
                            TextSpan(
                              text: 'you',
                              style: GoogleFonts.fuzzyBubbles(
                                fontSize: 26,
                                color: AppColors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.height5,
                  // Text(
                  //   'You can find Quotes as daily basis on your selected categories, you can customize the categories in below settings menu.',
                  //   style: textTheme.bodySmall,
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              ),
              TextButton(
                style:
                    TextButton.styleFrom(backgroundColor: AppColors.lightPink),
                onPressed: () {
                  showAppBottomShee(context);
                },
                child: Consumer<DailyQuotesProvider>(
                    builder: (context, quoteProvider, _) {
                  return Row(
                    children: [
                      Text(
                        quoteProvider.selectedCategory['category'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.black,
                      )
                    ],
                  );
                }),
              )
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _centerSection(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        ListenableBuilder(
            listenable: appinioSwiperController,
            builder: (context, child) {
              final SwiperPosition? position = appinioSwiperController.position;

              // Get the swipe progress and clamp it to the range of -1 to 1
              final double progress = (position != null)
                  ? position.progressRelativeToThreshold.clamp(-1, 1)
                  : 0;

              return Column(
                children: [
                  Consumer<DailyQuotesProvider>(
                    builder: (context, dataClass, _) {
                      switch (dataClass.categoryQuoteResStatus) {
                        case ApiStatus.error:
                          return const SizedBox(
                            child: Text('Error'),
                          );
                        case ApiStatus.isLoading:
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: deviceSize.width * 0.88,
                              height: _cardHeight,
                              child: SvgPicture.asset(
                                'assets/images/placeholder.svg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        case ApiStatus.isLoaded:
                          return dataClass.allQuotes.isEmpty
                              ? SizedBox(
                                  width: deviceSize.width * 0.88,
                                  height: _cardHeight,
                                  child: Center(
                                    child: Text(
                                      'Empty results!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.purple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: deviceSize.width * 0.88,
                                  height: _cardHeight,
                                  child: AppinioSwiper(
                                    invertAngleOnBottomDrag: false,
                                    backgroundCardCount: 1,
                                    loop: true,
                                    controller: appinioSwiperController,
                                    swipeOptions: SwipeOptions.symmetric(
                                        horizontal: true),
                                    // onSwipeCancelled: (activity) => log(activity.toString()),
                                    onSwipeEnd: (int previousIndex,
                                        int targetIndex,
                                        SwiperActivity activity) {
                                      setState(() {
                                        isFavorite = false;
                                      });
                                      if (activity.end!.dx > 0) {
                                        addToFavorite(
                                            dataClass.allQuotes[previousIndex]
                                                .quote.quote,
                                            dataClass.allQuotes[previousIndex]
                                                .image.path,
                                            dataClass.allQuotes[previousIndex]
                                                .quote.author.author,
                                            dataClass.allQuotes[previousIndex]
                                                .quote.categoryId);
                                      }
                                    },
                                    cardCount: dataClass.allQuotes.length,
                                    cardBuilder: (context, index) {
                                      // log("${appinioSwiperController.cardIndex} $index");
                                      return Hero(
                                        tag: 'feature$index',
                                        child: Column(
                                          children: [
                                            if (index ==
                                                appinioSwiperController
                                                    .cardIndex)
                                              Screenshot(
                                                controller:
                                                    screenshotController,
                                                child: Stack(
                                                  children: [
                                                    ImageContainer(
                                                      width: deviceSize.width *
                                                          0.88,
                                                      height: _cardHeight - 10,
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          'feature',
                                                          arguments: FeatureScreenArguments(
                                                              tagName:
                                                                  'feature$index',
                                                              imagePath:
                                                                  dataClass
                                                                      .allQuotes[
                                                                          index]
                                                                      .image
                                                                      .path,
                                                              imageAuthor:
                                                                  dataClass
                                                                      .allQuotes[
                                                                          index]
                                                                      .image
                                                                      .author
                                                                      .author,
                                                              quote: dataClass
                                                                  .allQuotes[
                                                                      index]
                                                                  .quote
                                                                  .quote,
                                                              categoryId: dataClass
                                                                  .allQuotes[
                                                                      index]
                                                                  .quote
                                                                  .categoryId,
                                                              isFavorite:
                                                                  isFavorite),
                                                        );
                                                      },
                                                      imgPath: dataClass
                                                          .allQuotes[index]
                                                          .image
                                                          .path,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 50),
                                                        child: Text(
                                                          dataClass
                                                              .allQuotes[index]
                                                              .quote
                                                              .quote,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleLarge
                                                              ?.copyWith(
                                                                  color: AppColors
                                                                      .white),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 6,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    if (position != null &&
                                                        progress < -0.1 &&
                                                        (position.offset
                                                                .toAxisDirection() ==
                                                            (AxisDirection
                                                                .left)) &&
                                                        (appinioSwiperController
                                                                .cardIndex ==
                                                            index))
                                                      Positioned(
                                                        top: 30,
                                                        right: 30,
                                                        child: _stamp(
                                                          Colors.red,
                                                          'REMOVE',
                                                        ),
                                                      ),

                                                    // // Show widget when swiping to the right
                                                    if (position != null &&
                                                        progress > 0.1 &&
                                                        position.offset
                                                                .toAxisDirection() ==
                                                            AxisDirection
                                                                .right &&
                                                        (appinioSwiperController
                                                                .cardIndex ==
                                                            index))
                                                      Positioned(
                                                        top: 30,
                                                        left: 30,
                                                        child: _stamp(
                                                          AppColors.green,
                                                          'LIKE',
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              )
                                            else if (appinioSwiperController
                                                        .cardIndex ==
                                                    null &&
                                                index == 0)
                                              Screenshot(
                                                controller:
                                                    screenshotController,
                                                child: Stack(
                                                  children: [
                                                    ImageContainer(
                                                      width: deviceSize.width *
                                                          0.88,
                                                      height: _cardHeight - 10,
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          'feature',
                                                          arguments:
                                                              FeatureScreenArguments(
                                                            tagName:
                                                                'feature$index',
                                                            imagePath: dataClass
                                                                .allQuotes[
                                                                    index]
                                                                .image
                                                                .path,
                                                            imageAuthor:
                                                                dataClass
                                                                    .allQuotes[
                                                                        index]
                                                                    .image
                                                                    .author
                                                                    .author,
                                                            quote: dataClass
                                                                .allQuotes[
                                                                    index]
                                                                .quote
                                                                .quote,
                                                            categoryId:
                                                                dataClass
                                                                    .allQuotes[
                                                                        index]
                                                                    .quote
                                                                    .categoryId,
                                                            isFavorite:
                                                                isFavorite,
                                                          ),
                                                        );
                                                      },
                                                      imgPath: dataClass
                                                          .allQuotes[index]
                                                          .image
                                                          .path,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 50,
                                                        ),
                                                        child: Text(
                                                          dataClass
                                                              .allQuotes[index]
                                                              .quote
                                                              .quote,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleLarge
                                                              ?.copyWith(
                                                                  color: AppColors
                                                                      .white),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 6,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    if (position != null &&
                                                        progress < -0.2 &&
                                                        (position.offset
                                                                .toAxisDirection() ==
                                                            (AxisDirection
                                                                .left)) &&
                                                        (appinioSwiperController
                                                                .cardIndex ==
                                                            index))
                                                      Positioned(
                                                        top: 30,
                                                        right: 30,
                                                        child: _stamp(
                                                          Colors.red,
                                                          'REMOVE',
                                                        ),
                                                      ),

                                                    // // Show widget when swiping to the right
                                                    if (position != null &&
                                                        progress > 0.2 &&
                                                        position.offset
                                                                .toAxisDirection() ==
                                                            AxisDirection
                                                                .right &&
                                                        (appinioSwiperController
                                                                .cardIndex ==
                                                            index))
                                                      Positioned(
                                                        top: 30,
                                                        left: 30,
                                                        child: _stamp(
                                                          AppColors.green,
                                                          'LIKE',
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              )
                                            else
                                              ImageContainer(
                                                width: deviceSize.width * 0.88,
                                                height: _cardHeight,
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    'feature',
                                                    arguments:
                                                        FeatureScreenArguments(
                                                            tagName:
                                                                'feature$index',
                                                            imagePath: dataClass
                                                                .allQuotes[
                                                                    index]
                                                                .image
                                                                .path,
                                                            imageAuthor:
                                                                dataClass
                                                                    .allQuotes[
                                                                        index]
                                                                    .image
                                                                    .author
                                                                    .author,
                                                            quote: dataClass
                                                                .allQuotes[
                                                                    index]
                                                                .quote
                                                                .quote,
                                                            categoryId:
                                                                dataClass
                                                                    .allQuotes[
                                                                        index]
                                                                    .quote
                                                                    .categoryId,
                                                            isFavorite:
                                                                isFavorite),
                                                  );
                                                },
                                                imgPath: dataClass
                                                    .allQuotes[index]
                                                    .image
                                                    .path,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 50,
                                                  ),
                                                  child: Text(
                                                    dataClass.allQuotes[index]
                                                        .quote.quote,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                            color: AppColors
                                                                .white),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 6,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                        default:
                          return const SizedBox(
                            child: Text('Default'),
                          );
                      }
                    },
                  ),
                  AppSpacing.height20,
                ],
              );
            }),
        Positioned(bottom: 60, child: _bottomSection(context)),
      ],
    );
  }

  Widget _bottomSection(BuildContext context) {
    return Consumer<DailyQuotesProvider>(builder: (context, dataClass, _) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.86,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleButton(
              onTap: () {
                appinioSwiperController.swipeLeft();
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
              onTap: () async {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.isAuthenticated) {
                  if (isFavorite) {
                    // favoritesProvider.removeFromFavorite()
                    favoritesProvider.removeFromFavorites(
                        quote: dataClass
                            .allQuotes[appinioSwiperController.cardIndex ?? 0]
                            .quote
                            .quote,
                        quoteImage: dataClass
                            .allQuotes[appinioSwiperController.cardIndex ?? 0]
                            .image
                            .path,
                        categoryId: dataClass
                            .allQuotes[appinioSwiperController.cardIndex ?? 0]
                            .quote
                            .categoryId);
                    setState(() {
                      isFavorite = false;
                    });
                  } else {
                    setState(() {
                      isFavorite = true;
                    });
                    appinioSwiperController.swipeRight();
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
              child: Icon(
                Icons.favorite_border,
                color: isFavorite ? AppColors.white : AppColors.darkPink,
              ),
            ),
            CircleButton(
              onTap: () async {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.isAuthenticated) {
                  await _showQuoteEditor(dataClass);
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
        ),
      );
    });
  }

  Future<void> _showQuoteEditor(DailyQuotesProvider dataClass) async {
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
                await adManager.showAd(context, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Editor(
                        arguments: EditorArgumetns(
                          tagName: 'index_${appinioSwiperController.cardIndex}',
                          imagePath: dataClass
                              .allQuotes[appinioSwiperController.cardIndex ?? 0]
                              .image
                              .path,
                          imageAuthor: dataClass
                              .allQuotes[appinioSwiperController.cardIndex ?? 0]
                              .image
                              .author
                              .author,
                          quote: dataClass
                              .allQuotes[appinioSwiperController.cardIndex ?? 0]
                              .quote
                              .quote,
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

  Widget _stamp(Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
      ),
    );
  }

  showAppBottomShee(BuildContext context) {
    AppBottomSheet.showBottomSheet(
      context: context,
      isScrollControlled: true,
      body: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Stack(
                children: [
                  const ScrollHandle(),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      child: Consumer2<CategoryProvider, DailyQuotesProvider>(
                          builder:
                              (context, categoryProvider, quotesProvider, _) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Categories',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GridView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: categoryProvider
                                    .categoryResponse.result.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        crossAxisCount: 2,
                                        childAspectRatio: 5 / 2),
                                itemBuilder: (context, index) {
                                  return ImageContainer(
                                    onTap: () {
                                      var selectedCategory = {
                                        'id': categoryProvider
                                            .categoryResponse.result[index].id,
                                        'category': categoryProvider
                                            .categoryResponse
                                            .result[index]
                                            .category
                                      };
                                      quotesProvider.selectedCategory =
                                          selectedCategory;
                                      quotesProvider.fetchCategoryQuotes(
                                          category: selectedCategory);
                                      Navigator.pop(context);
                                    },
                                    imgPath: categoryProvider.categoryResponse
                                        .result[index].categoryImage,
                                    child: Text(
                                      categoryProvider.categoryResponse
                                          .result[index].category,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showUserGuide(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) => Material(
        color: AppColors.black.withOpacity(0.4),
        child: InkWell(
          onTap: () async {
            Navigator.pop(context);
            final sp = await preferences;
            sp.setBool(SP.isUserGuided, true);
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/swipe_right.svg'),
                              _guideText('Swipe left\nto Remove')
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/swipe_left.svg'),
                              _guideText('Swipe right\nto favorite')
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: deviceSize.height * 0.0325,
                  child: _buttonGuide(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonGuide(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.width - 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              _guideButtonIcon(
                icon: Icons.close,
                color: AppColors.darkPink,
                backgroundColor: AppColors.lightPink,
              ),
              _guideText('Tap to\nremove'),
            ],
          ),
          Column(
            children: [
              _guideButtonIcon(
                icon: Icons.adaptive.share,
                color: AppColors.green,
                backgroundColor: AppColors.lightGreen,
              ),
              _guideText('Tap to\nshare'),
            ],
          ),
          Column(
            children: [
              _guideButtonIcon(
                icon: Icons.favorite_border,
                color: AppColors.lightPink,
                backgroundColor: AppColors.darkPink,
              ),
              _guideText('Tap to\nfavorite'),
            ],
          ),
        ],
      ),
    );
  }

  CircleButton _guideButtonIcon(
      {required IconData icon,
      required Color color,
      required Color backgroundColor}) {
    return CircleButton(
      backgroundColor: backgroundColor,
      diameter: 50,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _guideText(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/globals/route_observer.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/helpers/helpers.dart';
import 'package:quotify/models/user_profile_res_model.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/daily_quotes_provider.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/feature/feature_screen.dart';
import 'package:quotify/screens/home/widgets/category_quotes_listing_loading_indicator.dart';
import 'package:quotify/screens/quotes/quote_listing_screen.dart';
import 'package:quotify/widgets/custom_page_route.dart';
import 'package:quotify/widgets/image_container.dart';
import 'package:quotify/widgets/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  DailyQuotesProvider dailyQuotesProvider = Provider.of<DailyQuotesProvider>(
      scaffoldKey.currentContext!,
      listen: false);
  CategoryProvider categoryProvider =
      Provider.of<CategoryProvider>(scaffoldKey.currentContext!, listen: false);
  QuoteListingProvider quoteListingProvider = Provider.of<QuoteListingProvider>(
      scaffoldKey.currentContext!,
      listen: false);

  ScrollController scrollController = ScrollController();
  Connectivity connectivity = Connectivity();
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      streamSubscription =
          connectivity.onConnectivityChanged.listen((connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          Helpers().checkConnectivity(context);
        } else {
          Helpers().checkConnectivity(context);
        }
      });
      final ModalRoute? modalRoute = ModalRoute.of(context);
      if (modalRoute is PageRoute<dynamic>) {
        routeObserver.subscribe(this, modalRoute);
      }
      Future.delayed(Duration.zero, () {
        connectivity.checkConnectivity().then((connectivityResult) {
          if (connectivityResult != ConnectivityResult.none) {
            checkConnection();
          }
        });
      });
    });
    // checkConnection();
    super.initState();
  }

  checkConnection() async {
    var connectionResult = await Helpers().checkConnectivity(context);
    if (connectionResult) {
      // if (categoryProvider.apiStatus != ApiStatus.isLoaded) {
      // await fetchCategory();
      // }
      // if (dailyQuotesProvider.dailyQuoteResStatus != ApiStatus.isLoaded) {
      await fetchQuotes();
      // }
    }
  }

  // fetchCategory() async {
  //   if (categoryProvider.apiStatus != ApiStatus.isLoaded) {
  //     await categoryProvider.fetchCategories();
  //   }
  // }

  fetchQuotes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userSelectedCategories =
        preferences.getStringList(SP.userSelectedCategories);
    log('${userSelectedCategories.toString()} userselected categories');
    if (userSelectedCategories != null && userSelectedCategories.isNotEmpty) {
      await dailyQuotesProvider.fetchQuotes(
          userSelectedCategories: userSelectedCategories);
    } else {
      userSelectedCategories = categoryProvider.defaultCategories;
      await dailyQuotesProvider.fetchQuotes(
          userSelectedCategories: userSelectedCategories);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    ModalRoute<dynamic>? previousRoute = ModalRoute.of(context);
    String? previousRouteName = previousRoute?.settings.name;
    log("Previous Route: $previousRouteName");
    // fetchQuotes();
    super.didPopNext();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> _refreshPage() async {
    await fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _customAppBar(context),
                _categorySection(context),
                const SizedBox(height: 20,),
                _quotesSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quotesSection(BuildContext context) {
    return Consumer<DailyQuotesProvider>(builder: (context, data, _) {
      // print(data.quotesData.length);
      switch (data.dailyQuoteResStatus) {
        case ApiStatus.none:
          return const SizedBox();
        case ApiStatus.isLoading:
          return const QuoteListingLoadingIndicator();
        case ApiStatus.isLoaded:
          return ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: data.quotesData.length,
            itemBuilder: (context, index) {
              if (data.quotesData[index].categoryItems.isEmpty) {
                return const SizedBox();
              }
              return _quotesSlider(
                context: context,
                itemIndex: index,
                categoryName: data.quotesData[index].categoryName,
                data: data,
              );
            },
            separatorBuilder: (context, index) => AppSpacing.height20,
          );

        default:
          return const SizedBox();
      }
    });
  }

  Widget _quotesSlider(
      {required BuildContext context,
      required int itemIndex,
      required String categoryName,
      required DailyQuotesProvider data}) {
    final deviceSize = MediaQuery.of(context).size;
    final textTeme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$categoryName Quotes',
                style: textTeme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  quoteListingProvider.initializeData();
                  quoteListingProvider.categoryItem = dailyQuotesProvider
                      .quotesData[itemIndex].categoryItems
                      .toList();
                  quoteListingProvider.newCategoryItem = dailyQuotesProvider
                      .quotesData[itemIndex].categoryItems
                      .toList();

                  Navigator.push(
                    context,
                    CustomPageRoute(
                      child: QuoteListingScreen(
                        itemIndex: itemIndex,
                        isDefaultCategory: false,
                      ),
                      settings: RouteSettings(
                        arguments: QuoteListingScreenArguments(
                          categoryName: categoryName,
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('See all'),
              )
            ],
          ),
        ),
        SizedBox(
          height: deviceSize.height * 0.4, // Adjust height as needed
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2, // Adjust based on your design
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.quotesData[itemIndex].categoryItems.length >= 4
                ? 4
                : data.quotesData[itemIndex].categoryItems.length,
            itemBuilder: (context, index) {
              bool isLastItem = index == 3 &&
                  data.quotesData[itemIndex].categoryItems.length >= 4;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: '$categoryName$index',
                  child: isLastItem
                      ? SizedBox(
                          width: deviceSize.width / 2,
                          height: 100,
                          child: ImageContainer(
                            onTap: () {
                              quoteListingProvider.initializeData();
                              quoteListingProvider.categoryItem =
                                  dailyQuotesProvider
                                      .quotesData[itemIndex].categoryItems
                                      .toList();
                              quoteListingProvider.newCategoryItem =
                                  dailyQuotesProvider
                                      .quotesData[itemIndex].categoryItems
                                      .toList();

                              Navigator.push(
                                context,
                                CustomPageRoute(
                                  child: QuoteListingScreen(
                                    itemIndex: itemIndex,
                                    isDefaultCategory: false,
                                  ),
                                  settings: RouteSettings(
                                    arguments: QuoteListingScreenArguments(
                                      categoryName: categoryName,
                                    ),
                                  ),
                                ),
                              );
                            },
                            imgPath: data.quotesData[itemIndex].categoryItems[5]
                                .image.path,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 40,
                                  color: AppColors.white,
                                ),
                                Text(
                                  'See all',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.white,
                                      ),
                                )
                              ],
                            ),
                          ),
                        )
                      : ImageContainer(
                          width: double.infinity,
                          height: double.infinity,
                          onTap: () async {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.feature,
                              arguments: FeatureScreenArguments(
                                tagName: '$categoryName$index',
                                imagePath: data.quotesData[itemIndex]
                                    .categoryItems[index].image.path,
                                imageAuthor: data.quotesData[itemIndex]
                                    .categoryItems[index].image.author.author,
                                quote: data.quotesData[itemIndex]
                                    .categoryItems[index].quote.quote,
                                categoryId: data.quotesData[itemIndex]
                                    .categoryItems[index].quote.categoryId,
                              ),
                            );
                          },
                          imgPath: data.quotesData[itemIndex]
                              .categoryItems[index].image.path,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.quotesData[itemIndex].categoryItems[index]
                                  .quote.quote,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // SizedBox(
  //         height: deviceSize.height * 0.2,
  //         child: ListView.separated(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: data.quotesData[itemIndex].categoryItems.length >= 6
  //               ? 6
  //               : data.quotesData[itemIndex].categoryItems.length,
  //           itemBuilder: (context, index) {
  //             return Padding(
  //               padding: EdgeInsets.only(
  //                 left: index == 0 ? 18 : 10,
  //                 top: 10,
  //                 right: data.quotesData[itemIndex].categoryItems.length >= 6 &&
  //                         index == 5
  //                     ? 18
  //                     : index ==
  //                             data.quotesData[itemIndex].categoryItems.length -
  //                                 1
  //                         ? 18
  //                         : 0,
  //               ),
  //               child: (data.quotesData[itemIndex].categoryItems.length >= 6 &&
  //                       index == 5)
  //                   ? Hero(
  //                       tag: '$categoryName$index',
  //                       child: SizedBox(
  //                         width: deviceSize.width / 2,
  //                         height: 100,
  //                         child: ImageContainer(
  //                           onTap: () {
  //                             quoteListingProvider.initializeData();
  //                             quoteListingProvider.categoryItem =
  //                                 dailyQuotesProvider
  //                                     .quotesData[itemIndex].categoryItems
  //                                     .toList();
  //                             quoteListingProvider.newCategoryItem =
  //                                 dailyQuotesProvider
  //                                     .quotesData[itemIndex].categoryItems
  //                                     .toList();

  //                             Navigator.push(
  //                               context,
  //                               CustomPageRoute(
  //                                 child: QuoteListingScreen(
  //                                   itemIndex: itemIndex,
  //                                   isDefaultCategory: false,
  //                                 ),
  //                                 settings: RouteSettings(
  //                                   arguments: QuoteListingScreenArguments(
  //                                     categoryName: categoryName,
  //                                   ),
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                           imgPath: data.quotesData[itemIndex].categoryItems[5]
  //                               .image.path,
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               const Icon(
  //                                 Icons.add,
  //                                 size: 40,
  //                                 color: AppColors.white,
  //                               ),
  //                               Text(
  //                                 'See all',
  //                                 style: Theme.of(context)
  //                                     .textTheme
  //                                     .bodyMedium
  //                                     ?.copyWith(
  //                                       color: AppColors.white,
  //                                     ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   : Hero(
  //                       tag: '$categoryName$index',
  //                       child: ImageContainer(
  //                         width: deviceSize.width / 2,
  //                         height: 100,
  //                         onTap: () {
  //                           Navigator.pushNamed(
  //                             context,
  //                             AppRoutes.feature,
  //                             arguments: FeatureScreenArguments(
  //                               tagName: '$categoryName$index',
  //                               imagePath: data.quotesData[itemIndex]
  //                                   .categoryItems[index].image.path,
  //                               quote: data.quotesData[itemIndex]
  //                                   .categoryItems[index].quote.quote,
  //                               categoryId: data.quotesData[itemIndex]
  //                                   .categoryItems[index].quote.categoryId,
  //                             ),
  //                           );
  //                         },
  //                         imgPath: data.quotesData[itemIndex]
  //                             .categoryItems[index].image.path,
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Text(
  //                             data.quotesData[itemIndex].categoryItems[index]
  //                                 .quote.quote,
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .bodyMedium
  //                                 ?.copyWith(
  //                                   color: AppColors.white,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                             textAlign: TextAlign.center,
  //                             maxLines: 6,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //             );
  //           },
  //           separatorBuilder: (context, index) => AppSpacing.width10,
  //         ),
  //       )

  Widget _quoteGrid(
      {required BuildContext context,
      required int itemIndex,
      required String categoryName,
      required DailyQuotesProvider data}) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
        ),
        itemBuilder: (context, index) {
          return Text('hi');
        });
  }

  Widget _categorySection(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    final textTeme = Theme.of(context).textTheme;
    return Consumer<CategoryProvider>(
      builder: (context, dataClass, _) {
        if (dataClass.apiStatus == ApiStatus.none ||
            dataClass.apiStatus == ApiStatus.isNull) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: textTeme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.category);
                    },
                    child: const Text('Show more'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: dataClass.apiStatus == ApiStatus.isLoading
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                          right: index ==
                                  dataClass.categoryResponse.result.length - 1
                              ? 18
                              : 0,
                          left: index == 0 ? 18 : 10,
                        ),
                        child: Shimmer(width: deviceSize.width * 0.4),
                      ),
                      separatorBuilder: (context, index) => AppSpacing.width5,
                    )
                  : ListView.separated(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: dataClass.categoryResponse.result.length >= 5
                          ? 5
                          : dataClass.categoryResponse.result.length,
                      itemBuilder: (context, index) {
                        final categoryLength =
                            dataClass.categoryResponse.result.length;
                        if (categoryLength >= 5 && index == 4) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index ==
                                      dataClass.categoryResponse.result.length -
                                          1
                                  ? 18
                                  : 0,
                              left: index == 0 ? 18 : 10,
                            ),
                            child: ImageContainer(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.category);
                              },
                              width: deviceSize.width * 0.4,
                              imgPath: dataClass
                                  .categoryResponse.result[index].categoryImage,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    size: 40,
                                    color: AppColors.white,
                                  ),
                                  Text(
                                    'See all',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.white,
                                        ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index ==
                                      dataClass.categoryResponse.result.length -
                                          1
                                  ? 18
                                  : 0,
                              left: index == 0 ? 18 : 10,
                            ),
                            child: ImageContainer(
                              onTap: () {
                                quoteListingProvider.moreQuoteResStatus =
                                    ApiStatus.isLoading;
                                var categoryName = dataClass
                                    .categoryResponse.result[index].category;
                                quoteListingProvider.initializeData();
                                Navigator.push(
                                  context,
                                  CustomPageRoute(
                                    child: QuoteListingScreen(
                                      itemIndex: index,
                                      isDefaultCategory: false,
                                    ),
                                    settings: RouteSettings(
                                      arguments: QuoteListingScreenArguments(
                                        categoryName: categoryName,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              width: deviceSize.width * 0.4,
                              imgPath: dataClass
                                  .categoryResponse.result[index].categoryImage,
                              child: Text(
                                dataClass
                                    .categoryResponse.result[index].category,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                              ),
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) => AppSpacing.width5,
                    ),
            )
          ],
        );
      },
    );
  }

  Widget _customAppBar(BuildContext context) {
    final textTeme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvier>(context, listen: false);
    return Consumer<UserProvider>(builder: (context, userProfileData, _) {
      ProfileResModel? userProfile = userProfileData.userProfile;
      log(userProfileData.userProfile?.firstName.toString() ?? '');

      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: textTeme.bodyMedium,
                ),
                userProfile?.firstName == null
                    ? Text(
                        'Buddy!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.purple,
                            ),
                      )
                    : Text(
                        '${userProfile?.firstName} ${userProfile?.lastName ?? ''}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.purple,
                            ),
                      ),
              ],
            ),
            IconButton(
              icon: SvgPicture.asset(
                themeProvider.isDarkMode
                    ? 'assets/images/profile_settings_dark.svg'
                    : 'assets/images/profile_settings.svg',
                width: 22,
              ),
              onPressed: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.settings);
                if(result == null){
                  fetchQuotes();
                }
              },
            ),
            // Hero(
            //   tag: 'profile_image',
            //   child: CircleButton(
            //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //     diameter: 40,
            //     onTap: () {
            //       Navigator.pushNamed(context, AppRoutes.profile);
            //     },
            //     child: Image.asset(
            //       'assets/images/category_img3.png',
            //       fit: BoxFit.cover,
            //       width: 40,
            //       height: 40,
            //     ),
            //   ),
            // )
          ],
        ),
      );
    });
  }
}

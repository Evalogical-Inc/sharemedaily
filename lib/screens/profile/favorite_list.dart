import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/custom_icons.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/globals/route_observer.dart';
import 'package:quotify/helpers/helpers.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/category/cartegory_screen.dart';
import 'package:quotify/screens/feature/feature_screen.dart';
import 'package:quotify/screens/home/home_screen.dart';
import 'package:quotify/screens/landing/landing_screen.dart';
import 'package:quotify/screens/onboard/onboard_select_category_screen.dart';
import 'package:quotify/screens/quotes/widgets/quote_listing_shimmer.dart';
import 'package:quotify/widgets/image_container.dart';
import 'package:quotify/widgets/shimmer.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({super.key});

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> with RouteAware {
  final ScrollController _scrollController = ScrollController();
  Connectivity connectivity = Connectivity();
  late StreamSubscription streamSubscription;

  QuoteListingProvider quoteListingProvider = Provider.of<QuoteListingProvider>(
      scaffoldKey.currentContext!,
      listen: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print('heeloe');
      streamSubscription =
          connectivity.onConnectivityChanged.listen((connectivityResult) async {
        if (connectivityResult != ConnectivityResult.none) {
          // fetchInitialData();
        }
      });
      final ModalRoute? modalRoute = ModalRoute.of(context);
      if (modalRoute is PageRoute<dynamic>) {
        routeObserver.subscribe(this, modalRoute);
      }
      fetchInitialData();
      _scrollController.addListener(_onScroll);
    });
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      // Trigger API call for loading more data
      Provider.of<QuoteListingProvider>(context, listen: false)
          .loadMoreFavorites();
    }
  }

  fetchInitialData() async {
    var connectionResult = await Helpers().checkConnectivity(context);
    if (connectionResult) {
      print('inside');
      await quoteListingProvider.fetchFavorites();
    }
  }

   @override
  void didPopNext() {
    fetchInitialData();
    super.didPopNext();
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
  void dispose() {
    streamSubscription.cancel();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> _refreshFavorites() async {
    await quoteListingProvider.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<QuoteListingProvider, ThemeProvier>(
      builder: (context, dataClass, themeProvider, _) {
        switch (dataClass.favoritesStatus) {
          case ApiStatus.none:
            return const SizedBox();
          case ApiStatus.isLoading:
            return const Center(child: CircularProgressIndicator());
          case ApiStatus.isLoaded:
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (true &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent * 0.9) {
                  // setState(() =>  = true);
                  log('heelo');
                  Provider.of<QuoteListingProvider>(context, listen: false)
                      .loadMoreFavorites();
                  // Future.delayed(const Duration(seconds: 2), () {
                  //   setState(() => isLoading = false);
                  // });
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: _refreshFavorites,
                child: GridView.builder(
                  // controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 1.0, // Aspect ratio of each tile
                  ),
                  padding: const EdgeInsets.all(18),
                  itemCount: dataClass.favoriteResponse.result.length +
                      (dataClass.hasMore ? 2 : 0),
                  itemBuilder: (context, index) {
                    if (((index == dataClass.favoriteResponse.result.length) ||
                            (index ==
                                dataClass.favoriteResponse.result.length +
                                    1)) &&
                        dataClass.hasMore) {
                      // Show a loading indicator at the bottom
                      return Shimmer();
                    }

                    final favoriteItem =
                        dataClass.favoriteResponse.result[index];
                    return Hero(
                      tag:
                          'feature${dataClass.favoriteResponse.result.indexOf(favoriteItem)}',
                      child: ImageContainer(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'feature',
                            arguments: FeatureScreenArguments(
                              tagName:
                                  'feature${dataClass.favoriteResponse.result.indexOf(favoriteItem)}',
                              imagePath: favoriteItem.quoteImage,
                              imageAuthor: favoriteItem.imageAuthor,
                              quote: favoriteItem.quote,
                              categoryId: favoriteItem.categoryId,
                              isFavorite: true,
                            ),
                          );
                        },
                        imgPath: favoriteItem.quoteImage,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            favoriteItem.quote,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.white,
                                  fontSize: 14,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          default:
            return RefreshIndicator(
              onRefresh: _refreshFavorites,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Image.asset(
                              themeProvider.isDarkMode
                                  ? 'assets/images/favorites_empty_dark.png'
                                  : 'assets/images/favorites_empty_light.png',
                              width: MediaQuery.sizeOf(context).width / 2,
                            ),
                          ),
                          // AssetImage(themeProvider.isDarkMode
                          //     ? CustomIcons.favoritesEmptyDark
                          //     : CustomIcons.favoritesEmptyLight),
                          const Text("You have'nt added any quotes to favorites!",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, top: 20), // Adjust spacing
                            child: ElevatedButton(
                              onPressed: () {
                                // Call delete confirmation
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryScreen()) // Removes all previous routes
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.defaultPink, // Button color
                                foregroundColor: Colors.black, // Text color
                                fixedSize: const Size(200, 50), // Button size
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30), // Curved border
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text("Explore Quotes",
                                      style: TextStyle(fontSize: 16)),
                                  Spacer(),
                                  Icon(Icons.arrow_forward, color: Colors.black)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }

  Widget _createGridTileWidget(String url) {
    return Builder(
      builder: (context) => GestureDetector(
        // onLongPress: () {
        //   _popupDialog = _createPopupDialog(url);
        //   Overlay.of(context).insert(_popupDialog);
        // },
        // onLongPressEnd: (details) => _popupDialog?.remove(),
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPhotoTitle() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: const ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("https://picsum.photos/200/301"),
          ),
          title: Text(
            'john.doe',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ));
  }

  Widget _createActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.white,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.favorite_border,
            color: Colors.black,
          ),
          Icon(
            Icons.chat_bubble_outline_outlined,
            color: Colors.black,
          ),
          Icon(
            Icons.send,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _createPopupContent(String url) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _createPhotoTitle(),
            Image.network(url, fit: BoxFit.fitWidth),
            _createActionBar(),
          ],
        ),
      ),
    );
  }
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

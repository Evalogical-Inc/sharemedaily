import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/custom_icons.dart';
import 'package:quotify/config/constants/globals/ad_manager.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/globals/route_observer.dart';
import 'package:quotify/helpers/helpers.dart';
import 'package:quotify/provider/editor_provider.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/provider/user_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/category/cartegory_screen.dart';
import 'package:quotify/screens/feature/feature_screen.dart';
import 'package:quotify/screens/feature/feature_screen_edit.dart';
import 'package:quotify/screens/profile/widgets/animated_logo.dart';
import 'package:quotify/screens/quote_edit/quote_edit.dart';
import 'package:quotify/widgets/image_container.dart';
import 'package:quotify/widgets/shimmer.dart';
import 'package:quotify/config/constants/enums/api_status.dart';

class EditList extends StatefulWidget {
  const EditList({super.key});

  @override
  State<EditList> createState() => _EditListState();
}

class _EditListState extends State<EditList> with RouteAware {
  final ScrollController _scrollController = ScrollController();
  Connectivity connectivity = Connectivity();
  late StreamSubscription streamSubscription;
  EditProvider editProvider =
      Provider.of<EditProvider>(scaffoldKey.currentContext!, listen: false);
  var adManager = Provider.of<AdManager>(scaffoldKey.currentContext!);

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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
      log('loadMore');
      Provider.of<EditProvider>(context, listen: false).loadMoreEditQuotes();
    }
  }

  fetchInitialData() async {
    var connectionResult = await Helpers().checkConnectivity(context);
    if (connectionResult) {
      await editProvider.fetchEditQuotes();
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
    log('heeeellllllelel');
    fetchInitialData();
    super.didPopNext();
  }

  @override
  void dispose() {
    print('heelelelelel');
    streamSubscription.cancel();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> _refreshEdits() async {
    await editProvider.fetchEditQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<EditProvider, ThemeProvier>(
        builder: (context, dataClass, themeProvider, _) {
          switch (dataClass.editQuoteStatus) {
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
                    log('heelo');
                    Provider.of<EditProvider>(context, listen: false)
                        .loadMoreEditQuotes();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: _refreshEdits,
                  child: GridView.builder(
                    // controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      childAspectRatio: 1.0, // Aspect ratio of each tile
                    ),
                    padding: const EdgeInsets.all(18),
                    itemCount: dataClass.editQuoteResponse.result.length +
                        (dataClass.hasMore ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (((index ==
                                  dataClass.editQuoteResponse.result.length) ||
                              (index ==
                                  dataClass.editQuoteResponse.result.length +
                                      1)) &&
                          dataClass.hasMore) {
                        // Show a loading indicator at the bottom
                        return const Shimmer();
                      }

                      final editedItem =
                          dataClass.editQuoteResponse.result[index];

                      return ModernCard(
                        imageUrl: editedItem.quoteEditThumbnail,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.featureEdit,
                            arguments: FeatureScreenEditArguments(
                                tagName: 'feature${editedItem.id}',
                                imagePath: editedItem.quoteImage,
                                imageAuthor: editedItem.imageAuthor,
                                quoteEditThumbnail:
                                    editedItem.quoteEditThumbnail,
                                quote: editedItem.quote,
                                editJson: jsonDecode(editedItem.quoteEditJson),
                                categoryId: editedItem.categoryId,
                                editId: editedItem.id),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            default:
              return RefreshIndicator(
                onRefresh: _refreshEdits,
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
                                    ? 'assets/images/edits_empty_dark.png'
                                    : 'assets/images/edits_empty_light.png',
                                width: MediaQuery.sizeOf(context).width / 2,
                              ),
                            ),
                            const Text("You don't have any edits yet!",
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
                                    borderRadius: BorderRadius.circular(
                                        30), // Curved border
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text("Explore Quotes",
                                        style: TextStyle(fontSize: 16)),
                                    Spacer(),
                                    Icon(Icons.arrow_forward,
                                        color: Colors.black)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }

  dynamic convertIntToDouble(dynamic json) {
    if (json is Map<String, dynamic>) {
      return json.map((key, value) => MapEntry(key, convertIntToDouble(value)));
    } else if (json is List) {
      return json
          .map((value) => convertIntToDouble(value))
          .toList(); // Ensure lists are properly converted
    } else if (json is int) {
      return json.toDouble(); // Convert int to double
    }
    return json; // Return as is for other types
  }
}

class ModernCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const ModernCard({
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // elevation: 0,
        clipBehavior: Clip.antiAlias, // Ensures rounded corners apply properly
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Image fully loaded
                  } else {
                    return AnimatedLogo();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/helpers/helpers.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/daily_quotes_provider.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/feature/feature_screen.dart';
import 'package:quotify/screens/quotes/widgets/quote_listing_shimmer.dart';
import 'package:quotify/widgets/image_container.dart';
import 'package:quotify/widgets/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteListingScreenArguments {
  final String categoryName;
  QuoteListingScreenArguments({required this.categoryName});
}

class QuoteListingScreen extends StatefulWidget {
  final int itemIndex;
  final bool isDefaultCategory;
  const QuoteListingScreen({
    super.key,
    this.itemIndex = 0,
    this.isDefaultCategory = true,
  });

  @override
  State<QuoteListingScreen> createState() => _QuoteListingScreenState();
}

class _QuoteListingScreenState extends State<QuoteListingScreen> {
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
  // late StreamSubscription streamSubscription;

  int pageNumber = 1;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        
      fetchInitialData();

      scrollController.addListener(() async {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          var connectionResult = await Helpers().checkConnectivity(context);
          if (connectionResult) fetchMoreQuotes();
        }
      });
      if (quoteListingProvider.categoryItem.isEmpty) {
        // fetchInitialData();
      }
    });
    super.initState();
  }

  fetchInitialData() async {
    var connectionResult = await Helpers().checkConnectivity(context);
    if (connectionResult) {
      await quoteListingProvider.fetchInitialQuotes(
          category: categoryProvider.defaultCategories[widget.itemIndex],
          pageNumber: pageNumber);
    }
  }

  fetchMoreQuotes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var categories = preferences.getStringList(SP.userSelectedCategories);

    pageNumber++;
    if (categories != null &&
        categories.isNotEmpty &&
        !widget.isDefaultCategory) {
      await quoteListingProvider.fetchMoreQuotes(
          category: categories[widget.itemIndex], pageNumber: pageNumber);
    } else {
      categories = categoryProvider.defaultCategories;
      await quoteListingProvider.fetchMoreQuotes(
          category: categories[widget.itemIndex], pageNumber: pageNumber);
    }
  }

  @override
  void dispose() {
    // streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var arguments;
    if (ModalRoute.of(context)!.settings.arguments != null) {
      arguments = ModalRoute.of(context)!.settings.arguments
          as QuoteListingScreenArguments;
    }
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
          categoryProvider.categoryResponse.result[widget.itemIndex].category,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Consumer<QuoteListingProvider>(
        builder: (context, dataClass, _) {
          if (dataClass.quoteResStatus == ApiStatus.isLoading &&
              dataClass.newCategoryItem.isEmpty) {
            return const QuoteListingShimmer();
          } else if (dataClass.moreQuoteResStatus == ApiStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/error.png',
                    width: deviceSize.width - 160,
                  ),
                  const Text('Something went Wrong!')
                ],
              ),
            );
          } else {
            return GridView.builder(
              controller: scrollController,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(18),
              itemCount: dataClass.newCategoryItem.isNotEmpty
                  ? dataClass.categoryItem.length + 2
                  : dataClass.categoryItem.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
              ),
              itemBuilder: (context, index) {
                if (index < dataClass.categoryItem.length) {
                  return quoteContainer(dataClass, index, context, arguments);
                } else {
                  return dataClass.newCategoryItem.isNotEmpty
                      ? const Shimmer(
                          width: double.infinity,
                          height: 15,
                          borderRadius: 10,
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget quoteContainer(QuoteListingProvider dataClass, int index,
      BuildContext context, QuoteListingScreenArguments arguments) {
    return Hero(
      tag: '${arguments.categoryName}$index',
      child: ImageContainer(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.feature,
            arguments: FeatureScreenArguments(
              tagName: '${arguments.categoryName}$index',
              imagePath: dataClass.categoryItem[index].image.path,
              imageAuthor: dataClass.categoryItem[index].image.author.author,
              quote: dataClass.categoryItem[index].quote.quote,
              categoryId: dataClass.categoryItem[index].quote.categoryId,
            ),
          );
        },
        imgPath: dataClass.categoryItem[index].image.path,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            dataClass.categoryItem[index].quote.quote,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.white, fontSize: 14),
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

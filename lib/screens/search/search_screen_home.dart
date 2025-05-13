import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/daily_quotes_provider.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/search_provider.dart';
import 'package:quotify/screens/feature/feature_screen.dart';
import 'package:quotify/screens/quotes/quote_listing_screen.dart';
import 'package:quotify/screens/quotes/widgets/quote_listing_shimmer.dart';
import 'package:quotify/screens/search/search_screen.dart';
import 'package:quotify/widgets/custom_page_route.dart';
import 'package:quotify/widgets/image_container.dart';

class SearchScreenHome extends StatefulWidget {
  const SearchScreenHome({super.key});

  @override
  State<SearchScreenHome> createState() => _SearchScreenHomeState();
}

class _SearchScreenHomeState extends State<SearchScreenHome> {
  QuoteListingProvider quoteListingProvider = Provider.of<QuoteListingProvider>(
      scaffoldKey.currentContext!,
      listen: false);
  DailyQuotesProvider dailyQuotesProvider = Provider.of<DailyQuotesProvider>(
      scaffoldKey.currentContext!,
      listen: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (var quote in dailyQuotesProvider.quotesData) {
        for (int i = 0; i < quote.categoryItems.length; i++) {
          dailyQuotesProvider.recommendedQuotes.add(quote.categoryItems[i]);
        }
      }
      dailyQuotesProvider.notifyListeners();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _searchButton(context),
              _categorySection(context),
              _recomendations(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchButton(BuildContext context) {
    SearchProvider searchProvider =
        Provider.of<SearchProvider>(context, listen: false);
    return TextButton(
      onPressed: () {
        searchProvider.searchResponse = [];
        searchProvider.newCategoryItem = [];
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ));
      },
      style: TextButton.styleFrom(
        backgroundColor: AppColors.lightGrey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Search your quotes',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.defaultGrey,
                ),
          ),
          const Icon(
            Icons.search,
            color: AppColors.defaultGrey,
          )
        ],
      ),
    );
  }

  Widget _recomendations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.height20,
        RichText(
          text: TextSpan(
              style: Theme.of(context).textTheme.titleMedium,
              children: [
                const TextSpan(
                  text: 'Quotes',
                ),
                // TextSpan(
                //   text: ' you',
                //   style: GoogleFonts.fuzzyBubbles(
                //       fontSize: 20,
                //       color: AppColors.purple,
                //       fontWeight: FontWeight.bold),
                // ),
              ]),
        ),
        AppSpacing.height20,
        Consumer<DailyQuotesProvider>(
          builder: (context, dailyQuotesProvider, _) {
            if (dailyQuotesProvider.recommendedQuotes.length <= 0) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const QuoteListingShimmer());
            } else {
              return GridView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: dailyQuotesProvider.recommendedQuotes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18),
                itemBuilder: (context, index) {
                  return Hero(
                    tag: 'feature$index',
                    child: ImageContainer(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'feature',
                          arguments: FeatureScreenArguments(
                            tagName: 'feature$index',
                            imagePath: dailyQuotesProvider
                                .recommendedQuotes[index].image.path,
                            imageAuthor:
                                dailyQuotesProvider.recommendedQuotes[index].image.author.author,
                            quote: dailyQuotesProvider
                                .recommendedQuotes[index].quote.quote,
                            categoryId: dailyQuotesProvider
                                .recommendedQuotes[index].quote.categoryId,
                          ),
                        );
                      },
                      imgPath: dailyQuotesProvider
                          .recommendedQuotes[index].image.path,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          dailyQuotesProvider
                              .recommendedQuotes[index].quote.quote,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        )
      ],
    );
  }

  Widget _categorySection(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
      bool isButtonTapped = categoryProvider.seeMoreBtnInSearch;
      int categoryLength = categoryProvider.categoryResponse.result.length;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.height10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          AppSpacing.height10,
          GridView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: categoryLength <= 6
                ? 6
                : isButtonTapped
                    ? categoryLength
                    : 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 5 / 2),
            itemBuilder: (context, index) {
              var category = categoryProvider.categoryResponse.result[index];
              return ImageContainer(
                imgPath: category.categoryImage,
                child: Text(
                  category.category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                ),
                onTap: () {
                  quoteListingProvider.moreQuoteResStatus = ApiStatus.isLoading;
                  quoteListingProvider.initializeData();
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      child: QuoteListingScreen(
                        itemIndex: index,
                      ),
                      settings: RouteSettings(
                        arguments: QuoteListingScreenArguments(
                          categoryName: category.category,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          AppSpacing.height20,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: AppColors.defaultPink,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
                onPressed: () {
                  categoryProvider.seeMoreBtnInSearch = !isButtonTapped;
                },
                child: Row(
                  children: [
                    Text(
                      !isButtonTapped ? 'See more' : 'See less',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                    ),
                    Icon(
                      !isButtonTapped
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up,
                      color: AppColors.black,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/provider/search_provider.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/feature/feature_screen.dart';
import 'package:quotify/screens/quotes/widgets/quote_listing_shimmer.dart';
import 'package:quotify/widgets/image_container.dart';

import '../../../config/constants/globals/globals.dart';
import '../../../widgets/shimmer.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  ScrollController scrollController = ScrollController();
  SearchProvider searchProvider =
      Provider.of<SearchProvider>(scaffoldKey.currentContext!, listen: false);

  int pageNumber = 1;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        var isKeboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
        if (isKeboardVisible) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          loadMoreData();
        }
      });
    });
    super.initState();
  }

  loadMoreData() async {
    searchProvider.pageNumber++;
    await searchProvider.searchCategory();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, _) {
        if (searchProvider.searchApiStatus == ApiStatus.isLoaded &&
            searchProvider.searchResponse.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: deviceSize.width * 0.4,
                    child: Image.asset('assets/images/no-result-found.png'),
                  ),
                  const Text('No result found!')
                ],
              ),
            ),
          );
        } else if (searchProvider.searchApiStatus == ApiStatus.error) {
          return Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: deviceSize.width * 0.6,
                    child: Image.asset('assets/images/error.png'),
                  ),
                  const Text('Something went Wrong!')
                ],
              ),
            ),
          );
        } else if (searchProvider.searchApiStatus == ApiStatus.isLoading &&
            searchProvider.searchResponse.isEmpty) {
          return const QuoteListingShimmer();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: GridView.builder(
            controller: scrollController,
            itemCount: searchProvider.newCategoryItem.isNotEmpty
                ? searchProvider.searchResponse.length + 2
                : searchProvider.searchResponse.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              if (index < searchProvider.searchResponse.length) {
                return quoteListingCard(index, context, searchProvider);
              } else {
                return searchProvider.newCategoryItem.isNotEmpty
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
          ),
        );
      },
    );
  }

  Widget quoteListingCard(
      int index, BuildContext context, SearchProvider searchProvider) {
    return Hero(
      tag: '$index',
      child: ImageContainer(
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.pushNamed(
            context,
            AppRoutes.feature,
            arguments: FeatureScreenArguments(
              tagName:  '$index',
              imagePath:  searchProvider.searchResponse[index].image.path,
              imageAuthor:  searchProvider.searchResponse[index].image.author.author,
              quote:  searchProvider.searchResponse[index].quote.quote,
              categoryId:  searchProvider.searchResponse[index].quote.categoryId
            ),
          );
        },
        imgPath: searchProvider.searchResponse[index].image.path,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            searchProvider.searchResponse[index].quote.quote,
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/models/quotable_res_model.dart';
import 'package:quotify/models/quotes_data_model.dart';
import 'package:quotify/models/unsplash_res_model.dart';

class Helpers {
  static Future<QuotesDataModel> sortData(
      {String? categgoryName,
      UnsplashResModel? imageDataModel,
      QuotesResponseModel? quoteDataModel}) async {
    QuotesDataModel quotesRes =
        QuotesDataModel(categoryItems: [], categoryName: '');
    if (imageDataModel?.results != null && quoteDataModel?.data != null) {
      if (imageDataModel!.results!.length <= quoteDataModel!.data.length) {
        quotesRes.categoryName = categgoryName!;
        for (int i = 0; i < imageDataModel.results!.length; i++) {
          quotesRes.categoryItems.add(
            CategoryItem(
              image: CategoryImage(
                imageId: imageDataModel.results![i].id!,
                path: imageDataModel.results![i].urls!.regular!,
                author: CategoryImageAuthor(
                  id: imageDataModel.results![i].user!.id!,
                  profile: imageDataModel.results![i].user!.id!,
                  author: imageDataModel.results![i].user!.name!,
                ),
              ),
              quote: Quote(
                quoteId: quoteDataModel.data[i].id,
                quote: quoteDataModel.data[i].quote,
                author: QuoteAuthor(
                  author: quoteDataModel.data[i].author,
                ),
                categoryId: quoteDataModel.data[i].categoryId
              ),
            ),
          );
        }
      } else {
        quotesRes.categoryName = categgoryName!;
        for (int i = 0; i < quoteDataModel.data.length; i++) {
          quotesRes.categoryItems.add(
            CategoryItem(
              image: CategoryImage(
                imageId: imageDataModel.results![i].id!,
                path: imageDataModel.results![i].urls!.regular!,
                author: CategoryImageAuthor(
                  id: imageDataModel.results![i].user!.id!,
                  profile:
                      imageDataModel.results![i].user!.profileImage!.medium!,
                  author: imageDataModel.results![i].user!.name!,
                ),
              ),
              quote: Quote(
                quoteId: quoteDataModel.data[i].id,
                quote: quoteDataModel.data[i].quote,
                author: QuoteAuthor(
                  author: quoteDataModel.data[i].author,
                ),
                categoryId: quoteDataModel.data[i].categoryId
              ),
            ),
          );
        }
      }
    }
    return quotesRes;
  }

  static Future<List<CategoryItem>> sortCategoryData(
      {UnsplashResModel? imageDataModel,
      QuotesResponseModel? quoteDataModel}) async {
    List<CategoryItem> quotes = [];
    if (imageDataModel?.results != null && quoteDataModel?.data != null) {
      if (imageDataModel!.results!.length <= quoteDataModel!.data.length) {
        for (int i = 0; i < imageDataModel.results!.length; i++) {
          quotes.add(
            CategoryItem(
              image: CategoryImage(
                imageId: imageDataModel.results![i].id!,
                path: imageDataModel.results![i].urls!.regular!,
                author: CategoryImageAuthor(
                  id: imageDataModel.results![i].user!.id!,
                  profile: imageDataModel.results![i].user!.id!,
                  author: imageDataModel.results![i].user!.name!,
                ),
              ),
              quote: Quote(
                quoteId: quoteDataModel.data[i].id,
                quote: quoteDataModel.data[i].quote,
                author: QuoteAuthor(
                  author: quoteDataModel.data[i].author,
                ),
                categoryId: quoteDataModel.data[i].categoryId
              ),
            ),
          );
        }
      } else {
        for (int i = 0; i < quoteDataModel.data.length; i++) {
          quotes.add(
            CategoryItem(
              image: CategoryImage(
                imageId: imageDataModel.results![i].id!,
                path: imageDataModel.results![i].urls!.regular!,
                author: CategoryImageAuthor(
                  id: imageDataModel.results![i].user!.id!,
                  profile: imageDataModel.results![i].user!.id!,
                  author: imageDataModel.results![i].user!.name!,
                ),
              ),
              quote: Quote(
                quoteId: quoteDataModel.data[i].id,
                quote: quoteDataModel.data[i].quote,
                author: QuoteAuthor(
                  author: quoteDataModel.data[i].author,
                ),
                categoryId: quoteDataModel.data[i].categoryId
              ),
            ),
          );
        }
      }
    }
    return quotes;
  }

  Future<bool> checkConnectivity(BuildContext context,
      {bool showSnackBar = true}) async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      } else {
        isConnected = false;
        Future.delayed(Duration.zero, () {
          if (showSnackBar) showConnectionSnackBar(context);
        });
      }
    } on SocketException catch (_) {
      isConnected = false;
      Future.delayed(Duration.zero, () {
        if (showSnackBar) showConnectionSnackBar(context);
      });
    }
    return isConnected;
  }

  showConnectionSnackBar(BuildContext context) {
    SnackBar snackBar = const SnackBar(
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.black,
            size: 20,
          ),
          AppSpacing.width10,
          Text(
            "No internet connection!",
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

 static String capitalizeString(String string) {
    return string
        .trim()
        .split(' ')
        .map((e) => "${e[0].toUpperCase()}${e.substring(1).toLowerCase()}")
        .join(' ');
  }
}

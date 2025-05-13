import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/helpers/helpers.dart';
import 'package:quotify/models/base_category_model.dart';
import 'package:quotify/models/quotable_res_model.dart';
import 'package:quotify/models/quotes_data_model.dart';
import 'package:quotify/models/unsplash_res_model.dart';
import 'package:quotify/services/api_services/quote_services.dart';

class DailyQuotesProvider extends ChangeNotifier {
  final _dailyQuoteServices = QuoteServices();

  ApiStatus _dailyQuoteResStatus = ApiStatus.none;

  ApiStatus get dailyQuoteResStatus => _dailyQuoteResStatus;

  set dailyQuoteResStatus(ApiStatus value) {
    _dailyQuoteResStatus = value;
    notifyListeners();
  }

  ApiStatus _categoryQuoteResStatus = ApiStatus.none;

  ApiStatus get categoryQuoteResStatus => _categoryQuoteResStatus;

  set categoryQuoteResStatus(ApiStatus value) {
    _categoryQuoteResStatus = value;
    notifyListeners();
  }

  List<QuotesDataModel> _quotesData = [];

  List<QuotesDataModel> get quotesData => _quotesData;

  set quotesData(List<QuotesDataModel> value) {
    _quotesData = value;
    notifyListeners();
  }

  List<CategoryItem> _allQuotes = [];

  List<CategoryItem> get allQuotes => _allQuotes;

  set allQuotes(List<CategoryItem> value) {
    _allQuotes = value;
    notifyListeners();
  }

  List<CategoryItem> _recommendedQuotes = [];

  List<CategoryItem> get recommendedQuotes => _recommendedQuotes;

  set recommendedQuotes(List<CategoryItem> value) {
    _recommendedQuotes = value;
    notifyListeners();
  }

  // String _selectedCategory = 'Category';

  // String get selectedCategory => _selectedCategory;

  // set selectedCategory(String value) {
  //   _selectedCategory = value;
  //   notifyListeners();
  // }

  Map<String, dynamic> _selectedCategory = {
    'id': 0,
    'category': 'Category'
  };

  Map<String, dynamic> get selectedCategory => _selectedCategory;

  set selectedCategory(Map<String, dynamic> value) {
    _selectedCategory = value;
    notifyListeners();
  }

  Future<void> fetchQuotes({required List<String> userSelectedCategories}) async {
    log('==> provider fetchquotes');
    quotesData = [];
    dailyQuoteResStatus = ApiStatus.isLoading;
    for (var item in userSelectedCategories) {
      // log(item);
      Map<String,dynamic> parsedJson = jsonDecode(item);
      CategoryBase category = CategoryBase.fromJson({"id":parsedJson['category_id'],"category":parsedJson['category']});
      Response? imgResponse = await _dailyQuoteServices.fetchDailyQuoteImages(
          category: category.category);
      Response quoteResponse = await _dailyQuoteServices.fetchDailyQuoteText(
          categoryId: category.id.toString());
      if (imgResponse?.data == null || quoteResponse.data == null) {
        dailyQuoteResStatus = ApiStatus.isNull;
      } else {
        if (imgResponse?.statusCode == 200 && quoteResponse.statusCode == 200) {
          log(imgResponse!.data['results'][0].toString());
          var imageDataModel = UnsplashResModel.fromJson(imgResponse.data);
          var quoteDataModel = QuotesResponseModel.fromJson(quoteResponse.data);
          quotesData.add(await Helpers.sortData(
            categgoryName: category.category,
            imageDataModel: imageDataModel,
            quoteDataModel: quoteDataModel,
          ));
          log(quotesData.length.toString());
          if (userSelectedCategories.length == quotesData.length) {
            dailyQuoteResStatus = ApiStatus.isLoaded;
          }
        } else {
          dailyQuoteResStatus = ApiStatus.error;
        }
      }
    }
  }

  Future<void> fetchCategoryQuotes(
      {required Map<String, dynamic> category}) async {
    CategoryBase categoryItem = CategoryBase(id: 0, category: '');
    if (category['category'] == 'Category') {
      categoryItem.category = 'Category';
    }
    categoryItem = CategoryBase.fromJson(category);
    categoryQuoteResStatus = ApiStatus.isLoading;
    Response? imgResponse = await _dailyQuoteServices.fetchDailyQuoteImages(
        category: categoryItem.category);
    Response quoteResponse = await _dailyQuoteServices.fetchDailyQuoteText(
        categoryId: categoryItem.category == 'Category'
            ? 'Category'
            : categoryItem.id.toString());

    if (imgResponse?.statusCode == 200 && quoteResponse.statusCode == 200) {
      UnsplashResModel? imageDataModel;
      QuotesResponseModel? quoteDataModel;
      if (categoryItem.category == 'Category') {
        imageDataModel = UnsplashResModel.fromJson(
            // ignore: unnecessary_cast
            {"results": imgResponse!.data} as Map<String, dynamic>);
        quoteDataModel = QuotesResponseModel.fromJson(quoteResponse.data);
      } else {
        imageDataModel = UnsplashResModel.fromJson(imgResponse!.data);
        quoteDataModel = QuotesResponseModel.fromJson(quoteResponse.data);
      }
      allQuotes = await Helpers.sortCategoryData(
        imageDataModel: imageDataModel,
        quoteDataModel: quoteDataModel,
      );
      print('------ -----------  ${allQuotes}');
      notifyListeners();
      categoryQuoteResStatus = ApiStatus.isLoaded;
    } else {
      categoryQuoteResStatus = ApiStatus.error;
    }
  }
}

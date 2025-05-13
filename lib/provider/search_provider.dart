import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/helpers/helpers.dart';
import 'package:quotify/models/base_category_model.dart';
import 'package:quotify/models/base_user_category_model.dart';
import 'package:quotify/models/quotable_res_model.dart';
import 'package:quotify/models/quotes_data_model.dart';
import 'package:quotify/models/unsplash_res_model.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/services/api_services/quote_services.dart';
import 'package:quotify/services/api_services/search_searvices.dart';

class SearchProvider extends ChangeNotifier {
  final QuoteServices _quoteServices = QuoteServices();
  final categoryProvider =
      Provider.of<CategoryProvider>(scaffoldKey.currentContext!);

  int _pageNumber = 1;

  int get pageNumber => _pageNumber;

  set pageNumber(int value) {
    _pageNumber = value;
    notifyListeners();
  }

  ApiStatus _searchApiStatus = ApiStatus.none;

  ApiStatus get searchApiStatus => _searchApiStatus;

  set searchApiStatus(ApiStatus value) {
    _searchApiStatus = value;
    notifyListeners();
  }

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<CategoryItem> _searchResponse = [];

  List<CategoryItem> get searchResponse => _searchResponse;

  set searchResponse(List<CategoryItem> value) {
    _searchResponse = value;
    notifyListeners();
  }

  List<CategoryItem> _newCategoryItem = [];

  List<CategoryItem> get newCategoryItem => _newCategoryItem;

  set newCategoryItem(List<CategoryItem> value) {
    _newCategoryItem = value;
    notifyListeners();
  }

  Future<void> searchCategory() async {
    searchApiStatus = ApiStatus.isLoading;
    UserCategoryBase categories = UserCategoryBase(categoryId: 0, category: '');
    List categoryList =
        jsonDecode(jsonEncode(categoryProvider.defaultCategories));

    categoryList.forEach((element) async {
      categories = UserCategoryBase.fromJson(jsonDecode(element));
      var searchedItem = Helpers.capitalizeString(searchQuery);
      if (categories.category.contains(searchedItem)) {
        Response? imagesRes = await _quoteServices.fetchDailyQuoteImages(
            category: categories.category, pageNumber: pageNumber);
        Response? response =
            await SearchServices().searchCategory(searchQuery, pageNumber);
        if (response != null &&
            imagesRes != null &&
            response.statusCode == 200 &&
            imagesRes.statusCode == 200) {
          var imageDataRes = UnsplashResModel.fromJson(imagesRes.data);
          var searchRes = QuotesResponseModel.fromJson(response.data);
          var data = await Helpers.sortCategoryData(
            imageDataModel: imageDataRes,
            quoteDataModel: searchRes,
          );
          newCategoryItem = data;
          searchResponse.addAll(newCategoryItem);
          if (data.isEmpty) {
            searchApiStatus = ApiStatus.none;
          }
        } else {
          searchApiStatus = ApiStatus.error;
        }
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          searchApiStatus = ApiStatus.none; 
        });
      }
    });
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/helpers/helpers.dart';
import 'package:quotify/models/add_favorite_res_model.dart';
import 'package:quotify/models/base_category_model.dart';
import 'package:quotify/models/base_user_category_model.dart';
import 'package:quotify/models/favorites_res_model.dart';
import 'package:quotify/models/quotable_res_model.dart';
import 'package:quotify/models/quotes_data_model.dart';
import 'package:quotify/models/token_data_model.dart';
import 'package:quotify/models/unsplash_res_model.dart';
import 'package:quotify/services/api_services/quote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteListingProvider extends ChangeNotifier {
  final _dailyQuoteServices = QuoteServices();

  final _favoritesServices = QuoteServices();

  ApiStatus _quoteResStatus = ApiStatus.none;

  ApiStatus get quoteResStatus => _quoteResStatus;

  set quoteResStatus(ApiStatus value) {
    _quoteResStatus = value;
    notifyListeners();
  }

  ApiStatus _favoritesStatus = ApiStatus.none;

  ApiStatus get favoritesStatus => _favoritesStatus;

  set favoritesStatus(ApiStatus value) {
    _favoritesStatus = value;
    notifyListeners();
  }

  ApiStatus _addFavoriteStatus = ApiStatus.none;

  ApiStatus get addFavoriteStatus => _addFavoriteStatus;

  set addFavoriteStatus(ApiStatus value) {
    _addFavoriteStatus = value;
    notifyListeners();
  }

  ApiStatus _removeFavoriteStatus = ApiStatus.none;

  ApiStatus get removeFavoriteStatus => _removeFavoriteStatus;

  set removeFavoriteStatus(ApiStatus value) {
    _removeFavoriteStatus = value;
    notifyListeners();
  }

  ApiStatus _moreQuoteResStatus = ApiStatus.none;

  ApiStatus get moreQuoteResStatus => _moreQuoteResStatus;

  set moreQuoteResStatus(ApiStatus value) {
    _moreQuoteResStatus = value;
    notifyListeners();
  }

  List<QuotesDataModel> _quoteData = [
    QuotesDataModel(categoryName: '', categoryItems: [])
  ];

  List<QuotesDataModel> get quoteData => _quoteData;

  set quoteData(List<QuotesDataModel> value) {
    _quoteData = value;
    notifyListeners();
  }

  List<CategoryItem> _categoryItem = [];

  List<CategoryItem> get categoryItem => _categoryItem;

  set categoryItem(List<CategoryItem> value) {
    _categoryItem = value;
    notifyListeners();
  }

  List<CategoryItem> _newCategoryItem = [];

  List<CategoryItem> get newCategoryItem => _newCategoryItem;

  set newCategoryItem(List<CategoryItem> value) {
    _newCategoryItem = value;
    notifyListeners();
  }

  void initializeData() {
    categoryItem = [];
    newCategoryItem = [];
    notifyListeners();
  }

  Future<void> fetchInitialQuotes(
      {required String category, required int pageNumber}) async {
    quoteResStatus = ApiStatus.isLoading;

    UserCategoryBase currentCategory =
        UserCategoryBase.fromJson(jsonDecode(category));
    Response? imgResponse = await _dailyQuoteServices.fetchDailyQuoteImages(
        category: currentCategory.category, pageNumber: pageNumber);
    Response quoteResponse = await _dailyQuoteServices.fetchDailyQuoteText(
        categoryId: currentCategory.categoryId.toString(),
        pageNUmber: pageNumber);
    if (imgResponse?.data == null || quoteResponse.data == null) {
      quoteResStatus = ApiStatus.isNull;
    } else {
      if (imgResponse!.statusCode == 200 && quoteResponse.statusCode == 200) {
        var imageDataModel = UnsplashResModel.fromJson(imgResponse.data);
        var quoteDataModel = QuotesResponseModel.fromJson(quoteResponse.data);
        var data = await Helpers.sortData(
          categgoryName: currentCategory.category,
          imageDataModel: imageDataModel,
          quoteDataModel: quoteDataModel,
        );

        log(data.toString());

        newCategoryItem = data.categoryItems;
        categoryItem.addAll(newCategoryItem);
        quoteResStatus = ApiStatus.isLoaded;
      } else {
        quoteResStatus = ApiStatus.error;
      }
    }
  }

  Future<void> fetchMoreQuotes(
      {required String category, required int pageNumber}) async {
    moreQuoteResStatus = ApiStatus.isLoading;

    UserCategoryBase currentCategory =
        UserCategoryBase.fromJson(jsonDecode(category));
    log(currentCategory.category.toString());
    Response? imgResponse = await _dailyQuoteServices.fetchDailyQuoteImages(
        category: currentCategory.category, pageNumber: pageNumber);
    Response quoteResponse = await _dailyQuoteServices.fetchDailyQuoteText(
        categoryId: currentCategory.categoryId.toString(),
        pageNUmber: pageNumber);
    if (imgResponse?.data == null || quoteResponse.data == null) {
      moreQuoteResStatus = ApiStatus.isNull;
    } else {
      if (imgResponse!.statusCode == 200 && quoteResponse.statusCode == 200) {
        var imageDataModel = UnsplashResModel.fromJson(imgResponse.data);
        var quoteDataModel = QuotesResponseModel.fromJson(quoteResponse.data);
        var data = await Helpers.sortData(
          categgoryName: currentCategory.category,
          imageDataModel: imageDataModel,
          quoteDataModel: quoteDataModel,
        );

        newCategoryItem = data.categoryItems;
        categoryItem.addAll(newCategoryItem);
        moreQuoteResStatus = ApiStatus.isLoaded;
      } else {
        moreQuoteResStatus = ApiStatus.error;
      }
    }
  }

  FavoriteResModel _favoriteResponse = FavoriteResModel(result: []);

  FavoriteResModel get favoriteResponse => _favoriteResponse;

  set favoriteResponse(FavoriteResModel value) {
    _favoriteResponse = value;
    notifyListeners();
  }

  bool _isFavoritesEmpty = false;
  bool get isFavoritesEmpty => _isFavoritesEmpty;
  set isFavoritesEmpty(bool value) {
    _isFavoritesEmpty = value;
    notifyListeners();
  }

  bool isFetchingMore = false; // Tracks if data is being fetched
  bool hasMore = true; // Indicates if more data is available
  int totalItems = 0;
  int totalPages = 0;
  int currentPage = 1;

  Future<Response?> fetchFavorites() async {
    // if (favoritesStatus != ApiStatus.isLoaded) {
      favoritesStatus = ApiStatus.isLoading;
      isFavoritesEmpty = false;
    // }
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    TokenDataModel userDt = TokenDataModel.fromJson(jsonDecode(userData ?? ''));
    Response? response =
        await _favoritesServices.fetchFavorites(userDt.data.accessToken, 1);
    final Map<String, dynamic> decodedResponse = response.data;
    print('----- favorite res ${decodedResponse}');
    if (response != null) {
      if (response.statusCode == 200) {
        totalItems = decodedResponse['pagination']['totalItems'];
        totalPages = decodedResponse['pagination']['totalPages'];
        currentPage = decodedResponse['pagination']['currentPage'];
        hasMore = currentPage < totalPages;
        favoriteResponse = FavoriteResModel.fromJson(response.data);
        favoritesStatus = ApiStatus.isLoaded;
      } else {
        favoritesStatus = ApiStatus.error;
      }
    } else {
      isFavoritesEmpty = true;
      favoritesStatus = ApiStatus.error;
    }
    return response;
  }

  Future<Response?> fetchFavoritesFromApi() async {
    if (favoritesStatus != ApiStatus.isLoaded) {
      favoritesStatus = ApiStatus.isLoading;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    TokenDataModel userDt = TokenDataModel.fromJson(jsonDecode(userData ?? ''));
    Response? response = await _favoritesServices.fetchFavorites(
        userDt.data.accessToken, currentPage);
    final Map<String, dynamic> decodedResponse = response.data;
    if (response != null) {
      if (response.statusCode == 200) {
        totalItems = decodedResponse['pagination']['totalItems'];
        totalPages = decodedResponse['pagination']['totalPages'];
        currentPage = decodedResponse['pagination']['currentPage'];
        hasMore = currentPage < totalPages;
        favoritesStatus = ApiStatus.isLoaded;
      } else {
        favoritesStatus = ApiStatus.error;
      }
    } else {
      favoritesStatus = ApiStatus.error;
    }
    return response;
  }

  Future<void> loadMoreFavorites() async {
    if (isFetchingMore || !hasMore) return;

    isFetchingMore = true;
    currentPage += 1; // Increment the page number
    notifyListeners();

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // var userData = pref.getString(SP.tokenData);
    // TokenDataModel userDt = TokenDataModel.fromJson(jsonDecode(userData ?? ''));
    Response? response = await fetchFavoritesFromApi(); // API call
    if (response?.data.isNotEmpty) {
      if (response?.data['result'] != null) {
        favoriteResponse.result.addAll(
          (response?.data['result'] as List<dynamic>)
              .map((item) => FavoriteListItemDatum.fromJson(item)),
        );
      }
      final Map<String, dynamic> decodedResponse = response?.data;
      totalItems = decodedResponse['pagination']['totalItems'];
      totalPages = decodedResponse['pagination']['totalPages'];
      currentPage = decodedResponse['pagination']['currentPage'];
      hasMore = currentPage < totalPages; // Adjust based on API response
    } else {
      hasMore = false;
    }

    isFetchingMore = false;
    notifyListeners();
  }

  AddFavoriteResponse _addFavoriteResponse =
      AddFavoriteResponse(message: '', result: null);

  AddFavoriteResponse get addFavoriteResponse => _addFavoriteResponse;

  set addFavoriteResponse(AddFavoriteResponse value) {
    _addFavoriteResponse = value;
    notifyListeners();
  }

  Future<Response?> addToFavorite(
      {required String quote,
      required String quoteImage,
      required String imageAuthor,
      required int categoryId}) async {
    addFavoriteStatus = ApiStatus.isLoading;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    TokenDataModel userDt = TokenDataModel.fromJson(jsonDecode(userData ?? ''));
    Response? response = await _favoritesServices.addQuoteToFavorite(
        quote, quoteImage,imageAuthor, categoryId);
    print('----- favorite res $response');
    if (response != null) {
      if (response.statusCode == 200) {
        addFavoriteResponse = AddFavoriteResponse.fromJson(response.data);
        addFavoriteStatus = ApiStatus.isLoaded;
      } else {
        addFavoriteStatus = ApiStatus.error;
      }
    } else {
      addFavoriteStatus = ApiStatus.error;
    }
    return response;
  }

  // RemoveFavoriteResponse _RemoveFavoriteResponse =
  //     RemoveFavoriteResponse(message: '', result: null);

  // RemoveFavoriteResponse get RemoveFavoriteResponse => _RemoveFavoriteResponse;

  // set RemoveFavoriteResponse(RemoveFavoriteResponse value) {
  //   _addFavoriteResponse = value;
  //   notifyListeners();
  // }

  Future<Response?> removeFromFavorites(
      {required String quote,
      required String quoteImage,
      required int categoryId}) async {
    // addFavoriteStatus = ApiStatus.isLoading;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    TokenDataModel userDt = TokenDataModel.fromJson(jsonDecode(userData ?? ''));
    Response? response = await _favoritesServices.removeQuoteFromFavorite(
        quote, quoteImage, categoryId);
    print('----- favorite res $response');
    if (response != null) {
      if (response.statusCode == 200) {
        favoriteResponse.result.removeWhere((item) => item.quote == quote);
        notifyListeners();
        if (favoriteResponse.result.isEmpty) {
          favoritesStatus = ApiStatus.isNull;
        }
      }
    }
    return response;
  }
}

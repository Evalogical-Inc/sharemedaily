import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/models/edit_quote_model.dart';
import 'package:quotify/models/token_data_model.dart';
import 'package:quotify/services/api_services/quote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProvider extends ChangeNotifier {
  Map<String, dynamic> _editData = {};
  final _editQuoteServices = QuoteServices();

  // Map<String,dynamic> get editData => _editData;

  String addNewlines(String text, {int maxLength = 15}) {
    List<String> words = text.split(' ');
    StringBuffer formattedText = StringBuffer();
    StringBuffer currentLine = StringBuffer();

    for (String word in words) {
      // Check if adding the next word exceeds the max length
      if ((currentLine.length + word.length + (currentLine.isEmpty ? 0 : 1)) >
          maxLength) {
        // Add the current line to formatted text and start a new line
        formattedText.writeln(currentLine.toString().trim());
        currentLine.clear();
      }

      // Append word to the current line
      if (currentLine.isNotEmpty) {
        currentLine.write(' '); // Add space before word
      }
      currentLine.write(word);
    }

    // Append the last remaining line
    if (currentLine.isNotEmpty) {
      formattedText.writeln(currentLine.toString().trim());
    }

    return formattedText.toString().trim();
  }

  String getEditData(String quote) {
    var formattedQuote = addNewlines(quote);
    _editData = {
      "v": "6.0.0",
      "m": true,
      "p": 0,
      "h": [
        {
          "l": [
            {"id": "A"}
          ],
          "a": [
            {
              "id": "brightness",
              "value": 0.07499999999999996,
              "matrix": [
                1.0,
                0.0,
                0.0,
                0.0,
                7.499999999999996,
                0.0,
                1.0,
                0.0,
                0.0,
                7.499999999999996,
                0.0,
                0.0,
                1.0,
                0.0,
                7.499999999999996,
                0.0,
                0.0,
                0.0,
                1.0,
                0.0
              ]
            },
            {
              "id": "contrast",
              "value": -0.0050000000000000044,
              "matrix": [
                0.9901258284506771,
                0.0,
                0.0,
                0.0,
                1.2638939583133322,
                0.0,
                0.9901258284506771,
                0.0,
                0.0,
                1.2638939583133322,
                0.0,
                0.0,
                0.9901258284506771,
                0.0,
                1.2638939583133322,
                0.0,
                0.0,
                0.0,
                1.0,
                0.0
              ]
            },
            {
              "id": "exposure",
              "value": -0.49,
              "matrix": [
                0.7120250977985358,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.7120250977985358,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.7120250977985358,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                1.0,
                0.0
              ]
            }
          ],
          "t": {
            "angle": 0.0,
            "cropRect": {
              "left": 23.875,
              "top": 0.0,
              "right": 281.725,
              "bottom": 458.40000000000003
            },
            "originalSize": {"width": 305.6, "height": 458.40000000000003},
            "cropEditorScreenRatio": 0.4827295703454086,
            "scaleUser": 1.0,
            "scaleRotation": 1.1851851851851851,
            "aspectRatio": 0.5625,
            "flipX": false,
            "flipY": false,
            "offset": {"dx": 0.4024414062500057, "dy": 0.0}
          }
        }
      ],
      "r": {
        "A": {
          "x": 0.0,
          "y": 0.0,
          "r": -1.9377047211159065e-17,
          "s": 1.6415872769790032,
          "fx": false,
          "fy": false,
          "in": {"m": true, "s": true, "r": true, "t": true, "e": true},
          "t": "text",
          "te": formattedQuote,
          "cm": "onlyColor",
          "c": 4294961898,
          "b": 0,
          "cp": 0.13523731355382618,
          "a": "center",
          "f": 1.0,
          "ff": "Roboto_500",
          "fw": 500
        }
      },
      "i": {"w": 1080.0, "h": 1620.0},
      "l": {"w": 384.0, "h": 576.0}
    };
    return jsonEncode(_editData);
  }

  void setEditData(Map<String, dynamic> value) {
    _editData = value;
    notifyListeners();
  }

  ApiStatus _editQuoteStatus = ApiStatus.none;

  ApiStatus get editQuoteStatus => _editQuoteStatus;

  set editQuoteStatus(ApiStatus value) {
    _editQuoteStatus = value;
    notifyListeners();
  }

  EditQuoteResModel _editQuoteResponse = EditQuoteResModel(result: []);

  EditQuoteResModel get editQuoteResponse => _editQuoteResponse;

  set editQuoteResponse(EditQuoteResModel value) {
    _editQuoteResponse = value;
    notifyListeners();
  }

  bool isFetchingMore = false; // Tracks if data is being fetched
  bool hasMore = true; // Indicates if more data is available
  int totalItems = 0;
  int totalPages = 0;
  int currentPage = 1;

  Future<Response?> fetchEditQuotes() async {
    // if (editQuoteStatus != ApiStatus.isLoaded) {
      editQuoteStatus = ApiStatus.isLoading;
    // }
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    TokenDataModel userDt = TokenDataModel.fromJson(jsonDecode(userData ?? ''));
    Response? response =
        await _editQuoteServices.fetchEditQuotes(userDt.data.accessToken, 1);
    final Map<String, dynamic> decodedResponse = response.data;
    print('----- favorite res ${decodedResponse}');
    if (response != null) {
      if (response.statusCode == 200) {
        totalItems = decodedResponse['pagination']['totalItems'];
        totalPages = decodedResponse['pagination']['totalPages'];
        currentPage = decodedResponse['pagination']['currentPage'];
        hasMore = currentPage < totalPages;
        editQuoteResponse = EditQuoteResModel.fromJson(response.data);
        editQuoteStatus = ApiStatus.isLoaded;
      } else {
        editQuoteStatus = ApiStatus.error;
      }
    } else {
      editQuoteStatus = ApiStatus.error;
    }
    return response;
  }

  Future<Response?> fetchFavoritesFromApi() async {
    if (editQuoteStatus != ApiStatus.isLoaded) {
      editQuoteStatus = ApiStatus.isLoading;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    TokenDataModel userDt = TokenDataModel.fromJson(jsonDecode(userData ?? ''));
    Response? response = await _editQuoteServices.fetchEditQuotes(
        userDt.data.accessToken, currentPage);
    final Map<String, dynamic> decodedResponse = response.data;
    if (response != null) {
      if (response.statusCode == 200) {
        totalItems = decodedResponse['pagination']['totalItems'];
        totalPages = decodedResponse['pagination']['totalPages'];
        currentPage = decodedResponse['pagination']['currentPage'];
        hasMore = currentPage < totalPages;
        editQuoteStatus = ApiStatus.isLoaded;
      } else {
        editQuoteStatus = ApiStatus.error;
      }
    } else {
      editQuoteStatus = ApiStatus.error;
    }
    return response;
  }

  Future<void> loadMoreEditQuotes() async {
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
        editQuoteResponse.result.addAll(
          (response?.data['result'] as List<dynamic>)
              .map((item) => EditQuoteListItemDatum.fromJson(item)),
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

  ApiStatus _saveEditQuoteStatus = ApiStatus.none;

  ApiStatus get saveEditQuoteStatus => _saveEditQuoteStatus;

  set saveEditQuoteStatus(ApiStatus value) {
    _saveEditQuoteStatus = value;
    notifyListeners();
  }

  //   AddFavoriteResponse _addFavoriteResponse =
  //     AddFavoriteResponse(message: '', result: null);

  // AddFavoriteResponse get addFavoriteResponse => _addFavoriteResponse;

  // set addFavoriteResponse(AddFavoriteResponse value) {
  //   _addFavoriteResponse = value;
  //   notifyListeners();
  // }

  Future<Response?> addToEditQuotes(
      {int? editId,
      required String quote,
      required String quoteImage,
      required String imageAuthor,
      required int categoryId,
      required File quoteEditThumbnail,
      required Map<String, dynamic> quoteEditJson
      }) async {
    saveEditQuoteStatus = ApiStatus.isLoading;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    TokenDataModel userDt = TokenDataModel.fromJson(jsonDecode(userData ?? ''));
    print('----- edit post');
    Response? response = await _editQuoteServices.addQuoteToEdits(
        editId,
        quote,
        quoteImage,
        imageAuthor,
        categoryId,
        quoteEditThumbnail,
        jsonEncode(quoteEditJson),
        userDt.data.accessToken);
    print('----- favorite res $response');
    if (response != null) {
      if (response.statusCode == 200) {
        // Response response = AddFavoriteResponse.fromJson(response.data);
        saveEditQuoteStatus = ApiStatus.isLoaded;
      } else {
        saveEditQuoteStatus = ApiStatus.error;
      }
    } else {
      saveEditQuoteStatus = ApiStatus.error;
    }
    return response;
  }
}

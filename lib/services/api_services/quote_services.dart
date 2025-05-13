import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quotify/config/app_url/app_url.dart';
import 'package:quotify/services/app_services.dart';

class QuoteServices {
  final _appServices = AppServices();
  final _appUrls = AppUrls();

  Future<Response?> fetchDailyQuoteImages(
      {String? category, int? pageNumber}) async {
    pageNumber = pageNumber ?? 0 + 1;
    final searchImagesApi =
        'https://api.unsplash.com/search/photos?query=$category&page=$pageNumber&client_id=kkOV_vwnqGb5PPmMat4WjZFG-rZoKzHIK5d08cdnaiI&per_page=20';
    const listImagesApi =
        'https://api.unsplash.com/photos?client_id=kkOV_vwnqGb5PPmMat4WjZFG-rZoKzHIK5d08cdnaiI&per_page=20';
    final api = category == 'Category' ? listImagesApi : searchImagesApi;
    Response response = await _appServices.get(
      api: api,
    );
    return response;
  }

  Future<Response> fetchDailyQuoteText(
      {String? categoryId, int? pageNUmber}) async {
    if (categoryId == 'Category') {
      categoryId = '1';
    }
    Map<String, dynamic> data = {"category_id": categoryId};
    Map<String, dynamic> queryParameters = {"pageNumber": pageNUmber};

    var api = _appUrls.listQuotesUrl;
    Response response = await _appServices.get(
      api: api,
      queryParameters: queryParameters,
      data: data,
    );

    return response;
  }

  Future<Response> fetchFavorites(String? token, int pageNumber) async {
    var api = "${_appUrls.favorites}?page=$pageNumber";
    Response response = await _appServices.get(
      api: api,
      token: token ?? '',
    );

    return response;
  }

  Future<Response> addQuoteToFavorite(
      String quote, String? quoteImage,String? imageAuthor, int? categoryId) async {
    Map<String, dynamic> data = {
      "quote": quote,
      "quotes_image": quoteImage,
      "image_author": imageAuthor,
      "category_id": categoryId,
    };

    var api = _appUrls.addFavorite;
    Response response = await _appServices.post(
      api: api,
      data: data,
    );

    return response;
  }

  Future<Response> removeQuoteFromFavorite(
      String quote, String? quoteImage, int? categoryId) async {
    Map<String, dynamic> data = {
      "quote": quote,
      "quotes_image": quoteImage,
      "category_id": categoryId,
    };

    var api = _appUrls.removeFavorite;
    Response response = await _appServices.post(
      api: api,
      data: data,
    );

    return response;
  }

  Future<Response> fetchEditQuotes(String? token, int pageNumber) async {
    var api = "${_appUrls.editQuotes}?page=$pageNumber";
    Response response = await _appServices.get(
      api: api,
      token: token ?? '',
    );

    return response;
  }

  Future<Response> addQuoteToEdits(
      int? editId,
      String quote,
      String? quoteImage,
      String? imageAuthor,
      int? categoryId,
      File quoteEditThumbnail,
      String editQuoteJson,
      String token) async {
    FormData formData = FormData.fromMap({
      "editId": editId,
      "quote": quote,
      "quote_img": quoteImage,
      "image_author": imageAuthor,
      "quote_category_id": categoryId,
      "quote_edit_thumbnail": await MultipartFile.fromFile(quoteEditThumbnail.path, filename: "image.jpg"),
      "quotes_edit_json": editQuoteJson
    });

    var api = _appUrls.saveEditQuotes;
    Response response = await Dio().post(api,
        data: formData,
        options: Options(headers: <String, String>{
          'Authorization': 'Bearer $token',
        }));
    return response;
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quotify/config/app_url/app_url.dart';
import 'package:quotify/services/app_services.dart';

class CategoryServices {
  final _appServices = AppServices();
  final _appUrls = AppUrls();

  Future<Response?> fetchCategories() async {
    Response response = await _appServices.get(api: _appUrls.categories);
    return response;
  }

  Future<Response?> fetchUserCategories() async {
    Response response = await _appServices.post(api: _appUrls.userCategory);
    return response;
  }

  Future<Response?> saveUserCategories(
      {required List<Map<String, dynamic>> userCategoryLocal}) async {
    Map<String, dynamic> data = {"userSelectedCategories": userCategoryLocal};
    Response response =
        await _appServices.post(api: _appUrls.saveUserCategories, data: data);
    return response;
  }

  Future<Response?> addUserCategories(int? categoryId) async {
    Map<String, dynamic> data = {
      "category_id": categoryId,
    };
    Response response =
        await _appServices.post(api: _appUrls.addUserCategory, data: data);
    return response;
  }

  Future<Response?> removeUserCategories(int? categoryId) async {
    Map<String, dynamic> data = {
      "category_id": categoryId,
    };
    Response response =
        await _appServices.post(api: _appUrls.removeUserCategory, data: data);
    return response;
  }
}

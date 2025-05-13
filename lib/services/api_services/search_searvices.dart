import 'package:dio/dio.dart';
import 'package:quotify/config/app_url/app_url.dart';
import 'package:quotify/services/app_services.dart';

class SearchServices {
  final _appServices = AppServices();
  final _appUrls = AppUrls();

  Future<Response?> searchCategory(
      String category, int pageNumber) async {
    Map<String, dynamic> queryParameters = {'pageNumber': pageNumber};
    Map<String, dynamic> data = {'category': category};

    var searchUrl = _appUrls.search;

    Response? response = await _appServices.post(
      api: searchUrl,
      data: data,
      queryParameters: queryParameters,
    );
    return response;
  }
}

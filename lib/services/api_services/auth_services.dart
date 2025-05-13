import 'package:dio/dio.dart';
import 'package:quotify/config/app_url/app_url.dart';
import 'package:quotify/services/app_services.dart';

class AuthServices {
  final _apiServices = AppServices();
  final _appUrls = AppUrls();

  Future<Response?> login(Map<String, dynamic> data) async {
    Response? response =
        await _apiServices.post(api: _appUrls.login, data: data);
    return response;
  }
}

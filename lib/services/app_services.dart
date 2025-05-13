import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/models/token_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppServices {
  final _dio = Dio();

  Future<Response> get({
    required String api,
    Map<String, dynamic> data = const {},
    Map<String, dynamic> queryParameters = const {},
    String token = '',
  }) async {
    Map<String, dynamic>? headers = {
      'content-type': 'application/json',
      'authorization': 'Bearer $token',
    };
    try {
      Response response = await _dio.get(
        api,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  Future<Response> post({
    required String api,
    Map<String, dynamic> data = const {},
    Map<String, dynamic> queryParameters = const {},
    String token = '',
  }) async {
    print(' $api');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    if (userData != null && userData != '') {
      TokenDataModel accessToken =
          TokenDataModel.fromJson(jsonDecode(userData));
      token = accessToken.data.accessToken;
    }
    print('token ${token}');
    Map<String, dynamic>? headers = {
      'content-type': 'application/json',
      'authorization': 'Bearer $token',
    };
    try {
      print('here 4');
      Response response = await _dio.post(
        api,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      print('here 5');
      print(response);
      return response;
    } on DioException catch (e) {
      print(e.response);
      return e.response!;
    }
  }

  Future<Response> encodedPost({
    required String api,
    Map<String, dynamic> data = const {},
    Map<String, dynamic> queryParameters = const {},
    String token = '',
  }) async {
    Map<String, dynamic>? headers = {
      'content-type': 'application/x-www-form-urlencoded',
      'authorization': 'Bearer $token',
    };
    try {
      Response response = await _dio.post(
        api,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }
}

// application/x-www-form-urlencoded

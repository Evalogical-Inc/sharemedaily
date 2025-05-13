import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quotify/config/app_url/app_url.dart';
import 'package:quotify/services/app_services.dart';

class ProfileServices {
  final _appServices = AppServices();
  final _appUrls = AppUrls();

  Future<Response> getUserPorifile(String? token) async {
    var api = _appUrls.profile;
    Response response = await _appServices.get(api: api, token: token ?? '');
    return response;
  }

  Future<Response> deleteAccount(String? token,dynamic userId) async {
    var api = _appUrls.deleteAccount;
       Map<String, dynamic> data = {
      "userId": userId,
    };
    Response response = await _appServices.post(api: api,data:data , token: token ?? '');
    return response;
  }

  Future<Response> editUserPorifile(
      String? token,
      String? firstName,
      String? lastName,
      String phoneNumber,
      XFile? profileImage,
      String? bio,
      String? gender) async {
    var api = _appUrls.editProfile;
    FormData formData = FormData.fromMap({
      "profile_image": profileImage?.path != null
          ? await MultipartFile.fromFile(profileImage?.path ?? '')
          : '',
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "bio": bio,
      "gender": gender
    });
    Response response = await Dio().post(api,
        data: formData,
        options: Options(headers: <String, String>{
          'Authorization': 'Bearer $token',
        }));
    return response;
  }
}

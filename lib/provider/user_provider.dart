import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/models/token_data_model.dart';
import 'package:quotify/models/user_profile_res_model.dart';
import 'package:quotify/routes/route_names.dart';
import 'package:quotify/screens/home/home_screen.dart';
import 'package:quotify/services/api_services/profile_services.dart';
import 'package:quotify/services/sign_in_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  ProfileResModel? _userProfile = ProfileResModel();
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  ProfileResModel? get userProfile => _userProfile;

  bool _isProfileUpdating = false;
  bool get isProfileUpdating => _isProfileUpdating;

  set setProfileUpdating(bool value) {
    _isProfileUpdating = value;
    notifyListeners();
  }

  set userProfile(ProfileResModel? value) {
    _userProfile = value;
    notifyListeners();
  }

  // ProfileResModel? userProfile = userProfileData.userProfile;

  set setAuthentication(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  ApiStatus _logoutUserStatus = ApiStatus.none;

  ApiStatus get logoutUserStatus => _logoutUserStatus;

  set logoutUserStatus(ApiStatus value) {
    _logoutUserStatus = value;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    logoutUserStatus = ApiStatus.isLoading;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await SignInServices.googleLogout();
    // Future.delayed(const Duration(seconds: 1), () async {
      // Prints after 1 second.
      _isAuthenticated = false;
      _userProfile = null;
      await pref.setString(SP.tokenData, '');
      logoutUserStatus = ApiStatus.isLoaded;
    // });
  }

  Future<void> getUserPorifile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    if (userData != '' && userData != null) {
      TokenDataModel accessToken =
          TokenDataModel.fromJson(jsonDecode(userData));
      print('----- token ${accessToken.data.accessToken}');

      Response response =
          await ProfileServices().getUserPorifile(accessToken.data.accessToken);
      print('----- user dt ${response.data}');
      if (response.statusCode == 200) {
        _isAuthenticated = true;
        userProfile = ProfileResModel.fromJson(response.data);
      }
    }
  }

  ApiStatus _deleteAccountApiStatus = ApiStatus.none;

  ApiStatus get deleteAccountApiStatus => _deleteAccountApiStatus;

  set deleteAccountApiStatus(ApiStatus value) {
    _deleteAccountApiStatus = value;
    notifyListeners();
  }

  Future<Response?> deleteAccount() async {
    deleteAccountApiStatus = ApiStatus.isLoading;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    if (userData != '' && userData != null) {
      TokenDataModel accessToken =
          TokenDataModel.fromJson(jsonDecode(userData));
      print('----- token ${accessToken.data.accessToken}');

      // Future.delayed(const Duration(seconds: 5), () {
      //   // Prints after 1 second.
      //   deleteAccountApiStatus = ApiStatus.isLoaded;
      // });

      Response response = await ProfileServices()
          .deleteAccount(accessToken.data.accessToken, userProfile?.userId);
      if (response.statusCode == 200) {
        _isAuthenticated = false;
        _userProfile = null;
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString(SP.tokenData, '');
        deleteAccountApiStatus = ApiStatus.isLoaded;
        Navigator.pushAndRemoveUntil(
          scaffoldKey.currentContext!,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false, // Removes all previous routes
        );
        return response;
      } else {
        deleteAccountApiStatus = ApiStatus.error;
        final errorData = jsonDecode(jsonEncode(response.data));
        if (errorData.containsKey('message')) {
          final error = errorData['message'];
        } else {}
        return response;
      }
    }
  }

  Future<Response?> editUserPorifile(
      String firstName,
      String lastName,
      String phoneNumber,
      XFile? profileImage,
      String? bio,
      String? gender) async {
    log('----- user dt ${phoneNumber} ${bio} ${gender} ');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userData = pref.getString(SP.tokenData);
    if (userData != '' && userData != null) {
      TokenDataModel accessToken =
          TokenDataModel.fromJson(jsonDecode(userData));

      setProfileUpdating = true;
      Response response = await ProfileServices().editUserPorifile(
          accessToken.data.accessToken,
          firstName,
          lastName,
          phoneNumber,
          profileImage,
          bio,
          gender);
      if (response.statusCode == 200) {
        _isAuthenticated = true;
        userProfile = ProfileResModel.fromJson(response.data);
        setProfileUpdating = false;
        return response;
      }
    }
    setProfileUpdating = false;
    return null;
  }

  // Future<void> () async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   var userData = pref.getString(SP.tokenData);
  //   if (userData != null) {
  //     TokenDataModel accessToken = TokenDataModel.fromJson(jsonDecode(userData));
  //     print('----- user dt ${accessToken.data.accessToken}');
  //     Response response =
  //         await ProfileServices().getUserPorifile(accessToken.data.accessToken);
  //     if (response.statusCode == 200) {
  //       userProfile = ProfileResModel.fromJson(response.data);
  //     }
  //   }
  // }
}

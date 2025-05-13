import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/models/base_category_model.dart';
import 'package:quotify/models/base_user_category_model.dart';
import 'package:quotify/models/category_res_model.dart';
import 'package:quotify/models/user_category_res_model.dart';
import 'package:quotify/services/api_services/category_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider extends ChangeNotifier {
  final _categoryServices = CategoryServices();

  CategoryResponseModel _categoryResponse = CategoryResponseModel(result: []);

  CategoryResponseModel get categoryResponse => _categoryResponse;

  set categoryResponse(CategoryResponseModel value) {
    // handleUserSelectedCategory();
    _categoryResponse = value;
    notifyListeners();
  }

  List<String> _onboardCategories = [];

  List<String> get onboardCategories => _onboardCategories;

  set onboardCategories(List<String> value) {
    _onboardCategories = value;
    notifyListeners();
  }

  List<String> _defaultCategories = [];

  List<String> get defaultCategories => _defaultCategories;

  set defaultCategories(List<String> value) {
    _defaultCategories = value;
    notifyListeners();
  }

  ApiStatus _apiStatus = ApiStatus.none;

  ApiStatus get apiStatus => _apiStatus;

  set apiStatus(ApiStatus value) {
    _apiStatus = value;
    notifyListeners();
  }

  bool _seeMoreBtnInSearch = false;

  bool get seeMoreBtnInSearch => _seeMoreBtnInSearch;

  set seeMoreBtnInSearch(bool value) {
    _seeMoreBtnInSearch = value;
    notifyListeners();
  }

  bool _isCategoryUpdated = false;

  bool get isCategoryUpdated => _isCategoryUpdated;

  set isCategoryUpdated(bool value) {
    _isCategoryUpdated = value;
    notifyListeners();
  }

  ApiStatus _userCategoryStatus = ApiStatus.none;

  ApiStatus get userCategoryStatus => _userCategoryStatus;

  set userCategoryStatus(ApiStatus value) {
    _userCategoryStatus = value;
    notifyListeners();
  }

  UserCategoryResponseModel _userCategoryResponse =
      UserCategoryResponseModel(result: []);

  UserCategoryResponseModel get userCategoryResponse => _userCategoryResponse;

  set userCategoryResponse(UserCategoryResponseModel value) {
    // handleUserSelectedCategory();
    _userCategoryResponse = value;
    notifyListeners();
  }

  final List<Map<String, dynamic>> _userCategoryLocal = []; // List of maps

  List<Map<String, dynamic>> get userCategoryLocal => _userCategoryLocal;

  set userCategoryLocal(List<Map<String, dynamic>> value) {
    _userCategoryLocal.clear(); // Clear the existing list
    _userCategoryLocal.addAll(value); // Add all maps from the new list
    notifyListeners(); // Notify listeners of the change
  }

  void handleOnboardCategorySelection(int index) async {
    var id = categoryResponse.result[index].id;
    var categoryName = categoryResponse.result[index].category;
    CategoryBase category = CategoryBase(id: id, category: categoryName);
    var categoryString = jsonEncode(category);
    // if (categoryResponse.result[index].isSelected == false) {
    //   categoryResponse.result[index].isSelected = true;
    onboardCategories.add(categoryString);
    // } else {
    //   categoryResponse.result[index].isSelected = false;
    //   if (onboardCategories.contains(categoryString)) {
    //     onboardCategories.remove(categoryString);
    //   }
    // }
    if (!userCategoryLocal.any(
        (item) => item['category_id'] == categoryResponse.result[index].id)) {
      userCategoryLocal.addAll([
        {
          'category_id': categoryResponse.result[index].id,
          'category': categoryResponse.result[index].category
        }
      ]);
    } else {
      //remove user category
      userCategoryLocal.removeWhere(
          (item) => item['category_id'] == categoryResponse.result[index].id);
    }
    notifyListeners();
  }

  ApiStatus _saveUserCategoryStatus = ApiStatus.none;

  ApiStatus get saveUserCategoryStatus => _saveUserCategoryStatus;

  set saveUserCategoryStatus(ApiStatus value) {
    _saveUserCategoryStatus = value;
    notifyListeners();
  }

  saveUserSelectedCategories() async {
    log('1');
    saveUserCategoryStatus = ApiStatus.isLoading;
    Response? response = await _categoryServices.saveUserCategories(
        userCategoryLocal: userCategoryLocal);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    log('2 $response ');
    if (response != null) {
      if (response.statusCode == 200) {
        List<String>? existingData = [];
        for (var item in userCategoryLocal) {
          log('3');
          String newCategoryJson = jsonEncode(item);
          existingData.add(newCategoryJson);
        }
        await preferences.setStringList(
            SP.userSelectedCategories, existingData);
        saveUserCategoryStatus = ApiStatus.isLoaded;
      } else {
        List<String>? existingData = [];
        for (var item in userCategoryLocal) {
          log('4');
          String newCategoryJson = jsonEncode(item);
          existingData.add(newCategoryJson);
        }
        await preferences.setStringList(
            SP.userSelectedCategories, existingData);
        saveUserCategoryStatus = ApiStatus.error;
      }
    } else {
      log('5');
      // List<String>? existingData = [];
      // for (var item in userCategoryLocal) {
      //   String newCategoryJson = jsonEncode(item);
      //   existingData.add(newCategoryJson);
      // }
      // await preferences.setStringList(SP.userSelectedCategories, existingData);
      saveUserCategoryStatus = ApiStatus.isNull;
    }
  }

  handleUserSelectedCategory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userSelectedCategory =
        preferences.getStringList(SP.userSelectedCategories);

    if (userSelectedCategory != null) {
      for (var item in categoryResponse.result) {
        CategoryBase category =
            CategoryBase(id: item.id, category: item.category);
        if (userSelectedCategory.contains(jsonEncode(category))) {
          item.isSelected = true;
          notifyListeners();
        }
      }
    }
  }

  Future<Response?> fetchCategories() async {
    print('------= fetch categories');
    apiStatus = ApiStatus.isLoading;
    Response? response = await _categoryServices.fetchCategories();
    if (response != null) {
      if (response.statusCode == 200) {
        categoryResponse = CategoryResponseModel.fromJson(response.data);
        for (var item in categoryResponse.result) {
          UserCategoryBase category =
              UserCategoryBase(categoryId: item.id, category: item.category);
          defaultCategories.add(jsonEncode(category));
        }
        apiStatus = ApiStatus.isLoaded;
      } else {
        apiStatus = ApiStatus.error;
      }
    } else {
      apiStatus = ApiStatus.error;
    }
    return response;
  }

  Future<Response?> fetchUserCategories() async {
    userCategoryStatus = ApiStatus.isLoading;
    Response? response = await _categoryServices.fetchUserCategories();
    if (response != null) {
      if (response.statusCode == 200) {
        userCategoryResponse =
            UserCategoryResponseModel.fromJson(response.data);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setStringList(SP.userSelectedCategories, []);

        List<String>? existingData =
            preferences.getStringList(SP.userSelectedCategories) ?? [];

        for (var item in userCategoryResponse.result) {
          // Retrieve the existing array or initialize an empty list

          // Create the new object to add
          UserCategoryBase newCategory = UserCategoryBase(
              category: item.category, categoryId: item.categoryId);

          // Convert the new object to a JSON string
          String newCategoryJson = jsonEncode(newCategory);

          // Add the new object to the list
          existingData.add(newCategoryJson);

          // Save the updated list back to SharedPreferences
        }

        await preferences.setStringList(
            SP.userSelectedCategories, existingData);

        print("Updated userSelectedCategories: $existingData");

        // Retrieve the existing array or initialize an empty array
        existingData = preferences.getStringList(SP.userSelectedCategories);
        // log(existingData.toString());

        if (existingData != null) {
          userCategoryLocal = existingData.map((jsonString) {
            log(jsonDecode(jsonString).toString());
            return jsonDecode(jsonString) as Map<String, dynamic>;
          }).toList();
        } else {
          userCategoryLocal = [];
        }

        userCategoryStatus = ApiStatus.isLoaded;
      } else {
        userCategoryStatus = ApiStatus.error;
      }
    } else {
      userCategoryStatus = ApiStatus.error;
    }
    return response;
  }

  Future<Response?> addUserCategories({required int categoryId}) async {
    userCategoryStatus = ApiStatus.isLoading;
    Response? response = await _categoryServices.addUserCategories(categoryId);
    if (response != null) {
      if (response.statusCode == 200) {
        userCategoryResponse =
            UserCategoryResponseModel.fromJson(response.data);
        // for (var item in categoryResponse.result) {
        //   CategoryBase category =
        //       CategoryBase(id: item.id, category: item.category);
        //   defaultCategories.add(jsonEncode(category));
        // }
        userCategoryStatus = ApiStatus.isLoaded;
      } else {
        userCategoryStatus = ApiStatus.error;
      }
    } else {
      userCategoryStatus = ApiStatus.error;
    }
    return response;
  }

  Future<Response?> removeUserCategories({required int categoryId}) async {
    userCategoryStatus = ApiStatus.isLoading;
    Response? response =
        await _categoryServices.removeUserCategories(categoryId);
    if (response != null) {
      if (response.statusCode == 200) {
        userCategoryResponse =
            UserCategoryResponseModel.fromJson(response.data);
        // for (var item in categoryResponse.result) {
        //   CategoryBase category =
        //       CategoryBase(id: item.id, category: item.category);
        //   defaultCategories.add(jsonEncode(category));
        // }
        userCategoryStatus = ApiStatus.isLoaded;
      } else {
        userCategoryStatus = ApiStatus.error;
      }
    } else {
      userCategoryStatus = ApiStatus.error;
    }
    return response;
  }
}

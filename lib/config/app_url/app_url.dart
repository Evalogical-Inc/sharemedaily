import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls {
  String? get baseUrl => dotenv.env['BASE_URL'];
  // String? get baseUrl => dotenv.env['BASE_URL_LOCAL_PHYSICAL_DEVICE'];

  String get login => '${baseUrl!}/v1/auth/user-login';
  String get listQuotesUrl => '${baseUrl!}/v1/quote';
  String get categories => '${baseUrl!}/v1/categories';
  String get search => '${baseUrl!}/v1/search';
  String get profile => '${baseUrl!}/v1/user/profile';
  String get deleteAccount => '${baseUrl!}/v1/user/delete-Account';
  String get editProfile => '${baseUrl!}/v1/user/edit-profile';
  String get favorites => '${baseUrl!}/v1/quote/favorites';
  String get editQuotes => '${baseUrl!}/v1/quote/quote-edits';
  String get saveEditQuotes => '${baseUrl!}/v1/quote/edit-quote';
  String get addFavorite => '${baseUrl!}/v1/quote/add-favorite';
  String get removeFavorite => '${baseUrl!}/v1/quote/remove-favorite';
  String get userCategory => '${baseUrl!}/v1/categories/user-category';
  String get saveUserCategories => '${baseUrl!}/v1/categories/save-user-categories';
  String get addUserCategory => '${baseUrl!}/v1/categories/add-user-category';
  String get removeUserCategory =>
      '${baseUrl!}/v1/categories/remove-user-category';
}

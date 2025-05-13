import 'package:quotify/config/SP/sp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  Future<bool?> isUserOnboarded() async {
    final sp = await preferences;
    bool? isOnborded = sp.getBool(SP.isOnBorded);
    return isOnborded;
  }

  Future<bool> setIsDarkMode(String val) async {
    final sp = await preferences;
    bool isDarkMode = await sp.setString(SP.theMode, val);
    return isDarkMode;
  }

  Future<String?> getThemeMode() async {
    final sp = await preferences;
    String? isDarkMode = sp.getString(SP.theMode);
    return isDarkMode;
  }

  Future<bool> setTokenData(String tokenData) async {
    final sp = await preferences;
    bool isTokenDataSet = await sp.setString(SP.tokenData, tokenData);
    return isTokenDataSet;
  }

  Future<String?> getTokenData() async {
    final sp = await preferences;
    String? tokenData = sp.getString(SP.tokenData);
    return tokenData;
  }
  
}

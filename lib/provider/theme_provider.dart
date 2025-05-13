import 'package:flutter/material.dart';

class ThemeProvier extends ChangeNotifier {
  
  ThemeMode _themeMode = ThemeMode.system;

  get themeMode => _themeMode;

  toggleTheme(ThemeMode mode) {
    _themeMode =  mode;
    notifyListeners();
  }

   bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  Brightness _brightness = Brightness.light;

  Brightness get brightness => _brightness;

  set brightness(Brightness value) {
    _brightness = value;
    isDarkMode = _brightness == Brightness.dark ? true : false;
    notifyListeners();
    
  }

 

  
}

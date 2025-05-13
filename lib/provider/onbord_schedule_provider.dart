import 'package:flutter/material.dart';

class OnboardScheduleProvider extends ChangeNotifier {
  bool _isWhoeWeekSelected = false;

  bool get isWhoeWeekSelected => _isWhoeWeekSelected;

  set isWhoeWeekSelected(bool value) {
    _isWhoeWeekSelected = value;
    notifyListeners();
  }

  bool _isWhoeMonthSelected = false;

  bool get isWhoeMonthSelected => _isWhoeMonthSelected;

  set isWhoeMonthSelected(bool value) {
    _isWhoeMonthSelected = value;
    notifyListeners();
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quotify/config/SP/sp.dart';
import 'package:quotify/config/constants/enums/api_status.dart';
import 'package:quotify/services/api_services/auth_services.dart';

class LoginProvider extends ChangeNotifier {
  final authServices = AuthServices();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<Response?> login(Map<String, dynamic> data) async {
    Response? response = await authServices.login(data);
    return response;
  }
}

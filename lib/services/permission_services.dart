import 'package:permission_handler/permission_handler.dart';

class PermissionServices {
  static Future<bool> checkPermission({required Permission permission}) async {
    final status = await permission.request().isGranted;
    return status;
  }

  static Future<PermissionStatus> requestPermission(
      {required Permission permission}) async {
    final status = await permission.request();
    return status;
  }
}

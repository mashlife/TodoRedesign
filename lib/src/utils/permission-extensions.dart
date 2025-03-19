import 'package:permission_handler/permission_handler.dart';

class PermissionExtensions {
  static Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}

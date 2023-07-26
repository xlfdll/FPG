import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' show window;

class PlatformHelper {
  static bool isWeb() {
    return kIsWeb;
  }

  static bool isCameraAvailable() {
    return kIsWeb || Platform.isAndroid || Platform.isIOS;
  }

  static bool isNFCAvailable() {
    return Platform.isAndroid || Platform.isIOS;
  }

  static Future<bool> isCameraPermissionGranted() async {
    if (!isWeb()) {
      final status = await Permission.camera.status;

      return status.isGranted;
    } else {
      final status =
          await window.navigator.permissions?.query({"name": "camera"});

      return status?.state == "granted";
    }
  }
}

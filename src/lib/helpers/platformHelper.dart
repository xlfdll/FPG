import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' show window;

class PlatformHelper {
  static bool isWeb() {
    return kIsWeb;
  }

  static bool isCameraAvailable() {
    return kIsWeb || Platform.isAndroid || Platform.isIOS;
  }

  static Future<bool> isNFCAvailable() async {
    if (isWeb()) {
      return false;
    }

    return (Platform.isAndroid || Platform.isIOS) && await NfcManager.instance.isAvailable();
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

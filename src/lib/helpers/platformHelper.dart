import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformHelper {
  static bool isWeb() {
    return kIsWeb;
  }

  static bool isSensorAvailable() {
    return kIsWeb || Platform.isAndroid || Platform.isIOS;
  }
}

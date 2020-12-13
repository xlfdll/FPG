import 'dart:math';

import 'package:fpg_mobile/core/interfaces/ISaltGenerationAlgorithm.dart';

class WPSaltGenerationAlgorithm implements ISaltGenerationAlgorithm {
  int length = 64;

  @override
  String generate() {
    Random random = Random();
    StringBuffer sb = StringBuffer();

    for (int i = 0; i < length; i++) {
      int r = random.nextInt(_characters.length - 1);
      sb.write(_characters.substring(r, r + 1));
    }

    return sb.toString();
  }

  static const String _characters =
      r"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_ []{}<>~`+=,.;:/?|";
}

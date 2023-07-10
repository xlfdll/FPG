import 'package:flutter/material.dart';

class UIHelper {
  static bool isPhoneScreen(context) {
    return MediaQuery.of(context).size.width < 600;
  }
}

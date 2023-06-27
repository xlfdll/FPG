import 'package:flutter/material.dart';

class FormFactor {
  static bool isHandset(context) {
    return MediaQuery.of(context).size.width < 600;
  }
}

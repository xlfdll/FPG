// Cant't use _kLinearProgressIndicatorHeight 'cause it is private in the
// progress_indicator.dart file
import 'package:flutter/material.dart';

const double _kMyLinearProgressIndicatorHeight = 3.0;

class AppBarLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  AppBarLinearProgressIndicator({
    Key? key,
    double? value,
    Color? backgroundColor,
    Animation<Color?>? valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        ) {
    preferredSize = Size(double.infinity, _kMyLinearProgressIndicatorHeight);
  }

  @override
  late Size preferredSize;
}

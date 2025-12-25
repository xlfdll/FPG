import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg/constants.dart';

class UIHelper {
  static void showMessage(BuildContext context, String message, {bool showDismissButton = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();

    double? snackBarWidth;

    if (MediaQuery.of(context).size.width > UIConstants.MediumScreenWidthBreakpoint) {
      snackBarWidth = MediaQuery.of(context).size.width * 0.3;
    } else if (MediaQuery.of(context).size.width > UIConstants.SmallScreenWidthBreakpoint) {
      snackBarWidth = MediaQuery.of(context).size.width * 0.5;
    } else {
      snackBarWidth = null;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      width: snackBarWidth,
      action: showDismissButton
          ? SnackBarAction(
              label: AppLocalizations.of(context)!.dismiss,
              textColor: Theme.of(context).colorScheme.inversePrimary,
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            )
          : null,
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg/constants.dart';

class UIHelper {
  static void showMessage(BuildContext context, String message,
      {bool showDismissButton = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      width:
          MediaQuery.of(context).size.width >= UIConstants.ScreenWidthBreakpoint
              ? MediaQuery.of(context).size.width * 0.5
              : null,
      action: showDismissButton
          ? SnackBarAction(
              label: AppLocalizations.of(context)!.dismiss,
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            )
          : null,
    ));
  }
}

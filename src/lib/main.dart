import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg/core/AlgorithmSet.dart';
import 'package:fpg/pages/mainPage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  static final AlgorithmSet algorithmSet = AlgorithmSet.create("default");

  // TODO: platform-specific screens
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Fkulc's Password Generator",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // The following localization delegates must follow generated AppLocalizations class comments
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        // Use explicit locale list here to generate corresponding AppLocalizations code properly
        supportedLocales: [const Locale("en", "")],
        home: MainPage());
  }
}

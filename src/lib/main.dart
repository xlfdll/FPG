import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg/core/AlgorithmSet.dart';
import 'package:fpg/pages/mainPage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  static final algorithmSet = AlgorithmSet.create("default");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Fkulc's Password Generator",
        theme: ThemeData.light().copyWith(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme.light(
                primary: Colors.blue, secondary: Colors.blue, onSecondary: Colors.white, inversePrimary: Colors.orange),
            appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
            progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.orange, linearTrackColor: Colors.blue)),
        darkTheme: ThemeData.dark().copyWith(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme.dark(
                primary: Colors.blue, secondary: Colors.blue, onSecondary: Colors.white, inversePrimary: Colors.orange),
            appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
            progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.orange, linearTrackColor: Colors.blue)),
        themeMode: ThemeMode.system,
        // The following localization delegates must follow generated AppLocalizations class comments
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        // Use explicit locale list here to generate corresponding AppLocalizations code properly
        supportedLocales: [const Locale("en", "")],
        home: MainPage());
  }
}

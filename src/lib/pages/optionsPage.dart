import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg/constants.dart';
import 'package:fpg/helpers/passwordHelper.dart';
import 'package:fpg/helpers/platformHelper.dart';
import 'package:fpg/helpers/uiHelper.dart';
import 'package:fpg/main.dart';
import 'package:fpg/settings.dart';

class OptionsPage extends StatefulWidget {
  OptionsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final symbolCandidatesTextInputController = TextEditingController();
  final randomSaltTextInputController = TextEditingController();

  bool? autoCopyPassword = true;
  bool? rememberUserSalt = true;

  Future<void> initSettings() async {
    autoCopyPassword = await Settings.getAutoCopyPasswordSwitch();
    rememberUserSalt = await Settings.getRememberUserSaltSwitch();

    setState(() {});
  }

  Future<void> showEditSymbolCandidatesDialog() async {
    symbolCandidatesTextInputController.text =
        (await Settings.getSpecialSymbols()) ?? "";

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(context)!.editSymbolCandidatesOptionTitle),
            content: TextField(
              controller: symbolCandidatesTextInputController,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                  icon: Icon(Icons.keyboard),
                  hintText: AppLocalizations.of(context)!
                      .editSymbolCandidatesHintText,
                  helperText: AppLocalizations.of(context)!
                      .editSymbolCandidatesHelperText),
            ),
            actions: [
              TextButton(
                  child: Text(AppLocalizations.of(context)!.useDefault),
                  onPressed: () {
                    symbolCandidatesTextInputController.text =
                        AppConstants.DefaultSpecialSymbols;
                  }),
              TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  }),
              TextButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () {
                    Settings.setSpecialSymbols(
                            symbolCandidatesTextInputController.text)
                        .then((value) {
                      Navigator.of(dialogContext).pop();
                    });
                  }),
            ],
          );
        });
  }

  Future<void> showEditRandomSaltDialog() async {
    randomSaltTextInputController.text = (await Settings.getRandomSalt()) ?? "";

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title:
                Text(AppLocalizations.of(context)!.editRandomSaltOptionTitle),
            content: TextField(
              controller: randomSaltTextInputController,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                  icon: Icon(Icons.security),
                  hintText: AppLocalizations.of(context)!.randomSaltHintText,
                  helperText:
                      AppLocalizations.of(context)!.randomSaltOptionsHeader),
            ),
            actions: [
              TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();

                    randomSaltTextInputController.text = "";
                  }),
              TextButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () {
                    Settings.setRandomSalt(randomSaltTextInputController.text)
                        .then((value) {
                      Navigator.of(dialogContext).pop();

                      randomSaltTextInputController.text = "";
                    });
                  }),
            ],
          );
        });
  }

  void generateRandomSalt() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.warning),
            content: Text(AppLocalizations.of(context)!.randomSaltChangePrompt),
            actions: [
              TextButton(
                  child: Text(AppLocalizations.of(context)!.no),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  }),
              TextButton(
                  child: Text(AppLocalizations.of(context)!.yes),
                  onPressed: () {
                    PasswordHelper.generateRandomSalt().then((value) {
                      UIHelper.showMessage(
                          context,
                          AppLocalizations.of(context)!
                              .randomSaltGeneratedMessage);
                    });

                    Navigator.of(dialogContext).pop();
                  }),
            ],
          );
        });
  }

  void backupCriticalSettings() {
    PasswordHelper.backupCriticalSettings().then((value) {
      UIHelper.showMessage(
          context,
          AppLocalizations.of(context)!
              .backupCriticalSettingsCompletedMessage
              .replaceAll("%s", AppConstants.CriticalSettingsBackupFileName));
    }).catchError((e) {
      UIHelper.showMessage(
          context, AppLocalizations.of(context)!.exception + e.toString());
    });
  }

  Future<void> restoreCriticalSettings() async {
    if (await PasswordHelper.checkCriticalSettings()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.warning),
              content:
                  Text(AppLocalizations.of(context)!.randomSaltChangePrompt),
              actions: [
                TextButton(
                    child: Text(AppLocalizations.of(context)!.no),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    }),
                TextButton(
                    child: Text(AppLocalizations.of(context)!.yes),
                    onPressed: () {
                      PasswordHelper.restoreCriticalSettings().then((value) {
                        UIHelper.showMessage(
                            context,
                            !PlatformHelper.isWeb()
                                ? AppLocalizations.of(context)!
                                    .restoreCriticalSettingsCompletedMessage
                                    .replaceAll(
                                        "%s",
                                        AppConstants
                                            .CriticalSettingsBackupFileName)
                                : AppLocalizations.of(context)!
                                    .restoreCriticalSettingsCompletedMessageWeb);
                      }).catchError((e) {
                        UIHelper.showMessage(
                            context,
                            AppLocalizations.of(context)!.exception +
                                e.toString());
                      });

                      Navigator.of(dialogContext).pop();
                    }),
              ],
            );
          });
    } else {
      UIHelper.showMessage(
          context,
          AppLocalizations.of(context)!
              .restoreCriticalSettingsNotFoundMessage
              .replaceAll("%s", AppConstants.CriticalSettingsBackupFileName));
    }
  }

  @override
  void initState() {
    super.initState();

    initSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Use ScaffoldKey to get access to APIs for things like Snackbar
        key: scaffoldKey,
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.options)),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: ListView(children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.generalOptionsHeader,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SwitchListTile(
                  title: Text(AppLocalizations.of(context)!
                      .autoCopyPasswordOptionTitle),
                  value: autoCopyPassword!,
                  onChanged: (value) {
                    setState(() {
                      // Update status locally due to async function limitations
                      autoCopyPassword = value;

                      Settings.setAutoCopyPasswordSwitch(value);
                    });
                  }),
              SwitchListTile(
                  title: Text(AppLocalizations.of(context)!
                      .rememberLastSaltOptionTitle),
                  value: rememberUserSalt!,
                  onChanged: (value) {
                    setState(() {
                      rememberUserSalt = value;

                      Settings.setRememberUserSaltSwitch(value);

                      if (!value) {
                        Settings.setUserSalt("");
                      }
                    });
                  }),
              ListTile(
                title: Text(AppLocalizations.of(context)!
                    .editSymbolCandidatesOptionTitle),
                onTap: showEditSymbolCandidatesDialog,
              ),
              Divider(),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.randomSaltOptionsHeader,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context)!.editRandomSaltOptionTitle),
                onTap: showEditRandomSaltDialog,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!
                    .generateRandomSaltOptionTitle),
                onTap: generateRandomSalt,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!
                    .backupCriticalSettingsOptionTitle),
                subtitle: !PlatformHelper.isWeb()
                    ? Text(AppLocalizations.of(context)!
                        .backupCriticalSettingsOptionSubtitle
                        .replaceAll(
                            "%s", AppConstants.CriticalSettingsBackupFileName))
                    : Text(AppLocalizations.of(context)!
                        .backupCriticalSettingsOptionSubtitleWeb
                        .replaceAll(
                            "%s", AppConstants.CriticalSettingsBackupFileName)),
                onTap: backupCriticalSettings,
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!
                    .restoreCriticalSettingsOptionTitle),
                subtitle: !PlatformHelper.isWeb()
                    ? Text(AppLocalizations.of(context)!
                        .restoreCriticalSettingsOptionSubtitle
                        .replaceAll(
                            "%s", AppConstants.CriticalSettingsBackupFileName))
                    : Text(AppLocalizations.of(context)!
                        .restoreCriticalSettingsOptionSubtitleWeb),
                onTap: restoreCriticalSettings,
              )
            ])));
  }
}

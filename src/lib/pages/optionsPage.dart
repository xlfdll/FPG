import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg/constants.dart';
import 'package:fpg/helpers/passwordHelper.dart';
import 'package:fpg/helpers/platformHelper.dart';
import 'package:fpg/helpers/uiHelper.dart';
import 'package:fpg/settings.dart';
import 'package:numberpicker/numberpicker.dart';

class OptionsPage extends StatefulWidget {
  OptionsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final symbolCandidatesTextInputController = TextEditingController();
  final randomSaltTextInputController = TextEditingController();

  bool? autoCopyPassword = PreferenceDefaults.AutoCopyPassword;
  bool? rememberUserSalt = PreferenceDefaults.RememberUserSalt;
  bool? showPassword = PreferenceDefaults.ShowPassword;
  bool? autoClearPassword = PreferenceDefaults.AutoClearPassword;
  int passwordClearTime = PreferenceDefaults.PasswordClearTime;

  Future<void> initSettings() async {
    autoCopyPassword = await Settings.getAutoCopyPasswordSwitch();
    rememberUserSalt = await Settings.getRememberUserSaltSwitch();
    showPassword = await Settings.getShowPasswordSwitch();
    autoClearPassword = await Settings.getAutoClearPasswordSwitch();
    passwordClearTime = await Settings.getPasswordClearTime() ??
        PreferenceDefaults.PasswordClearTime;

    setState(() {});
  }

  Future<void> showPasswordClearTimeDialog() async {
    await showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context)!
                  .setPasswordClearTimeOptionTitle),
              content: StatefulBuilder(
                builder: (statefulBuilderContext, setState) {
                  return NumberPicker(
                    value: passwordClearTime ~/ 1000,
                    minValue: 5,
                    maxValue: 300,
                    step: 1,
                    onChanged: (value) {
                      setState(() {
                        passwordClearTime = value * 1000;

                        Settings.setPasswordClearTime(passwordClearTime);
                      });
                    },
                  );
                },
              ),
              actions: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(passwordClearTime),
                )
              ]);
        });
  }

  Future<void> showEditSymbolCandidatesDialog() async {
    symbolCandidatesTextInputController.text =
        (await Settings.getSpecialSymbols()) ??
            PreferenceDefaults.SpecialSymbols;

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
              textInputAction: TextInputAction.done,
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
                        PreferenceDefaults.SpecialSymbols;
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
              textInputAction: TextInputAction.done,
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

  Future<void> generateRandomSalt() async {
    await showDialog(
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

  Future<void> backupCriticalSettings() async {
    try {
      await PasswordHelper.backupCriticalSettings();

      UIHelper.showMessage(
          context,
          AppLocalizations.of(context)!
              .backupCriticalSettingsCompletedMessage
              .replaceAll("%s", AppConstants.CriticalSettingsBackupFileName));
    } catch (e) {
      UIHelper.showMessage(
          context, AppLocalizations.of(context)!.exception + e.toString());
    }
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
    final headerTextStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.bold);

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
                  style: headerTextStyle,
                ),
              ),
              SwitchListTile(
                  title: Text(AppLocalizations.of(context)!
                      .autoCopyPasswordOptionTitle),
                  value: autoCopyPassword!,
                  onChanged: !showPassword!
                      ? null
                      : (value) {
                          setState(() {
                            // Update status locally due to async function limitations
                            autoCopyPassword = value;

                            Settings.setAutoCopyPasswordSwitch(value);

                            if (!value) {
                              showPassword = true;

                              Settings.setShowPasswordSwitch(true);
                            }
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
                AppLocalizations.of(context)!.userInterfaceOptionsHeader,
                style: headerTextStyle,
              )),
              SwitchListTile(
                  title: Text(
                      AppLocalizations.of(context)!.showPasswordOptionTitle),
                  value: showPassword!,
                  onChanged: !autoCopyPassword!
                      ? null
                      : (value) {
                          setState(() {
                            // Update status locally due to async function limitations
                            showPassword = value;

                            Settings.setShowPasswordSwitch(value);

                            if (!value) {
                              autoCopyPassword = true;

                              Settings.setAutoCopyPasswordSwitch(true);
                            }
                          });
                        }),
              SwitchListTile(
                  title: Text(AppLocalizations.of(context)!
                      .autoClearPasswordOptionTitle),
                  value: autoClearPassword!,
                  onChanged: !showPassword!
                      ? null
                      : (value) {
                          setState(() {
                            // Update status locally due to async function limitations
                            autoClearPassword = value;

                            Settings.setAutoClearPasswordSwitch(value);
                          });
                        }),
              ListTile(
                title: Text(AppLocalizations.of(context)!
                    .setPasswordClearTimeOptionTitle),
                enabled: autoClearPassword!,
                onTap: showPasswordClearTimeDialog,
              ),
              Divider(),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.randomSaltOptionsHeader,
                  style: headerTextStyle,
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

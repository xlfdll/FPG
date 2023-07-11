import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg/constants.dart';
import 'package:fpg/helpers/passwordHelper.dart';
import 'package:fpg/pages/optionsPage.dart';
import 'package:fpg/settings.dart';
import 'package:numberpicker/numberpicker.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final keywordTextInputController = TextEditingController();
  final saltTextInputController = TextEditingController();
  final lengthTextInputController = TextEditingController();

  bool? insertSymbols = true;
  String password = "";

  bool isPasswordSectionVisible = false;

  Future<void> initSettings() async {
    if (await Settings.getRememberUserSaltSwitch() == true) {
      saltTextInputController.text = await (Settings.getUserSalt()) ?? "";
    }

    lengthTextInputController.text =
        (await Settings.getPasswordLength() ?? 16).toString();

    insertSymbols = await Settings.getInsertSpecialSymbolsSwitch();

    setState(() {});
  }

  Future<void> showFirstTimeWelcomeDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.firstRunDialogTitle),
            content: Text(AppLocalizations.of(context)!.firstRunDialogMessage),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void showPasswordLengthDialog() {
    int length = int.parse(lengthTextInputController.text);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context)!.setLengthTitle),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return NumberPicker(
                    value: length,
                    minValue: 4,
                    maxValue: 64,
                    step: 1,
                    onChanged: (value) {
                      setState(() {
                        length = value;
                      });
                    },
                  );
                },
              ),
              actions: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () => Navigator.of(context).pop(length),
                )
              ]);
        }).then((value) {
      if (value != null) {
        setState(() {
          lengthTextInputController.text = value.toString();
        });
      }
    });
  }

  void generatePassword() {
    if (keywordTextInputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.keywordEmptyMessage)));
    } else if (saltTextInputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.saltEmptyMessage)));
    } else {
      int passwordLength = int.parse(lengthTextInputController.text);

      PasswordHelper.generatePassword(keywordTextInputController.text,
              saltTextInputController.text, passwordLength, insertSymbols!)
          .then((value) {
        setState(() {
          password = value;
          isPasswordSectionVisible = true;

          Settings.getAutoCopyPasswordSwitch().then((v) {
            if (v!) {
              Clipboard.setData(ClipboardData(text: value));
            }
          });
          Settings.getRememberUserSaltSwitch().then((v) {
            Settings.setUserSalt(v! ? saltTextInputController.text : "");
          });
          Settings.setPasswordLength(passwordLength);
          Settings.setInsertSpecialSymbolsSwitch(insertSymbols!);
        });
      });
    }
  }

  void clearInput() {
    setState(() {
      keywordTextInputController.text = "";

      Settings.getRememberUserSaltSwitch().then((value) {
        if (!value!) {
          saltTextInputController.text = "";
        }
      });

      password = "";
      isPasswordSectionVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();

    Settings.initialize().then((value) {
      initSettings();

      if (value) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await showFirstTimeWelcomeDialog();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final saltTextInput = TextField(
      controller: saltTextInputController,
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
          icon: Icon(Icons.security),
          hintText: AppLocalizations.of(context)!.saltHintText,
          helperText: AppLocalizations.of(context)!.saltHelperText),
    );
    final lengthTextInput = TextField(
      readOnly: true,
      controller: lengthTextInputController,
      decoration: InputDecoration(
          icon: Icon(Icons.input),
          helperText: AppLocalizations.of(context)!.lengthHelperText),
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      onTap: showPasswordLengthDialog,
    );
    final insertSymbolsCheckBox = CheckboxListTile(
        title: Text(AppLocalizations.of(context)!.symbolSwitchTitle),
        controlAffinity: ListTileControlAffinity.leading,
        value: insertSymbols,
        onChanged: (value) {
          // setState() to notify UI changes
          setState(() {
            insertSymbols = value;
          });
        });

    return Scaffold(
      // Use ScaffoldKey to get access to APIs for things like Snackbar
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context)!.options,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OptionsPage()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.vpn_key),
          tooltip: AppLocalizations.of(context)!.generatePasswordTooltip,
          onPressed: generatePassword),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: keywordTextInputController,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                        icon: Icon(Icons.text_fields),
                        hintText: AppLocalizations.of(context)!.keywordHintText,
                        helperText:
                            AppLocalizations.of(context)!.keywordHelperText),
                  ),
                  constraints.maxWidth < UIConstants.ScreenWidthBreakpoint
                      ? Column(
                          children: [
                            saltTextInput,
                            Row(
                              children: [
                                Expanded(child: lengthTextInput),
                                Container(
                                    width: 200, child: insertSymbolsCheckBox)
                              ],
                            )
                          ],
                        )
                      : Row(
                          children: [
                            // Must use containers for child widgets as no inherited width is set
                            Expanded(child: saltTextInput),
                            Container(width: 200, child: lengthTextInput),
                            Container(width: 200, child: insertSymbolsCheckBox)
                          ],
                        ),
                  Visibility(
                      visible: isPasswordSectionVisible,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 9,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: GestureDetector(
                                  child: FittedBox(
                                      child: Text(password,
                                          style: TextStyle(fontSize: 32))),
                                  onDoubleTap: () {
                                    Clipboard.setData(
                                            ClipboardData(text: password))
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  AppLocalizations.of(context)!
                                                      .passwordCopiedMessage)));
                                    });
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                                child: IconButton(
                              icon: const Icon(Icons.clear),
                              tooltip: AppLocalizations.of(context)!.clear,
                              onPressed: clearInput,
                            ))
                          ]))
                ],
              ),
            ),
          );
        },
      ),
      // body: SingleChildScrollView(
      //   child:
      // ),
    );
  }
}

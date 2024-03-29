import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:numberpicker/numberpicker.dart';

import 'package:fpg/components/CountdownTimer.dart';
import 'package:fpg/constants.dart';
import 'package:fpg/helpers/passwordHelper.dart';
import 'package:fpg/helpers/uiHelper.dart';
import 'package:fpg/pages/optionsPage.dart';
import 'package:fpg/settings.dart';
import 'package:fpg/widgets/AppBarLinearProgressIndicator.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final keywordTextInputController = TextEditingController();
  final saltTextInputController = TextEditingController();
  final lengthTextInputController = TextEditingController();

  late FocusNode keywordTextInputFocusNode;
  late FocusNode saltTextInputFocusNode;

  bool? insertSpecialSymbols = PreferenceDefaults.InsertSpecialSymbols;

  String password = "";
  bool isPasswordSectionVisible = false;

  late CountdownStopTimer passwordClearTimer;
  int passwordClearTime = PreferenceDefaults.PasswordClearTime;
  int remainingPasswordClearTime = 0;

  Future<void> initSettings() async {
    if (await Settings.getRememberUserSaltSwitch() == true) {
      saltTextInputController.text = await (Settings.getUserSalt()) ?? PreferenceDefaults.UserSalt;
    }

    lengthTextInputController.text =
        (await Settings.getPasswordLength() ?? PreferenceDefaults.PasswordLength).toString();

    insertSpecialSymbols = await Settings.getInsertSpecialSymbolsSwitch();

    passwordClearTime = await Settings.getPasswordClearTime() ?? PreferenceDefaults.PasswordClearTime;
    passwordClearTimer = CountdownStopTimer(passwordClearTime, () {
      setState(() {
        remainingPasswordClearTime = passwordClearTimer.remainingTime;
      });
    }, () {
      this.clearInput();

      setState(() {
        remainingPasswordClearTime = 0;
      });
    });

    setState(() {});
  }

  Future<void> showFirstTimeWelcomeDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.firstRunDialogTitle),
            content: Text(AppLocalizations.of(context)!.firstRunDialogMessage),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> showPasswordLengthDialog() async {
    ScaffoldMessenger.of(context).clearSnackBars();

    int length = int.parse(lengthTextInputController.text);
    int? result = await showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context)!.setLengthTitle),
              content: StatefulBuilder(
                builder: (statefulBuilderContext, setState) {
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
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () => Navigator.of(dialogContext).pop(length),
                )
              ]);
        });

    if (result != null) {
      setState(() {
        lengthTextInputController.text = result.toString();
      });
    }
  }

  void generatePassword() {
    if (keywordTextInputController.text.isEmpty) {
      UIHelper.showMessage(context, AppLocalizations.of(context)!.keywordEmptyMessage);

      keywordTextInputFocusNode.requestFocus();
    } else if (saltTextInputController.text.isEmpty) {
      UIHelper.showMessage(context, AppLocalizations.of(context)!.saltEmptyMessage);

      saltTextInputFocusNode.requestFocus();
    } else {
      int passwordLength = int.parse(lengthTextInputController.text);

      PasswordHelper.generatePassword(
              keywordTextInputController.text, saltTextInputController.text, passwordLength, insertSpecialSymbols!)
          .then((value) {
        setState(() {
          FocusManager.instance.primaryFocus?.unfocus();

          Settings.getShowPasswordSwitch().then((v) {
            if (v!) {
              password = value;
              isPasswordSectionVisible = true;

              Settings.getAutoClearPasswordSwitch().then((v) {
                if (v!) {
                  stopPasswordClearTimer();
                  startPasswordClearTimer();
                }
              });
            }
          });

          Settings.getAutoCopyPasswordSwitch().then((v) {
            if (v!) {
              Clipboard.setData(ClipboardData(text: value));

              UIHelper.showMessage(context, AppLocalizations.of(context)!.passwordCopiedMessage);
            }
          });
          Settings.getRememberUserSaltSwitch().then((v) {
            Settings.setUserSalt(v! ? saltTextInputController.text : "");
          });
          Settings.setPasswordLength(passwordLength);
          Settings.setInsertSpecialSymbolsSwitch(insertSpecialSymbols!);
        });
      });
    }
  }

  void clearInput() {
    stopPasswordClearTimer();

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

  Future<void> startPasswordClearTimer() async {
    passwordClearTime = await Settings.getPasswordClearTime() ?? PreferenceDefaults.PasswordClearTime;
    passwordClearTimer.period = passwordClearTime;
    passwordClearTimer.reset();
    passwordClearTimer.start();
  }

  void stopPasswordClearTimer() {
    passwordClearTimer.stop();

    setState(() {
      remainingPasswordClearTime = 0;
    });
  }

  @override
  void dispose() {
    passwordClearTimer.stop();

    // Unregister lifecycle handling
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    keywordTextInputFocusNode = FocusNode();
    saltTextInputFocusNode = FocusNode();

    // Register lifecycle handling
    WidgetsBinding.instance.addObserver(this);

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      this.stopPasswordClearTimer();
      this.clearInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    final saltTextInput = TextField(
      controller: saltTextInputController,
      focusNode: saltTextInputFocusNode,
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.go,
      onSubmitted: (value) {
        generatePassword();
      },
      decoration: InputDecoration(
          icon: Icon(Icons.security),
          hintText: AppLocalizations.of(context)!.saltHintText,
          helperText: AppLocalizations.of(context)!.saltHelperText),
    );
    final lengthTextInput = TextField(
      readOnly: true,
      controller: lengthTextInputController,
      decoration: InputDecoration(icon: Icon(Icons.input), helperText: AppLocalizations.of(context)!.lengthHelperText),
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.next,
      onTap: showPasswordLengthDialog,
    );
    final insertSymbolsCheckBox = CheckboxListTile(
        title: Text(AppLocalizations.of(context)!.symbolSwitchTitle),
        controlAffinity: ListTileControlAffinity.leading,
        value: insertSpecialSymbols,
        onChanged: (value) {
          // setState() to notify UI changes
          setState(() {
            insertSpecialSymbols = value;
          });
        });

    return Scaffold(
      // Use ScaffoldKey to get access to APIs for things like Snackbar
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        bottom: remainingPasswordClearTime > 0
            ? AppBarLinearProgressIndicator(value: remainingPasswordClearTime / passwordClearTime)
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context)!.options,
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();

              Navigator.push(context, MaterialPageRoute(builder: (context) => OptionsPage()));
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
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: keywordTextInputController,
                  focusNode: keywordTextInputFocusNode,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofocus: true,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    generatePassword();
                  },
                  decoration: InputDecoration(
                      icon: Icon(Icons.text_fields),
                      hintText: AppLocalizations.of(context)!.keywordHintText,
                      helperText: AppLocalizations.of(context)!.keywordHelperText),
                ),
                constraints.maxWidth < UIConstants.SmallScreenWidthBreakpoint
                    ? Column(
                        children: [
                          saltTextInput,
                          Row(
                            children: [
                              Expanded(child: lengthTextInput),
                              Container(width: 200, child: insertSymbolsCheckBox)
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
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Flexible(
                        flex: 9,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: GestureDetector(
                            child: FittedBox(child: Text(password, style: TextStyle(fontSize: 32))),
                            onDoubleTap: () {
                              Clipboard.setData(ClipboardData(text: password)).then((value) {
                                UIHelper.showMessage(context, AppLocalizations.of(context)!.passwordCopiedMessage);
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
          );
        },
      ),
      // body: SingleChildScrollView(
      //   child:
      // ),
    );
  }
}

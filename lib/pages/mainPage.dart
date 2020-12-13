import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg_mobile/helper.dart';
import 'package:fpg_mobile/pages/optionsPage.dart';
import 'package:fpg_mobile/settings.dart';
import 'package:numberpicker/numberpicker.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final keywordTextInputController = TextEditingController();
  final saltTextInputController = TextEditingController();
  final lengthTextInputController = TextEditingController();

  bool insertSymbols = true;
  String password = "";

  Future<void> initSettings() async {
    lengthTextInputController.text =
        (await Settings.getPasswordLength()).toString();
    insertSymbols = await Settings.getInsertSpecialSymbolsSwitch();

    setState(() {});
  }

  void showPasswordLengthDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return NumberPickerDialog.integer(
            title: Text(AppLocalizations.of(context).setLengthTitle),
            minValue: 4,
            maxValue: 64,
            initialIntegerValue: int.parse(lengthTextInputController.text),
            step: 1,
          );
        }).then((value) {
      if (value != null) {
        setState(() {
          lengthTextInputController.text = value.toString();
        });
      }
    });
  }

  void generatePassword() {
    if (keywordTextInputController.text == null ||
        keywordTextInputController.text.isEmpty) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).keywordEmptyMessage)));
    } else if (saltTextInputController.text == null ||
        saltTextInputController.text.isEmpty) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).saltEmptyMessage)));
    } else {
      int passwordLength = int.parse(lengthTextInputController.text);

      Helper.generatePassword(keywordTextInputController.text,
              saltTextInputController.text, passwordLength, insertSymbols)
          .then((value) {
        setState(() {
          password = value;

          Settings.getAutoCopyPasswordSwitch().then((v) {
            Clipboard.setData(ClipboardData(text: value));
          });
          Settings.getRememberUserSaltSwitch().then((v) {
            Settings.setUserSalt(v ? saltTextInputController.text : "");
          });

          Settings.setPasswordLength(passwordLength);
          Settings.setInsertSpecialSymbolsSwitch(insertSymbols);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Settings.initialize().then((value) {
      initSettings();

      if (value) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context).firstRunDialogTitle),
                  content:
                      Text(AppLocalizations.of(context).firstRunDialogMessage),
                  actions: [
                    TextButton(
                      child: Text(AppLocalizations.of(context).ok),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use ScaffoldKey to get access to APIs for things like Snackbar
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context).options,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OptionsPage()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.vpn_key),
          tooltip: AppLocalizations.of(context).generatePasswordTooltip,
          onPressed: generatePassword),
      body: SingleChildScrollView(
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
                    hintText: AppLocalizations.of(context).keywordHintText,
                    helperText: AppLocalizations.of(context).keywordHelperText),
              ),
              TextField(
                controller: saltTextInputController,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.security),
                    hintText: AppLocalizations.of(context).saltHintText,
                    helperText: AppLocalizations.of(context).saltHelperText),
              ),
              Row(
                children: [
                  // Must use containers for child widgets as no inherited width is set
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: lengthTextInputController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.input),
                          helperText:
                              AppLocalizations.of(context).lengthHelperText),
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      onTap: showPasswordLengthDialog,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                        title: Text(
                            AppLocalizations.of(context).symbolSwitchTitle),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: insertSymbols,
                        onChanged: (value) {
                          // setState() to notify UI changes
                          setState(() {
                            insertSymbols = value;
                          });
                        }),
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: GestureDetector(
                    child: Text(
                      password,
                      style: TextStyle(fontSize: 32),
                    ),
                    onDoubleTap: () {
                      Clipboard.setData(ClipboardData(text: password))
                          .then((value) {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context)
                                .passwordCopiedMessage)));
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg/components/CountdownTimer.dart';
import 'package:fpg/components/NfcRecord.dart';
import 'package:fpg/constants.dart';
import 'package:fpg/helpers/ioHelper.dart';
import 'package:fpg/helpers/uiHelper.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCPage extends StatefulWidget {
  const NFCPage({super.key, required this.operation});

  final String operation;

  @override
  State<StatefulWidget> createState() => _NFCPageState(operation: this.operation);
}

class _NFCPageState extends State<NFCPage> with WidgetsBindingObserver {
  static const OPERATION_READ = "read";
  static const OPERATION_WRITE = "write";
  static const STATE_READY = "ready";
  static const STATE_COMPLETED = "completed";

  _NFCPageState({required this.operation}) : super();

  final String? operation;
  String state = STATE_READY;

  late IconData icon;
  late String title;
  late String description;
  late String warning;

  bool isNFCSessionReady = false;
  int returnTimerPeriod = 1 * 1000;

  late CountdownStopTimer completionTimer;

  Future<void> onNfcTagDiscovered(NfcTag tag) async {
    Ndef? ndef = Ndef.from(tag);

    if (ndef == null) {
      UIHelper.showMessage(context, AppLocalizations.of(context)!.unsupportedNFCTagFormatErrorMessage);

      return;
    }

    try {
      switch (this.operation) {
        case OPERATION_READ:
          final value = await readNfcTagData(ndef);

          IOHelper.decompressCriticalSettingsContents(value.text);

          break;
        case OPERATION_WRITE:
          if (ndef.isWritable) {
            final data = await IOHelper.compressCriticalSettingsContents();

            if (data == null) {
              throw FormatException("Empty data from compressCriticalSettingsContents()");
            }

            await writeNfcTagData(ndef, data);
          } else {
            throw Exception("NFC tag is not writable");
          }

          break;
      }

      setState(() {
        state = STATE_COMPLETED;
      });

      completionTimer = CountdownStopTimer(returnTimerPeriod, null, () {
        Navigator.of(context).pop(true);
      });

      completionTimer.start();
    } catch (e) {
      switch (operation) {
        case OPERATION_READ:
          UIHelper.showMessage(context, AppLocalizations.of(context)!.invalidNFCTagDataErrorMessage);

          break;
        case OPERATION_WRITE:
          if (!ndef.isWritable) {
            UIHelper.showMessage(context, AppLocalizations.of(context)!.unwritableNFCTagErrorMessage);
          } else {
            UIHelper.showMessage(context, AppLocalizations.of(context)!.exception + e.toString());
          }

          break;
      }
    }
  }

  Future<WellknownTextNfcRecord> readNfcTagData(Ndef ndef) async {
    final message = await ndef.read();

    return NfcRecord.fromNdef(message.records[0]) as WellknownTextNfcRecord;
  }

  Future<void> writeNfcTagData(Ndef ndef, String data) async {
    final ndefMessage = NdefMessage([NdefRecord.createText(data)]);

    await ndef.write(ndefMessage);
  }

  Future<void> startNfcSession() async {
    await NfcManager.instance.startSession(onDiscovered: onNfcTagDiscovered);

    isNFCSessionReady = true;
  }

  Future<void> stopNfcSession() async {
    if (isNFCSessionReady) {
      await NfcManager.instance.stopSession();
    }

    isNFCSessionReady = false;
  }

  void refreshPageElements() {
    setState(() {
      switch (state) {
        case STATE_READY:
          switch (operation) {
            case OPERATION_READ:
              icon = Icons.nfc;
              title = AppLocalizations.of(context)!.readCriticalSettingsNFCTagPageTitle;
              description = AppLocalizations.of(context)!.readCriticalSettingsNFCTagPageDescription;
              warning = "";

              break;
            case OPERATION_WRITE:
              icon = Icons.nfc_outlined;
              title = AppLocalizations.of(context)!.writeCriticalSettingsNFCTagPageTitle;
              description = AppLocalizations.of(context)!.writeCriticalSettingsNFCTagPageDescription;
              warning = AppLocalizations.of(context)!.writeCriticalSettingsNFCTagPageWarningMessage;

              break;
            default:
              throw Exception("Invalid NFC page operation");
          }

          break;
        case STATE_COMPLETED:
          icon = Icons.check_circle;
          description = AppLocalizations.of(context)!.nfcTagOperationCompletedMessage;
          warning = "";

          break;
        default:
          throw Exception("Invalid NFC page state");
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startNfcSession();
  }

  @override
  void dispose() {
    super.dispose();

    stopNfcSession();
  }

  @override
  Widget build(BuildContext context) {
    refreshPageElements();

    final textStyle = TextStyle(fontSize: 18);
    final warningTextStyle = textStyle.copyWith(color: Colors.red);

    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Padding(
                padding: EdgeInsets.only(top: 60, bottom: 60, left: 30, right: 30),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(icon, size: UIConstants.LargeIconSize),
                      Text(description, style: textStyle),
                      if (state == STATE_READY && operation == OPERATION_WRITE) Text(warning, style: warningTextStyle)
                    ],
                  ),
                ))),
        onWillPop: () async {
          // Only enable go back button in Ready state
          return state == STATE_READY;
        });
  }
}

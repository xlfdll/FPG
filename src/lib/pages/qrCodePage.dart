import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:qr_flutter/qr_flutter.dart';

import 'package:fpg/constants.dart';
import 'package:fpg/components/CountdownTimer.dart';
import 'package:fpg/helpers/ioHelper.dart';
import 'package:fpg/helpers/uiHelper.dart';
import 'package:fpg/widgets/AppBarLinearProgressIndicator.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key, required this.qrCodeData});

  final String? qrCodeData;

  @override
  State<StatefulWidget> createState() => _QRCodePageState(qrCodeData: this.qrCodeData);
}

class _QRCodePageState extends State<QRCodePage> with WidgetsBindingObserver {
  _QRCodePageState({required this.qrCodeData}) : super();

  final String? qrCodeData;

  void exportQrImage(BuildContext context) {
    final qrImageSize = 300.0;
    final qrPrinter = QrPainter(data: qrCodeData ?? '', version: QrVersions.auto);

    qrPrinter.toImageData(qrImageSize).then((value) {
      if (value != null) {
        IOHelper.writeQRCodeImageToFile(value).then((value) {
          UIHelper.showMessage(
              context,
              AppLocalizations.of(context)!
                  .saveCriticalSettingsQRCodeCompletedMessage
                  .replaceAll("%s", AppConstants.CriticalSettingsQRImageFileName));
        });
      }
    });
  }

  late CountdownStopTimer returnTimer;
  int returnTime = UIConstants.QRCodeDisplayTime;
  int remainingReturnTime = 0;

  Future<void> startReturnTimer() async {
    returnTime = UIConstants.QRCodeDisplayTime;

    returnTimer = CountdownStopTimer(returnTime, () {
      setState(() {
        remainingReturnTime = returnTimer.remainingTime;
      });
    }, () {
      Navigator.of(context).pop();
    });

    returnTimer.reset();
    returnTimer.start();
  }

  @override
  void initState() {
    super.initState();

    startReturnTimer();
  }

  @override
  void dispose() {
    returnTimer.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.showCriticalSettingsQRCodePageTitle),
          bottom:
              remainingReturnTime > 0 ? AppBarLinearProgressIndicator(value: remainingReturnTime / returnTime) : null,
        ),
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.download),
            label: Text(AppLocalizations.of(context)!.saveCriticalSettingsQRCodeButtonLabel),
            onPressed: () => exportQrImage(context)),
        body: Padding(
            padding: EdgeInsets.only(top: 60, bottom: 60, left: 30, right: 30),
            child: Center(
              child: qrCodeData != null
                  ? QrImageView(
                      data: qrCodeData ?? '',
                      eyeStyle:
                          QrEyeStyle(color: Theme.of(context).colorScheme.inversePrimary, eyeShape: QrEyeShape.square),
                      dataModuleStyle: QrDataModuleStyle(color: Theme.of(context).colorScheme.primary),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: UIConstants.LargeIconSize),
                        Text(AppLocalizations.of(context)!.noCriticalSettingsQRCodeErrorMessage),
                      ],
                    ),
            )));
  }
}

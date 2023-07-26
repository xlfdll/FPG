import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatelessWidget {
  final scanController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false);

  bool isDetected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!
              .importCriticalSettingsFromQRCodePageTitle)),
      body: MobileScanner(
        controller: scanController,
        errorBuilder: (context, exception, widget) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error),
              Text(
                  AppLocalizations.of(context)!.noCameraPermissionErrorMessage),
            ],
          );
        },
        onDetect: (capture) {
          if (!isDetected) {
            // NoDuplicates won't rescan the same QR code
            // Has to use normal, and use boolean to prevent multiple detect events
            isDetected = true;

            Navigator.of(context).pop(capture.barcodes[0].rawValue);
          }
        },
      ),
    );
  }
}

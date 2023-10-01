import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fpg/constants.dart';
import 'package:fpg/helpers/ioHelper.dart';
import 'package:fpg/helpers/uiHelper.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatelessWidget {
  final scanController =
      MobileScannerController(detectionSpeed: DetectionSpeed.normal, facing: CameraFacing.back, torchEnabled: false);

  bool isDetected = false;
  String? previousValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.importCriticalSettingsFromQRCodePageTitle)),
      body: MobileScanner(
        controller: scanController,
        errorBuilder: (context, exception, widget) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.error, size: UIConstants.LargeIconSize),
              Text(AppLocalizations.of(context)!.noCameraPermissionErrorMessage),
            ],
          );
        },
        onDetect: (capture) {
          if (!isDetected) {
            // NoDuplicates won't rescan the same QR code
            // Has to use normal, and use boolean to prevent multiple detect events
            isDetected = true;

            final value = capture.barcodes[0].rawValue;

            try {
              if (value != null && value.isNotEmpty) {
                IOHelper.decompressCriticalSettingsContents(value);

                Navigator.of(context).pop();
              } else {
                throw FormatException("Empty QR code value");
              }
            } catch (e) {
              if (previousValue != value) {
                UIHelper.showMessage(context, AppLocalizations.of(context)!.invalidQRCodeErrorMessage);

                previousValue = value;
              }

              isDetected = false;
            }
          }
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' show Blob, AnchorElement, Url;

import 'package:fpg/constants.dart';
import 'package:fpg/helpers/platformHelper.dart';
import 'package:fpg/settings.dart';

class IOHelper {
  static Future<String> _getCriticalSettingsContents() async {
    final sb = StringBuffer();

    sb.writeln(await Settings.getRandomSalt());
    sb.writeln(await Settings.getSpecialSymbols());

    return sb.toString();
  }

  static Future<void> _setCriticalSettings(List<String> lines) async {
    if (lines.isNotEmpty) {
      await Settings.setRandomSalt(lines[0]);
      await Settings.setSpecialSymbols(lines[1]);
    }
  }

  static Future<String> _getBackupDirectoryPath() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    return "${directory!.path}";
  }

  static Future<String> _getBackupFilePath() async {
    return "${await _getBackupDirectoryPath()}/${AppConstants.CriticalSettingsBackupFileName}";
  }

  static Future<String> _getQRImageFilePath() async {
    return "${await _getBackupDirectoryPath()}/${AppConstants.CriticalSettingsQRImageFileName}";
  }

  static void _downloadBlob(String fileName, Blob blob) {
    if (PlatformHelper.isWeb()) {
      final anchorElement =
          AnchorElement(href: Url.createObjectUrlFromBlob(blob).toString());

      // "download" attribute in <a> will force downloading files
      anchorElement.setAttribute("download", fileName);
      anchorElement.click();
    }
  }

  static Future<bool> checkCriticalSettingsFile() async {
    if (!PlatformHelper.isWeb()) {
      final file = File(await _getBackupFilePath());

      return file.exists();
    } else {
      return true;
    }
  }

  static Future<void> backupCriticalSettingsToFile() async {
    if (!PlatformHelper.isWeb()) {
      final file = File(await _getBackupFilePath());

      await file.writeAsString(await _getCriticalSettingsContents(),
          flush: true);
    } else {
      final blob =
          Blob([await _getCriticalSettingsContents()], "text/plain", "native");

      _downloadBlob(AppConstants.CriticalSettingsBackupFileName, blob);
    }
  }

  static Future<void> restoreCriticalSettingsFromFile() async {
    List<String>? lines;

    if (!PlatformHelper.isWeb()) {
      final file = File(await _getBackupFilePath());

      lines = await file.readAsLines();
    } else {
      final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["dat"],
          allowMultiple: false);

      if (result != null) {
        final ls = LineSplitter();
        lines = ls.convert(utf8.decode(result.files.first.bytes!.toList()));
      } else {
        lines = null;
      }
    }

    if (lines != null) {
      _setCriticalSettings(lines);
    }
  }

  static Future<String?> compressCriticalSettingsContents() async {
    final bytes =
        GZipEncoder().encode(utf8.encode(await _getCriticalSettingsContents()));

    if (bytes != null) {
      return base64.encode(bytes);
    }

    return null;
  }

  static void decompressCriticalSettingsContents(
      String compressedEncodedContents) {
    final ls = LineSplitter();
    final lines = ls.convert(utf8.decode(GZipDecoder()
        .decodeBytes(base64.decode(compressedEncodedContents).toList())));

    _setCriticalSettings(lines);
  }

  static Future<void> writeQRCodeImageToFile(ByteData qrImageByteData) async {
    final qrImageBytes = qrImageByteData.buffer.asUint8List(
        qrImageByteData.offsetInBytes, qrImageByteData.lengthInBytes);

    if (!PlatformHelper.isWeb()) {
      final file = File(await _getQRImageFilePath());

      await file.writeAsBytes(qrImageBytes);
    } else {
      final blob = Blob([qrImageBytes], "image/png", "native");

      _downloadBlob(AppConstants.CriticalSettingsQRImageFileName, blob);
    }
  }
}

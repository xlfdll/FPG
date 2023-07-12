import 'dart:convert';
import 'dart:html' show Blob, AnchorElement, Url;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fpg/constants.dart';
import 'package:fpg/helpers/platformHelper.dart';
import 'package:fpg/main.dart';
import 'package:fpg/settings.dart';
import 'package:path_provider/path_provider.dart';

class PasswordHelper {
  static Future<String> generatePassword(String keyword, String userSalt,
      int length, bool insertSymbols) async {
    String result = App.algorithmSet.cropping.crop(
        App.algorithmSet.hashing.hash(App.algorithmSet.salting
            .salt([keyword], [await Settings.getRandomSalt(), userSalt])),
        length);

    if (insertSymbols) {
      return App.algorithmSet.symbolInsertion
          .insertSymbol(result, await Settings.getSpecialSymbols());
    } else {
      return result;
    }
  }

  static Future<void> generateRandomSalt() async {
    await Settings.setRandomSalt(App.algorithmSet.saltGeneration.generate());
  }

  static Future<void> backupCriticalSettings() async {
    StringBuffer sb = StringBuffer();

    sb.writeln(await Settings.getRandomSalt());
    sb.writeln(await Settings.getSpecialSymbols());

    if (!PlatformHelper.isWeb()) {
      File file = File(await _getBackupFilePath());

      await file.writeAsString(sb.toString(), flush: true);
    } else {
      Blob blob = Blob([sb.toString()], "text/plain", "native");
      AnchorElement anchorElement = AnchorElement(
          href: Url.createObjectUrlFromBlob(blob).toString());

      anchorElement.setAttribute("download", AppConstants.CriticalSettingsBackupFileName);
      anchorElement.click();
    }
  }

  static Future<bool> checkCriticalSettings() async {
    if (!PlatformHelper.isWeb()) {
      File file = File(await _getBackupFilePath());

      return file.exists();
    } else {
      return true;
    }
  }

  static Future<void> restoreCriticalSettings() async {
    List<String>? lines;

    if (!PlatformHelper.isWeb()) {
      File file = File(await _getBackupFilePath());

      lines = await file.readAsLines();
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["dat"],
          allowMultiple: false);

      if (result != null) {
        LineSplitter ls = LineSplitter();
        lines = ls.convert(utf8.decode(result.files.first.bytes!.toList()));
      } else {
        lines = null;
      }
    }

    if (lines != null) {
      await Settings.setRandomSalt(lines[0]);
      await Settings.setSpecialSymbols(lines[1]);
    }
  }

  static Future<String> _getBackupFilePath() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    return "${directory!.path}/${AppConstants.CriticalSettingsBackupFileName}";
  }
}

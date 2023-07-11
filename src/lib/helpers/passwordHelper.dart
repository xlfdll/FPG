import 'dart:io';

import 'package:fpg/constants.dart';
import 'package:fpg/helpers/platformHelper.dart';
import 'package:fpg/main.dart';
import 'package:fpg/settings.dart';
import 'package:path_provider/path_provider.dart';

class PasswordHelper {
  static Future<String> generatePassword(
      String keyword, String userSalt, int length, bool insertSymbols) async {
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

  static Future<void> backupCriticalSettings() async {
    StringBuffer sb = StringBuffer();

    sb.writeln(await Settings.getRandomSalt());
    sb.writeln(await Settings.getSpecialSymbols());

    if (!PlatformHelper.isWeb()) {
      File file = File(await _getBackupFilePath());

      await file.writeAsString(sb.toString(), flush: true);
    } else {}
  }

  static Future<bool> checkCriticalSettings() async {
    File file = File(await _getBackupFilePath());

    return file.exists();
  }

  static Future<void> restoreCriticalSettings() async {
    File file = File(await _getBackupFilePath());

    List<String> lines = await file.readAsLines();

    await Settings.setRandomSalt(lines[0]);
    await Settings.setSpecialSymbols(lines[1]);
  }

  static Future<String> _getBackupFilePath() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    return "${directory!.path}/${PreferenceConstants.CriticalSettingsBackupFileName}";
  }
}

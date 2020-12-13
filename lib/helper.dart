import 'dart:io';

import 'package:fpg_mobile/constants.dart';
import 'package:fpg_mobile/main.dart';
import 'package:fpg_mobile/settings.dart';
import 'package:path_provider/path_provider.dart';

class Helper {
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

  static Future backupCriticalSettings() async {
    StringBuffer sb = StringBuffer();

    sb.writeln(await Settings.getRandomSalt());
    sb.writeln(await Settings.getSpecialSymbols());

    File file = File(await _getBackupFilePath());

    await file.writeAsString(sb.toString(), flush: true);
  }

  static Future restoreCriticalSettings() async {
    File file = File(await _getBackupFilePath());

    List<String> lines = await file.readAsLines();

    await Settings.setRandomSalt(lines[0]);
    await Settings.setSpecialSymbols(lines[1]);
  }

  static Future<String> _getBackupFilePath() async {
    Directory directory;

    if (Platform.isAndroid) {
      List<Directory> externalDirectories =
          await getExternalStorageDirectories(type: StorageDirectory.documents);

      directory = externalDirectories[0];
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    return "${directory.path}/${Constants.CriticalSettingsBackupFileName}";
  }
}

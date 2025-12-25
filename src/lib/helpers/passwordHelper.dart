import 'package:fpg/main.dart';
import 'package:fpg/settings.dart';

class PasswordHelper {
  static Future<String> generatePassword(String keyword, String userSalt, int length, bool insertSymbols) async {
    final result = App.algorithmSet.cropping.crop(
        App.algorithmSet.hashing
            .hash(App.algorithmSet.salting.salt([keyword], [await Settings.getRandomSalt(), userSalt])),
        length);

    if (insertSymbols) {
      return App.algorithmSet.symbolInsertion.insertSymbol(result, await Settings.getSpecialSymbols());
    } else {
      return result;
    }
  }

  static Future<void> generateRandomSalt() async {
    await Settings.setRandomSalt(App.algorithmSet.saltGeneration.generate());
  }
}

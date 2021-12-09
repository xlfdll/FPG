import 'dart:async';

import 'package:fpg_mobile/constants.dart';
import 'package:fpg_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static late SharedPreferences preferences;

  static Future<bool> initialize() async {
    preferences = await SharedPreferences.getInstance();

    if ((await getRandomSalt()) == null) {
      await setAutoCopyPasswordSwitch(true);
      await setRememberUserSaltSwitch(true);
      await setPasswordLength(16);
      await setInsertSpecialSymbolsSwitch(true);
      await setSpecialSymbols(Constants.DefaultSpecialSymbols);
      await setUserSalt("");
      await setRandomSalt(App.algorithmSet.saltGeneration.generate());

      return true;
    }

    return false;
  }

  static Future<bool?> getAutoCopyPasswordSwitch() async {
    return await getPreference(Constants.AutoCopyPasswordPreferenceKey);
  }

  static Future<void> setAutoCopyPasswordSwitch(bool value) async {
    await setBoolPreference(Constants.AutoCopyPasswordPreferenceKey, value);
  }

  static Future<bool?> getRememberUserSaltSwitch() async {
    return await getPreference(Constants.RememberUserSaltPreferenceKey);
  }

  static Future<void> setRememberUserSaltSwitch(bool value) async {
    await setBoolPreference(Constants.RememberUserSaltPreferenceKey, value);
  }

  static Future<int?> getPasswordLength() async {
    return await getPreference(Constants.PasswordLengthPreferenceKey);
  }

  static Future<void> setPasswordLength(int value) async {
    await setIntPreference(Constants.PasswordLengthPreferenceKey, value);
  }

  static Future<bool?> getInsertSpecialSymbolsSwitch() async {
    return await getPreference(Constants.InsertSpecialSymbolsPreferenceKey);
  }

  static Future<void> setInsertSpecialSymbolsSwitch(bool value) async {
    await setBoolPreference(Constants.InsertSpecialSymbolsPreferenceKey, value);
  }

  static Future<String?> getSpecialSymbols() async {
    return await getPreference(Constants.SpecialSymbolsPreferenceKey);
  }

  static Future<void> setSpecialSymbols(String value) async {
    await setStringPreference(Constants.SpecialSymbolsPreferenceKey, value);
  }

  static Future<String?> getUserSalt() async {
    return await getPreference(Constants.UserSaltPreferenceKey);
  }

  static Future<void> setUserSalt(String value) async {
    await setStringPreference(Constants.UserSaltPreferenceKey, value);
  }

  static Future<String?> getRandomSalt() async {
    return await getPreference(Constants.RandomSaltPreferenceKey);
  }

  static Future<void> setRandomSalt(String value) async {
    await setStringPreference(Constants.RandomSaltPreferenceKey, value);
  }

  static T? getPreference<T>(String key) {
    return preferences.get(key) as T?;
  }

  static Future<bool> setIntPreference(String key, int value) async {
    return await preferences.setInt(key, value);
  }

  static Future<bool> setBoolPreference(String key, bool value) async {
    return await preferences.setBool(key, value);
  }

  static Future<bool> setStringPreference(String key, String value) async {
    return await preferences.setString(key, value);
  }
}

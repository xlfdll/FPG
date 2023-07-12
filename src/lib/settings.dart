import 'dart:async';

import 'package:fpg/constants.dart';
import 'package:fpg/main.dart';
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
      await setSpecialSymbols(AppConstants.DefaultSpecialSymbols);
      await setUserSalt("");
      await setRandomSalt(App.algorithmSet.saltGeneration.generate());

      return true;
    }

    return false;
  }

  static Future<bool?> getAutoCopyPasswordSwitch() async {
    return await _getPreference(PreferenceKeys.AutoCopyPasswordPreferenceKey);
  }

  static Future<void> setAutoCopyPasswordSwitch(bool value) async {
    await _setBoolPreference(PreferenceKeys.AutoCopyPasswordPreferenceKey, value);
  }

  static Future<bool?> getRememberUserSaltSwitch() async {
    return await _getPreference(PreferenceKeys.RememberUserSaltPreferenceKey);
  }

  static Future<void> setRememberUserSaltSwitch(bool value) async {
    await _setBoolPreference(PreferenceKeys.RememberUserSaltPreferenceKey, value);
  }

  static Future<int?> getPasswordLength() async {
    return await _getPreference(PreferenceKeys.PasswordLengthPreferenceKey);
  }

  static Future<void> setPasswordLength(int value) async {
    await _setIntPreference(PreferenceKeys.PasswordLengthPreferenceKey, value);
  }

  static Future<bool?> getInsertSpecialSymbolsSwitch() async {
    return await _getPreference(PreferenceKeys.InsertSpecialSymbolsPreferenceKey);
  }

  static Future<void> setInsertSpecialSymbolsSwitch(bool value) async {
    await _setBoolPreference(PreferenceKeys.InsertSpecialSymbolsPreferenceKey, value);
  }

  static Future<String?> getSpecialSymbols() async {
    return await _getPreference(PreferenceKeys.SpecialSymbolsPreferenceKey);
  }

  static Future<void> setSpecialSymbols(String value) async {
    await _setStringPreference(PreferenceKeys.SpecialSymbolsPreferenceKey, value);
  }

  static Future<String?> getUserSalt() async {
    return await _getPreference(PreferenceKeys.UserSaltPreferenceKey);
  }

  static Future<void> setUserSalt(String value) async {
    await _setStringPreference(PreferenceKeys.UserSaltPreferenceKey, value);
  }

  static Future<String?> getRandomSalt() async {
    return await _getPreference(PreferenceKeys.RandomSaltPreferenceKey);
  }

  static Future<void> setRandomSalt(String value) async {
    await _setStringPreference(PreferenceKeys.RandomSaltPreferenceKey, value);
  }

  static T? _getPreference<T>(String key) {
    return preferences.get(key) as T?;
  }

  static Future<bool> _setIntPreference(String key, int value) async {
    return await preferences.setInt(key, value);
  }

  static Future<bool> _setBoolPreference(String key, bool value) async {
    return await preferences.setBool(key, value);
  }

  static Future<bool> _setStringPreference(String key, String value) async {
    return await preferences.setString(key, value);
  }
}

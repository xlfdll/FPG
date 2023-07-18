import 'dart:async';

import 'package:fpg/constants.dart';
import 'package:fpg/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static late SharedPreferences preferences;

  static Future<bool> initialize() async {
    preferences = await SharedPreferences.getInstance();

    bool firstRun = ((await getRandomSalt()) == null);

    if ((await getAutoCopyPasswordSwitch()) == null) {
      await setAutoCopyPasswordSwitch(PreferenceDefaults.AutoCopyPassword);
    }
    if ((await getRememberUserSaltSwitch()) == null) {
      await setRememberUserSaltSwitch(PreferenceDefaults.RememberUserSalt);
    }
    if ((await getPasswordLength()) == null) {
      await setPasswordLength(PreferenceDefaults.PasswordLength);
    }
    if ((await getInsertSpecialSymbolsSwitch()) == null) {
      await setInsertSpecialSymbolsSwitch(PreferenceDefaults.InsertSpecialSymbols);
    }
    if ((await getSpecialSymbols()) == null) {
      await setSpecialSymbols(PreferenceDefaults.SpecialSymbols);
    }
    if ((await getUserSalt()) == null) {
      await setUserSalt(PreferenceDefaults.UserSalt);
    }
    if ((await getRandomSalt()) == null) {
      await setRandomSalt(App.algorithmSet.saltGeneration.generate());
    }
    if ((await getShowPasswordSwitch()) == null) {
      await setShowPasswordSwitch(PreferenceDefaults.ShowPassword);
    }
    if ((await getAutoClearPasswordSwitch()) == null) {
      await setAutoClearPasswordSwitch(PreferenceDefaults.AutoClearPassword);
    }
    if ((await getPasswordClearTime()) == null) {
      await setPasswordClearTime(PreferenceDefaults.PasswordClearTime);
    }

    return firstRun;
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

  static Future<bool?> getShowPasswordSwitch() async {
    return await _getPreference(PreferenceKeys.ShowPasswordPreferenceKey);
  }

  static Future<void> setShowPasswordSwitch(bool value) async {
    await _setBoolPreference(PreferenceKeys.ShowPasswordPreferenceKey, value);
  }

  static Future<bool?> getAutoClearPasswordSwitch() async {
    return await _getPreference(PreferenceKeys.AutoClearPasswordPreferenceKey);
  }

  static Future<void> setAutoClearPasswordSwitch(bool value) async {
    await _setBoolPreference(PreferenceKeys.AutoClearPasswordPreferenceKey, value);
  }

  static Future<int?> getPasswordClearTime() async {
    return await _getPreference(PreferenceKeys.PasswordClearTimePreferenceKey);
  }

  static Future<void> setPasswordClearTime(int value) async {
    await _setIntPreference(PreferenceKeys.PasswordClearTimePreferenceKey, value);
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

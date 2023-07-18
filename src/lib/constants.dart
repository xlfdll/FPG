class PreferenceKeys {
  static const String AutoCopyPasswordPreferenceKey = "AutoCopyPassword";
  static const String RememberUserSaltPreferenceKey = "RememberUserSalt";
  static const String PasswordLengthPreferenceKey = "PasswordLength";
  static const String InsertSpecialSymbolsPreferenceKey =
      "InsertSpecialSymbols";
  static const String SpecialSymbolsPreferenceKey = "SpecialSymbols";
  static const String UserSaltPreferenceKey = "UserSalt";
  static const String RandomSaltPreferenceKey = "RandomSalt";
  static const String ShowPasswordPreferenceKey = "ShowPassword";
  static const String AutoClearPasswordPreferenceKey = "AutoClearPassword";
  static const String PasswordClearTimePreferenceKey = "PasswordClearTime";
}

class PreferenceDefaults {
  static const bool AutoCopyPassword = true;
  static const bool RememberUserSalt = true;
  static const int PasswordLength = 16;
  static const bool InsertSpecialSymbols = true;
  static const String SpecialSymbols =
      r"~`!@#$%^&*()+=_-{}[]\|:;”’?/<>,."
      r"GgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
  static const String UserSalt = "";
  static const bool ShowPassword = false;
  static const bool AutoClearPassword = true;
  static const int PasswordClearTime = 30 * 1000;
}

class AppConstants {
  static const int RandomSaltLength = 64;
  static const String CriticalSettingsBackupFileName =
      "FPG_CriticalSettings.dat";
}

class UIConstants {
  static const int ScreenWidthBreakpoint = 600;
}

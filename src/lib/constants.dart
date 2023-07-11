class PreferenceKeys {
  static const String AutoCopyPasswordPreferenceKey = "AutoCopyPassword";
  static const String RememberUserSaltPreferenceKey = "RememberUserSalt";
  static const String PasswordLengthPreferenceKey = "PasswordLength";
  static const String InsertSpecialSymbolsPreferenceKey =
      "InsertSpecialSymbols";
  static const String SpecialSymbolsPreferenceKey = "SpecialSymbols";
  static const String UserSaltPreferenceKey = "UserSalt";
  static const String RandomSaltPreferenceKey = "RandomSalt";
}

class PreferenceConstants {
  static const int RandomSaltLength = 64;
  static const String DefaultSpecialSymbols =
      r"~`!@#$%^&*()+=_-{}[]\|:;”’?/<>,."
      r"GgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
  static const String CriticalSettingsBackupFileName =
      "FPG_CriticalSettings.dat";
}

class UIConstants {
  static const int ScreenWidthBreakpoint = 600;
}

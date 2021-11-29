using System;
using System.IO;
using System.Text;

using Xlfdll.Text;

namespace FPG
{
    public static class Helper
    {
        public static String GeneratePassword(String keyword, String userSalt, Int32 length, Boolean insertSymbols)
        {
            String result
                = App.AlgorithmSet.Cropping.Crop
                (App.AlgorithmSet.Hashing.Hash
                (App.AlgorithmSet.Salting.Salt
                    (new String[] { keyword }, new String[] { App.Settings.Password.RandomSalt, userSalt })), length);

            if (insertSymbols)
            {
                return App.AlgorithmSet.SymbolInsertion.InsertSymbol(result, App.Settings.Password.SpecialSymbols);
            }
            else
            {
                return result;
            }
        }

        public static String[] LoadCriticalSettings()
        {
            return File.ReadAllLines(Helper.CriticalSettingsBackupFileName, AdditionalEncodings.UTF8WithoutBOM);
        }

        public static void SaveCriticalSettings()
        {
            StringBuilder sb = new StringBuilder();

            sb.AppendLine(App.Settings.Password.RandomSalt);
            sb.AppendLine(App.Settings.Password.SpecialSymbols);

            File.WriteAllText(Helper.CriticalSettingsBackupFileName, sb.ToString(), AdditionalEncodings.UTF8WithoutBOM);
        }

        public const String CriticalSettingsBackupFileName = "FPG_CriticalSettings.dat";
        public const String DefaultSpecialSymbols
            = @"~`!@#$%^&*()+=_-{}[]\|:;”’?/<>,."
            + "GgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
    }
}
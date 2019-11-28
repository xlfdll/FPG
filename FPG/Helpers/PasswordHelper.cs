using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

using Xlfdll.Text;

namespace FPG.Helpers
{
    public static class PasswordHelper
    {
        public static String GeneratePassword(String keyword, String salt, Int32 length)
        {
            SHA512Managed sha512 = new SHA512Managed();
            StringBuilder sb = new StringBuilder();

            sb.Append(keyword);
            sb.Append(ApplicationHelper.Settings.Password.RandomSalt);
            sb.Append(salt);

            String result = StringHelper.GetHashString(sha512, sb.ToString(), Encoding.BigEndianUnicode);

            sb.Clear();

            for (Int32 i = 0, j = length; i < length; i++, j++)
            {
                if ((j + i) == result.Length)
                {
                    j = 0;
                }

                sb.Append(i % 2 == 0 ? Char.ToUpperInvariant(result[j + i]) : result[j + i]);
            }

            return sb.ToString();
        }

        public static String GenerateSalt(Int32 length)
        {
            String basicCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_ []{}<>~`+=,.;:/?|";

            StringBuilder sb = new StringBuilder();
            Random random = new Random();

            for (Int32 i = 0; i < length; i++)
            {
                sb.Append(basicCharacters.Substring(random.Next(0, basicCharacters.Length - 1), 1));
            }

            return sb.ToString();
        }

        public static String LoadRandomSalt()
        {
            return File.ReadAllText(PasswordHelper.RandomSaltBackupDataFileName, AdditionalEncodings.UTF8WithoutBOM);
        }

        public static void SaveRandomSalt(String randomSalt)
        {
            File.WriteAllText(PasswordHelper.RandomSaltBackupDataFileName, randomSalt, AdditionalEncodings.UTF8WithoutBOM);
        }

        public const Int32 RandomSaltLength = 64;
        public const String RandomSaltBackupDataFileName = "FPG_Salt.dat";
    }
}
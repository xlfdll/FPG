using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

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
			return File.ReadAllText(PasswordHelper.RandomSaltBackupDataFileName, PasswordHelper.DefaultEncoding);
		}

		public static void SaveRandomSalt(String randomSalt)
		{
			File.WriteAllText(PasswordHelper.RandomSaltBackupDataFileName, randomSalt, PasswordHelper.DefaultEncoding);
		}

		public const Int32 RandomSaltLength = 64;

		public static readonly String RandomSaltBackupDataFileName = "FPG_Salt.dat";
		public static readonly UTF8Encoding DefaultEncoding = new UTF8Encoding(false);
	}
}
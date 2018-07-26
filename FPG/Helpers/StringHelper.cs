using System;
using System.Text;
using System.Security.Cryptography;

namespace FPG.Helpers
{
    public static class StringHelper
    {
        public static String GetBytesString(Byte[] bytes)
        {
            StringBuilder sb = new StringBuilder();

            foreach (Byte b in bytes)
            {
                sb.Append(b.ToString("x2"));
            }

            return sb.ToString();
        }

        public static String GetHashString(HashAlgorithm hashAlgorithm, String text, Encoding encoding)
        {
            return StringHelper.GetBytesString(hashAlgorithm.ComputeHash(encoding.GetBytes(text)));
        }
    }
}
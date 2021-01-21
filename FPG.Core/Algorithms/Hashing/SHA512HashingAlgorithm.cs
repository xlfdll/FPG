using System;
using System.Security.Cryptography;
using System.Text;

using FPG.Interfaces;

using Xlfdll.Collections;

namespace FPG.Algorithms
{
    public class SHA512HashingAlgorithm : IHashingAlgorithm
    {
        public Encoding TextEncoding { get; set; } = Encoding.BigEndianUnicode;

        public String Hash(String input)
        {
            SHA512Managed sha512 = new SHA512Managed();

            return sha512.ComputeHash(this.TextEncoding.GetBytes(input)).ToHexString();
        }
    }
}
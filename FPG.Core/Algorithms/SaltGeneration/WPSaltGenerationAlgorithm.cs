using System;
using System.Text;

using FPG.Interfaces;

namespace FPG.Algorithms
{
    public class WPSaltGenerationAlgorithm : ISaltGenerationAlgorithm
    {
        public Int32 Length { get; set; } = 64;

        public String Generate()
        {
            // Random must be created inside the Generate() method, or repeated character issue will occur
            Random random = new Random();
            StringBuilder sb = new StringBuilder();

            for (Int32 i = 0; i < this.Length; i++)
            {
                sb.Append(WPSaltGenerationAlgorithm.Characters.Substring
                    (random.Next(0, WPSaltGenerationAlgorithm.Characters.Length - 1), 1));
            }

            return sb.ToString();
        }

        private const String Characters
            = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_ []{}<>~`+=,.;:/?|";
    }
}
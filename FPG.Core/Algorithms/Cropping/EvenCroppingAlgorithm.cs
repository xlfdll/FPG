using System;
using System.Text;

using FPG.Interfaces;

namespace FPG.Algorithms
{
    public class EvenCroppingAlgorithm : ICroppingAlgorithm
    {
        public String Crop(String input, Int32 length)
        {
            StringBuilder sb = new StringBuilder();

            for (Int32 i = 0, j = length; i < length; i++, j++)
            {
                if ((j + i) == input.Length)
                {
                    j = 0;
                }

                sb.Append(i % 2 == 0 ? Char.ToUpperInvariant(input[j + i]) : input[j + i]);
            }

            return sb.ToString();
        }
    }
}
using System;
using System.Text;

using FPG.Interfaces;

namespace FPG.Algorithms
{
    public class NPickedSymbolInsertionAlgorithm : ISymbolInsertionAlgorithm
    {
        public Int32 PickCount { get; set; } = 1;

        public String InsertSymbol(String input, String symbols)
        {
            StringBuilder sb = new StringBuilder(input);
            Int64 sum = 0;

            foreach (Char c in input)
            {
                sum += (Int64)c;
            }

            for (Int32 i = 0; i < this.PickCount; i++)
            {
                Int32 inputIndex = Convert.ToInt32((i + 1) * sum * 701 % input.Length);
                Int32 symbolIndex = Convert.ToInt32((i + 1) * sum * 997 % symbols.Length);

                // Prefer replacing digits
                Int32 tempInputIndex = inputIndex;

                while (tempInputIndex != inputIndex && !Char.IsDigit(input[tempInputIndex]))
                {
                    tempInputIndex = (tempInputIndex + 1) % input.Length;
                }

                if (tempInputIndex != inputIndex)
                {
                    inputIndex = tempInputIndex;
                }

                sb[inputIndex] = symbols[symbolIndex];
            }

            return sb.ToString();
        }
    }
}
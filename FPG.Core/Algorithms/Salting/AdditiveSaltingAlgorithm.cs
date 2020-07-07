using System;
using System.Collections.Generic;
using System.Text;

using FPG.Interfaces;

namespace FPG.Algorithms
{
    public class AdditiveSaltingAlgorithm : ISaltingAlgorithm
    {
        public String Salt(IEnumerable<String> inputs, IEnumerable<String> salts)
        {
            StringBuilder sb = new StringBuilder();
            IEnumerator<String> inputEnumerator = inputs.GetEnumerator();
            IEnumerator<String> saltEnumerator = salts.GetEnumerator();

            // Keyword
            inputEnumerator.MoveNext();
            sb.Append(inputEnumerator.Current);

            // Random Salt
            saltEnumerator.MoveNext();
            sb.Append(saltEnumerator.Current);
            // User Salt
            saltEnumerator.MoveNext();
            sb.Append(saltEnumerator.Current);

            return sb.ToString();
        }
    }
}
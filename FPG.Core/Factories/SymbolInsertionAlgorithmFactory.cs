using System;

using FPG.Algorithms;
using FPG.Interfaces;

namespace FPG.Factories
{
    public static class SymbolInsertionAlgorithmFactory
    {
        public static ISymbolInsertionAlgorithm Create(String name)
        {
            switch (name.ToLower())
            {
                case "npicked":
                    return new NPickedSymbolInsertionAlgorithm();
                default:
                    throw new ArgumentException("Unknown algorithm name");
            };
        }
    }
}
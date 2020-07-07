using System;

using FPG.Algorithms;
using FPG.Interfaces;

namespace FPG.Factories
{
    public static class SaltingAlgorithmFactory
    {
        public static ISaltingAlgorithm Create(String name)
        {
            switch (name.ToLower())
            {
                case "additive":
                    return new AdditiveSaltingAlgorithm();
                default:
                    throw new ArgumentException("Unknown algorithm name");
            };
        }
    }
}
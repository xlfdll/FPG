using System;

using FPG.Algorithms;
using FPG.Interfaces;

namespace FPG.Factories
{
    public static class CroppingAlgorithmFactory
    {
        public static ICroppingAlgorithm Create(String name)
        {
            switch (name.ToLower())
            {
                case "even":
                    return new EvenCroppingAlgorithm();
                default:
                    throw new ArgumentException("Unknown algorithm name");
            };
        }
    }
}
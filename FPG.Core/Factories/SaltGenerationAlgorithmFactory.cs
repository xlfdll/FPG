using System;

using FPG.Algorithms;
using FPG.Interfaces;

namespace FPG.Factories
{
    public static class SaltGenerationAlgorithmFactory
    {
        public static ISaltGenerationAlgorithm Create(String name)
        {
            switch (name.ToLower())
            {
                case "wp":
                    return new WPSaltGenerationAlgorithm();
                default:
                    throw new ArgumentException("Unknown algorithm name");
            };
        }
    }
}
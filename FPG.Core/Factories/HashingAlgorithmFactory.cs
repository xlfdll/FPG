using System;

using FPG.Algorithms;
using FPG.Interfaces;

namespace FPG.Factories
{
    public static class HashingAlgorithmFactory
    {
        public static IHashingAlgorithm Create(String name)
        {
            switch (name.ToLower())
            {
                case "sha512":
                    return new SHA512HashingAlgorithm();
                default:
                    throw new ArgumentException("Unknown algorithm name");
            };
        }
    }
}
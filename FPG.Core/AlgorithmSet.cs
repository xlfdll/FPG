using System;

using FPG.Factories;
using FPG.Interfaces;

namespace FPG
{
    public class AlgorithmSet
    {
        public AlgorithmSet
            (String saltGenerationAlgorithmName,
            String saltingAlgorithmName,
            String hashingAlgorithmName,
            String croppingAlgorithmName,
            String symbolInsertionAlgorithmName)
        {
            this.SaltGeneration = SaltGenerationAlgorithmFactory.Create(saltGenerationAlgorithmName);
            this.Salting = SaltingAlgorithmFactory.Create(saltingAlgorithmName);
            this.Hashing = HashingAlgorithmFactory.Create(hashingAlgorithmName);
            this.Cropping = CroppingAlgorithmFactory.Create(croppingAlgorithmName);
            this.SymbolInsertion = SymbolInsertionAlgorithmFactory.Create(symbolInsertionAlgorithmName);
        }

        public ISaltGenerationAlgorithm SaltGeneration { get; }
        public ISaltingAlgorithm Salting { get; }
        public IHashingAlgorithm Hashing { get; }
        public ICroppingAlgorithm Cropping { get; }
        public ISymbolInsertionAlgorithm SymbolInsertion { get; }

        public static AlgorithmSet Create(String setName)
        {
            switch (setName.ToLower())
            {
                case "default":
                    return new AlgorithmSet("WP", "Additive", "SHA512", "Even", "NPicked");
                default:
                    throw new ArgumentException("Unknown algorithm set name");
            }
        }
    }
}
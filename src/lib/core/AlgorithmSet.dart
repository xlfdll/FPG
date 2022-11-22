import 'factories/CroppingAlgorithmFactory.dart';
import 'factories/HashingAlgorithmFactory.dart';
import 'factories/SaltGenerationAlgorithmFactory.dart';
import 'factories/SaltingAlgorithmFactory.dart';
import 'factories/SymbolInsertionAlgorithmFactory.dart';
import 'interfaces/ICroppingAlgorithm.dart';
import 'interfaces/IHashingAlgorithm.dart';
import 'interfaces/ISaltGenerationAlgorithm.dart';
import 'interfaces/ISaltingAlgorithm.dart';
import 'interfaces/ISymbolInsertionAlgorithm.dart';

class AlgorithmSet {
  AlgorithmSet(
      String saltGenerationAlgorithmName,
      String saltingAlgorithmName,
      String hashingAlgorithmName,
      String croppingAlgorithmName,
      String symbolInsertionAlgorithmName) {
    saltGeneration =
        SaltGenerationAlgorithmFactory.create(saltGenerationAlgorithmName);
    salting = SaltingAlgorithmFactory.create(saltingAlgorithmName);
    hashing = HashingAlgorithmFactory.create(hashingAlgorithmName);
    cropping = CroppingAlgorithmFactory.create(croppingAlgorithmName);
    symbolInsertion =
        SymbolInsertionAlgorithmFactory.create(symbolInsertionAlgorithmName);
  }

  late ISaltGenerationAlgorithm saltGeneration;
  late ISaltingAlgorithm salting;
  late IHashingAlgorithm hashing;
  late ICroppingAlgorithm cropping;
  late ISymbolInsertionAlgorithm symbolInsertion;

  static AlgorithmSet create(String setName) {
    switch (setName.toLowerCase()) {
      case "default":
        return AlgorithmSet("WP", "Additive", "SHA512", "Even", "NPicked");
      default:
        throw FormatException("Unknown algorithm set name");
    }
  }
}

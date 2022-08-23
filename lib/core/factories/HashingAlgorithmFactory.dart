import 'package:fpg/core/algorithms/hashing/SHA512HashingAlgorithm.dart';
import 'package:fpg/core/interfaces/IHashingAlgorithm.dart';

class HashingAlgorithmFactory {
  static IHashingAlgorithm create(String name) {
    switch (name.toLowerCase()) {
      case "sha512":
        return SHA512HashingAlgorithm();
      default:
        throw FormatException("Unknown algorithm name");
    }
  }
}

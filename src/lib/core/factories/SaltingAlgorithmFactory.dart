import 'package:fpg/core/algorithms/salting/AdditiveSaltingAlgorithm.dart';
import 'package:fpg/core/interfaces/ISaltingAlgorithm.dart';

class SaltingAlgorithmFactory {
  static ISaltingAlgorithm create(String name) {
    switch (name.toLowerCase()) {
      case "additive":
        return AdditiveSaltingAlgorithm();
      default:
        throw FormatException("Unknown algorithm name");
    }
  }
}

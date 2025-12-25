import 'package:fpg/core/algorithms/saltgeneration/WPSaltGenerationAlgorithm.dart';
import 'package:fpg/core/interfaces/ISaltGenerationAlgorithm.dart';

class SaltGenerationAlgorithmFactory {
  static ISaltGenerationAlgorithm create(String name) {
    switch (name.toLowerCase()) {
      case "wp":
        return WPSaltGenerationAlgorithm();
      default:
        throw FormatException("Unknown algorithm name");
    }
  }
}

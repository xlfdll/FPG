import 'package:fpg/core/algorithms/cropping/EvenCroppingAlgorithm.dart';
import 'package:fpg/core/interfaces/ICroppingAlgorithm.dart';

class CroppingAlgorithmFactory {
  static ICroppingAlgorithm create(String name) {
    switch (name.toLowerCase()) {
      case "even":
        return EvenCroppingAlgorithm();
      default:
        throw FormatException("Unknown algorithm name");
    }
  }
}

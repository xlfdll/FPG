import 'package:fpg/core/algorithms/symbolinsertion/NPickedSymbolInsertionAlgorithm.dart';
import 'package:fpg/core/interfaces/ISymbolInsertionAlgorithm.dart';

class SymbolInsertionAlgorithmFactory {
  static ISymbolInsertionAlgorithm create(String name) {
    switch (name.toLowerCase()) {
      case "npicked":
        return NPickedSymbolInsertionAlgorithm();
      default:
        throw FormatException("Unknown algorithm name");
    }
  }
}

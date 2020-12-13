import 'package:fpg_mobile/core/algorithms/symbolinsertion/NPickedSymbolInsertionAlgorithm.dart';
import 'package:fpg_mobile/core/interfaces/ISymbolInsertionAlgorithm.dart';

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

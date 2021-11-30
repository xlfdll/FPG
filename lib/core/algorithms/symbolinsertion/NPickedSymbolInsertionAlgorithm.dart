import 'package:fpg_mobile/core/interfaces/ISymbolInsertionAlgorithm.dart';

class NPickedSymbolInsertionAlgorithm implements ISymbolInsertionAlgorithm {
  int pickCount = 1;

  @override
  String insertSymbol(String input, String? symbols) {
    StringBuffer sb = StringBuffer();
    // Dart does not support replace characters in place within StringBuffer
    // Use a map to do linear writing instead
    Map<int, int> indexMap = Map<int, int>();
    int sum = 0;

    input.runes.forEach((element) {
      sum += element;
    });

    for (int i = 0; i < this.pickCount; i++) {
      int inputIndex = ((i + 1) * sum * 701 % input.length).round();
      int symbolIndex = ((i + 1) * sum * 997 % symbols!.length).round();

      // Prefer replacing digits (and not overwriting other symbols)
      int alternativeInputIndex = inputIndex;

      while (alternativeInputIndex < input.length &&
          !isDigit(input, alternativeInputIndex)) {
        alternativeInputIndex++;
      }

      if (alternativeInputIndex == input.length) {
        alternativeInputIndex = inputIndex;

        while (alternativeInputIndex < input.length &&
            symbols.contains(input[alternativeInputIndex])) {
          alternativeInputIndex++;
        }
      }

      if (alternativeInputIndex < input.length &&
          alternativeInputIndex != inputIndex) {
        inputIndex = alternativeInputIndex;
      }

      indexMap[inputIndex] = symbolIndex;
    }

    for (int i = 0; i < input.length; i++) {
      sb.write(indexMap.containsKey(i) ? symbols![indexMap[i]!] : input[i]);
    }

    return sb.toString();
  }

  bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;
}

import 'package:fpg_mobile/core/interfaces/ISaltingAlgorithm.dart';

class AdditiveSaltingAlgorithm implements ISaltingAlgorithm {
  @override
  String salt(List<String> inputs, List<String?> salts) {
    StringBuffer sb = StringBuffer();
    Iterator<String> inputEnumerator = inputs.iterator;
    Iterator<String?> saltEnumerator = salts.iterator;

    // Keyword
    inputEnumerator.moveNext();
    sb.write(inputEnumerator.current);

    // Random Salt
    saltEnumerator.moveNext();
    sb.write(saltEnumerator.current);
    // User Salt
    saltEnumerator.moveNext();
    sb.write(saltEnumerator.current);

    return sb.toString();
  }
}

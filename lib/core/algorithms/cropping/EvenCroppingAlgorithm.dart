import 'package:fpg_mobile/core/interfaces/ICroppingAlgorithm.dart';

class EvenCroppingAlgorithm implements ICroppingAlgorithm {
  @override
  String crop(String input, int length) {
    StringBuffer sb = StringBuffer();

    for (int i = 0, j = length; i < length; i++, j++) {
      if ((j + i) == input.length) {
        j = 0;
      }

      sb.write(i % 2 == 0 ? input[j + i].toUpperCase() : input[j + i]);
    }

    return sb.toString();
  }
}

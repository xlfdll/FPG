import 'package:crypto/crypto.dart';
import 'package:fpg_mobile/core/interfaces/IHashingAlgorithm.dart';
import 'package:fpg_mobile/core/util/UTF16BEByteEncoder.dart';

class SHA512HashingAlgorithm implements IHashingAlgorithm {
  @override
  String hash(String input) {
    List<int> bytes = UTF16BEByteEncoder.encode(input);
    Digest digest = sha512.convert(bytes);

    return digest.toString();
  }
}

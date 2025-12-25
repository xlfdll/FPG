import 'package:crypto/crypto.dart';
import 'package:fpg/core/interfaces/IHashingAlgorithm.dart';
import 'package:fpg/core/util/UTF16BEByteEncoder.dart';

class SHA512HashingAlgorithm implements IHashingAlgorithm {
  @override
  String hash(String input) {
    List<int?> bytes = UTF16BEByteEncoder.encode(input);
    Digest digest = sha512.convert(bytes as List<int>);

    return digest.toString();
  }
}

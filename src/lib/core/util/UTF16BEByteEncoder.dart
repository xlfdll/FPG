import 'ListRange.dart';

class UTF16BEByteEncoder {
  static const int UNICODE_REPLACEMENT_CHARACTER_CODEPOINT = 0xfffd;
  static const int UNICODE_UTF_BOM_LO = 0xff;
  static const int UNICODE_UTF_BOM_HI = 0xfe;
  static const int UNICODE_BYTE_ZERO_MASK = 0xff;
  static const int UNICODE_BYTE_ONE_MASK = 0xff00;
  static const int UNICODE_VALID_RANGE_MAX = 0x10ffff;
  static const int UNICODE_PLANE_ONE_MAX = 0xffff;
  static const int UNICODE_UTF16_RESERVED_LO = 0xd800;
  static const int UNICODE_UTF16_RESERVED_HI = 0xdfff;
  static const int UNICODE_UTF16_OFFSET = 0x10000;
  static const int UNICODE_UTF16_SURROGATE_UNIT_0_BASE = 0xd800;
  static const int UNICODE_UTF16_SURROGATE_UNIT_1_BASE = 0xdc00;
  static const int UNICODE_UTF16_HI_MASK = 0xffc00;
  static const int UNICODE_UTF16_LO_MASK = 0x3ff;

  static List<int?> encode(String input, [bool writeBOM = false]) {
    var utf16CodeUnits = _codepointsToUtf16CodeUnits(input.codeUnits);
    var encoding =
        List<int>.filled(2 * utf16CodeUnits.length + (writeBOM ? 2 : 0), 0);
    var i = 0;
    if (writeBOM) {
      encoding[i++] = UNICODE_UTF_BOM_HI;
      encoding[i++] = UNICODE_UTF_BOM_LO;
    }
    for (var unit in utf16CodeUnits) {
      encoding[i++] = (unit! & UNICODE_BYTE_ONE_MASK) >> 8;
      encoding[i++] = unit & UNICODE_BYTE_ZERO_MASK;
    }
    return encoding;
  }

  static List<int?> _codepointsToUtf16CodeUnits(List<int> codepoints,
      [int offset = 0,
      int? length,
      int replacementCodepoint = UNICODE_REPLACEMENT_CHARACTER_CODEPOINT]) {
    var listRange = ListRange(codepoints, offset, length);
    var encodedLength = 0;

    for (var value in listRange) {
      if ((value >= 0 && value < UNICODE_UTF16_RESERVED_LO) ||
          (value > UNICODE_UTF16_RESERVED_HI &&
              value <= UNICODE_PLANE_ONE_MAX)) {
        encodedLength++;
      } else if (value > UNICODE_PLANE_ONE_MAX &&
          value <= UNICODE_VALID_RANGE_MAX) {
        encodedLength += 2;
      } else {
        encodedLength++;
      }
    }

    var codeUnitsBuffer = List<int>.filled(encodedLength, 0);
    var j = 0;

    for (var value in listRange) {
      if ((value >= 0 && value < UNICODE_UTF16_RESERVED_LO) ||
          (value > UNICODE_UTF16_RESERVED_HI &&
              value <= UNICODE_PLANE_ONE_MAX)) {
        codeUnitsBuffer[j++] = value;
      } else if (value > UNICODE_PLANE_ONE_MAX &&
          value <= UNICODE_VALID_RANGE_MAX) {
        var base = value - UNICODE_UTF16_OFFSET;

        codeUnitsBuffer[j++] = UNICODE_UTF16_SURROGATE_UNIT_0_BASE +
            ((base & UNICODE_UTF16_HI_MASK) >> 10);
        codeUnitsBuffer[j++] = UNICODE_UTF16_SURROGATE_UNIT_1_BASE +
            (base & UNICODE_UTF16_LO_MASK);
      } else if (replacementCodepoint != null) {
        codeUnitsBuffer[j++] = replacementCodepoint;
      } else {
        throw ArgumentError('Invalid encoding');
      }
    }

    return codeUnitsBuffer;
  }
}

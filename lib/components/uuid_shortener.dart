import 'dart:convert';

import 'package:crypto/crypto.dart';

class UuidShortener {
  // Function to convert UUID to a short code
  static String convertToShortUuid(String uuid) {
    // Create a SHA-1 hash of the UUID
    var bytes = utf8.encode(uuid);
    var digest = sha1.convert(bytes);

    // Extract 3 bytes (24 bits) of the hash and convert it to a hexadecimal string
    String shortUuid = digest.bytes.sublist(0, 3).map((byte) {
      return byte.toRadixString(16).padLeft(2, '0');
    }).join();

    // Convert to uppercase and add a prefix
    return '#${shortUuid.toUpperCase()}';
  }
}
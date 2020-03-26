import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';


class Utils {
  static final Random _random = Random.secure();

  static String createCryptoRandomString([int length = 50]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  static String convertTosha256(String str) {
    var bytes = utf8.encode(str);
    return sha256.convert(bytes).toString();
  }
}
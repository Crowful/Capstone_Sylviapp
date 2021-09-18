import 'package:encrypt/encrypt.dart' as crypto;

class AESCryptography {
  static final key = crypto.Key.fromLength(32);
  static final iv = crypto.IV.fromLength(64);
  static final encrypter = crypto.Encrypter(crypto.AES(key));

  static encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted;
  }

  static decryptAES(text) {
    return encrypter.decrypt(text, iv: iv);
  }
}

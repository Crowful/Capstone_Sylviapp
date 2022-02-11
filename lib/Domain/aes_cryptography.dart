import 'package:encrypt/encrypt.dart' as enc;

class AESCryptography {
  final iv = enc.IV.fromLength(16);
  final encrypter = enc.Encrypter(enc.AES(enc.Key.fromLength(32)));

  encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  decryptAES(enc.Encrypted text) {
    final decrypted = encrypter.decrypt(text, iv: iv).toString();
    print(decrypted);

    return decrypted;
  }
}

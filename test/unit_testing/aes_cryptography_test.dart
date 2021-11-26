import 'package:flutter_test/flutter_test.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;

void main() {
  test('Not Expecting exact value when encrypted', () {
    var encrption = AESCryptography();
    var exampleString = 'sentence to be encrypted';

    var result = encrption.encryptAES(exampleString);

    expect(result != exampleString, true);
  });

  test('Retrieve the original value after the process', () {
    var encrption = AESCryptography();
    var exampleString = 'sentence to be encrypted';

    var encryptedString = encrption.encryptAES(exampleString);

    var decryptedString =
        encrption.decryptAES(enc.Encrypted.fromBase64(encryptedString));

    expect(decryptedString == exampleString, true);
  });
}

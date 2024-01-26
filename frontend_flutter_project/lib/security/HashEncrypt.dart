import 'package:encrypt/encrypt.dart';
import 'package:bcrypt/bcrypt.dart';

class EncryptDecrypt {
  static final key = Key.fromSecureRandom(32);
  static final iv = IV.fromSecureRandom(16);
  static final encrypter = Encrypter(AES(key));

  static encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted;
  }

  static decryptAES(text) {
    final decrypted = encrypter.decrypt(text, iv: iv);
    return decrypted;
  }
}

/*void main() {
  //String text = 'CJ/pKZMbOLdk01nlMBvlHQ==';
  final decryptedText = EncryptDecrypt.decryptAES("CJ/pKZMbOLdk01nlMBvlHQ==");
  print(decryptedText);
}*/

class HashPassword {
  HashedResult hash(String text) {
    final String salt = BCrypt.gensalt();
    final String hashed = BCrypt.hashpw(text, salt);
    print(text);
    print(salt);
    print(hashed);
    print("hashing done");
    return HashedResult(hashed, salt);
  }
}

class HashedResult {
  final String hashed;
  final String salt;

  HashedResult(this.hashed, this.salt);
}

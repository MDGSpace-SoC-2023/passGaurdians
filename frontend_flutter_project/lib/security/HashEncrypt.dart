import 'package:encrypt/encrypt.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:passGuard/api_connection/auth_api.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class EncryptDecrypt {
  static const int iterations = 10000;
  static const int bits = 256;

  Future<EncryptInfo> deriveKeyAndIV(
      String password, String bcryptSalt, String email) async {
    final saltBytes = Uint8List.fromList(utf8.encode(bcryptSalt.substring(7)));

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: bits,
    );

    final secretKey = await pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: saltBytes,
    );

    final secretKeyBytes = await secretKey.extractBytes();
    var userEmailBytes = utf8.encode(email);

    print('Secret Key Length: ${secretKeyBytes.length}');
    print('User Email Length: ${userEmailBytes.length}');

    if (userEmailBytes.length < 16) {
      final paddedBytes = Uint8List(16);
      paddedBytes.setAll(0, userEmailBytes);
      userEmailBytes = paddedBytes;
    }

    final ivBytes = userEmailBytes;
    print("iv bytes length $ivBytes");
    final iv_ = Uint8List.fromList(ivBytes);
    print("iv bytes length $iv_");
    final iv = IV(Uint8List.fromList(ivBytes));
    print(iv);
    final key = Key(Uint8List.fromList(secretKeyBytes));

    final encrypter = Encrypter(AES(key));
    return EncryptInfo(key, iv, encrypter);
  }

  Future encryptAES(text, token) async {
    final response = await UserInfo(token);
    final info =
        await deriveKeyAndIV(response.password, response.salt, response.email);
    final encrypted = info.encrypter.encrypt(text, iv: info.iv);
    return encrypted.base64;
  }

  Future decryptAES(text, token) async {
    final response = await UserInfo(token);
    final info =
        await deriveKeyAndIV(response.password, response.salt, response.email);
    final decrypted = info.encrypter.decrypt(text, iv: info.iv);
    return decrypted;
  }
}

class EncryptInfo {
  final Key key;
  final IV iv;
  final Encrypter encrypter;

  EncryptInfo(this.key, this.iv, this.encrypter);
}

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

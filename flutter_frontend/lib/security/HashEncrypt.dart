import 'package:encrypt/encrypt.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:passGuard/api_connection/auth_api.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:passGuard/screens/homepage.dart';

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

  Future encryptAES(String title, String username, dynamic password,
      dynamic website, String details, String token) async {
    final response = await UserInfo(token);
    final info =
        await deriveKeyAndIV(response.password, response.salt, response.email);
    final key = info.key;
    final iv = info.iv;
    final encrypter = info.encrypter;
    String Title =
        title.isNotEmpty ? encrypter.encrypt(title, iv: iv).base64 : "";
    print("title done");
    print(username);
    String Username =
        username.isNotEmpty ? encrypter.encrypt(username, iv: iv).base64 : "";
    print("username done");
    String Password =
        password.isNotEmpty ? encrypter.encrypt(password, iv: iv).base64 : "";
    print("password done");
    dynamic Website =
        website.isNotEmpty ? encrypter.encrypt(website, iv: iv).base64 : "";
    print("website done");
    String Details =
        details.isNotEmpty ? encrypter.encrypt(details, iv: iv).base64 : "";
    print("details done");
    return PasswordItem(
        title: Title,
        username: Username,
        password: Password,
        website: Website,
        notes: Details);
  }

    Future decryptAES(dynamic title, dynamic username, dynamic password,
      dynamic website, dynamic details, String token) async {
    final response = await UserInfo(token);
    final info =
        await deriveKeyAndIV(response.password, response.salt, response.email);
    final key = info.key;
    final iv = info.iv;
    final encrypter = info.encrypter;
    String Title =
        title.isNotEmpty ? encrypter.decrypt64(title, iv: iv) : "";
    print("title done");
    print(username);
    String Username =
        username.isNotEmpty ? encrypter.decrypt64(username, iv: iv): "";
    print("username done");
    String Password =
        password.isNotEmpty ? encrypter.decrypt64(password, iv: iv): "";
    print("password done");
    dynamic Website =
        website.isNotEmpty ? encrypter.decrypt64(website, iv: iv) : "";
    print("website done");
    String Details =
        details.isNotEmpty ? encrypter.decrypt64(details, iv: iv) : "";
    print("details done");
    return PasswordItem(
        title: Title,
        username: Username,
        password: Password,
        website: Website,
        notes: Details);
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

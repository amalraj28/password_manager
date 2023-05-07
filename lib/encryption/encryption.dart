import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/db/database.dart';

class Encryption {
  // ignore: prefer_const_constructors
  static final secureStorage = FlutterSecureStorage();

  static _getMasterPassword() async {
    var s = await secureStorage.read(key: 'key');
    return s;
  }

  static _generateRandomSalt(length) {
    var random = Random.secure();
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    var salt = List.generate(length, (_) => chars[random.nextInt(chars.length)])
        .join();
    return salt;
  }

  static encryptText(text) async {
    var masterPass = await _getMasterPassword();
    var salt = await _generateRandomSalt(32 - masterPass.length);

    final key = Key.fromUtf8('$masterPass$salt');
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);

    return [encrypted, salt, iv];
  }

  static getDecryptedPassword(String platform) async {
    // Get entry from database
    var data = UserDatabase.findItemFromDb(key: platform);
    var userData = data[0];
    var metaData = data[1];

    // Get salt and iv from metadata
    String salt = metaData['salt'];
    IV iv = IV.fromBase64(metaData['iv']);

    // Get encrypted password from userData
    var encryptPass = Encrypted.fromBase64(userData['password']);

    // Get master Password
    String masterPass = await _getMasterPassword();

    // Get key
    Key key = Key.fromUtf8('$masterPass$salt');

    // Decrypt password
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    var pwd = encrypter.decrypt(encryptPass, iv: iv);
    return pwd;
  }

  static masterPassword() async {
    return _getMasterPassword();
  }
}

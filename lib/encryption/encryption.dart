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

  // static _generateKey(String password, List<int> salt) async {
  //   final pbkdf2 = Pbkdf2.hmacSha256(iterations: 10000, bits: 256);
  //   final secretKey =
  //       await pbkdf2.deriveKeyFromPassword(password: password, nonce: salt);
  //   return secretKey;
  // }

  // static encryptUsingAES(text) async {
  //   // Define algorithm
  //   final algorithm = AesCbc.with256bits(macAlgorithm: Hmac.sha256());

  //   // Derive list of integers as salt
  //   final salt = List<int>.generate(128, (_) => Random.secure().nextInt(128));

  //   //Get the master password
  //   final masterPass = await Encryption.secureStorage.read(key: 'key');

  //   // Use salt and master password to generate key
  //   final secretKey = await _generateKey(masterPass!, salt);

  //   //Encrypt the string
  //   var encrypted = await algorithm.encryptString(text, secretKey: secretKey);

  //   // Get encrypted stream as string
  //   var encryptionAsString = String.fromCharCodes(encrypted.cipherText);

  //   // Convert list of int to string
  //   String saltAsString = String.fromCharCodes(salt);

  //   return [encryptionAsString, saltAsString];
  // }

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
    String salt = metaData['salt'] ?? '';
    IV iv = IV.fromBase64(metaData['iv'] ?? '');

    // Get encrypted password from userData
    var encryptPass = Encrypted.fromBase64(userData['password'] ?? '');

    // Get master Password
    String masterPass = await _getMasterPassword();

    if (salt.isEmpty || iv.base64.isEmpty || encryptPass.base64.isEmpty) {
      throw Exception(
        'Error in getDecryptedPassword function -> The value obtained from database is null',
      );
    }

    // Get key
    Key key = Key.fromUtf8('$masterPass$salt');

    // Decrypt password
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    try {
      return encrypter.decrypt(encryptPass, iv: iv);
    } catch (e) {
      // How to handle this?
    }
  }

  static masterPassword() async {
    return _getMasterPassword();
  }
}

import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/models/data_models.dart';

class Encryption {
  static _getMasterPassword() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'key');
  }

  static _generateRandomSalt(length) {
    var random = Random.secure();
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    var salt = List.generate(length, (_) => chars[random.nextInt(chars.length)])
        .join();
    return salt;
  }

  static encrypt(text) async {
    var masterPass = await _getMasterPassword();
    var salt = _generateRandomSalt(32 - text.length);

    final key = Key.fromUtf8('$masterPass$salt');
    print(key);
    final iv = IV.fromSecureRandom(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);

    return [encrypted, salt, iv];
  }

  static decrypt(Encrypted encrypter, PasswordSalt metadata) {
    var key = Key.fromUtf8('${_getMasterPassword()}${metadata.salt}');
    var decrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return decrypter.decrypt(encrypter, iv: IV.fromUtf8(metadata.iv));
  }
}

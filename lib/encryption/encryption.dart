import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/db/database.dart';
import 'package:password_manager/models/data_models.dart';

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

  static Future<String> getDecryptedPassword(String platform) async {
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
    return encrypter.decrypt(encryptPass, iv: iv);
  }

  static masterPassword() async {
    return _getMasterPassword();
  }

  static Future<bool> updateMasterPassword(
      {required String newMasterPassword}) async {
    if (newMasterPassword.length > 26) return false;
    var storage = Encryption.secureStorage;
    String oldMasterPassword = await masterPassword();

    if (oldMasterPassword == '') {
      return false;
    }

    // Check if data is present
    bool dataIsPresent = UserDatabase.checkIfDataPresent();

    // if data is not present, simply update master password
    if (!dataIsPresent) {
      Encryption.secureStorage.write(key: 'key', value: newMasterPassword);
      return true;
    }

    // else update master password for each entry
    // 1). Get all data in database
    var database = UserDatabase.getData();
    int flag = 0; // To know if for loop successfully or not

    // 2). For each entry, get old password
    for (var data in database) {
      flag++;
      var userData = data[0];
      var metaData = data[1];

      var platform = userData['platform'];
      var username = userData['username'];
      var salt = metaData['salt'];
      var iv = metaData['iv'];

      if (platform == null || username == null || salt == null || iv == null) {
        throw ArgumentError(
          ['Error in function updateMasterPassword -> Argument is null'],
        );
      }

      var userPassword = await getDecryptedPassword(platform);

      // Change to new master password
      await storage.write(key: 'key', value: newMasterPassword);
      var newEncryption = await encryptText(userPassword);
      var newPassword = newEncryption[0].base64;
      var newSalt = newEncryption[1];
      var newIV = newEncryption[2].base64;

      // Delete previous data from database
      UserDatabase.deleteItemFromDb(platform);

      // Add new data to database
      var newUserData = DataModel(username, newPassword, platform);
      var newMetaData = PasswordSalt(platform, newSalt, newIV);

      await UserDatabase.addData(
          data: newUserData, encryptionMetadata: newMetaData);

      // Change master password to old master password for the next data
      await storage.write(key: 'key', value: oldMasterPassword);
    }

    bool status = flag == database.length;

    if (status) {
      await storage.write(key: 'key', value: newMasterPassword);
    }

    return status;
  }
}

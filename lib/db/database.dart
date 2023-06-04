import 'package:password_manager/encryption/encryption.dart';
import 'package:password_manager/models/data_models.dart';
import 'package:password_manager/scripts/realm_to_non_realm.dart';
import 'package:realm/realm.dart';

class UserDatabase {
  static Realm _openDatabase() {
    final Configuration config = Configuration.local(
        [DataModel.schema, PasswordSalt.schema],
        schemaVersion: 1, shouldDeleteIfMigrationNeeded: true);
    final Realm realm = Realm(config);
    return realm;
  }

  static addData(
      {required DataModel data,
      required PasswordSalt encryptionMetadata}) async {
    var realm = _openDatabase();
    bool duplicatePrimaryKey;
    try {
      await Future.sync(() {
        realm.write(() {
          realm.add(data);
          realm.add(encryptionMetadata);
        });
      });
      duplicatePrimaryKey = false;
    } on RealmException {
      duplicatePrimaryKey = true;
    } finally {
      realm.close();
    }
    return duplicatePrimaryKey;
  }

  static void clearData() async {
    var realm = _openDatabase();
    realm.write(() {
      realm.deleteAll<DataModel>();
      realm.deleteAll<PasswordSalt>();
    });
    realm.close();
  }

  static List<List<Map<String, String>>> getData() {
    Realm realm = _openDatabase();
    var userData = realm.all<DataModel>();
    var metaData = realm.all<PasswordSalt>();

    if (userData.length != metaData.length) {
      throw Exception(
        'Error in stored data. Metadata and userdata are not equal in number',
      );
    }

    List<List<Map<String, String>>> data = [];

    for (int i = 0; i < userData.length; i++) {
      var userDataMap = createObjectMapping(userData[i]);
      var metaDataMap = createObjectMapping(metaData[i]);

      data.add([userDataMap, metaDataMap]);
    }

    realm.close();
    return data;
  }

  static bool checkIfDataPresent() {
    var items = UserDatabase.getData();

    return items.isNotEmpty;
  }

  static List<Map<String, String>> findItemFromDb({required String key}) {
    Realm realm = _openDatabase();
    var userData = realm.find<DataModel>(key);
    var metaData = realm.find<PasswordSalt>(key);

    if (userData != null && metaData != null) {
      // realm.close();
      return [createObjectMapping(userData), createObjectMapping(metaData)];
    } else {
      throw Exception(
        'Error in function: findItemFromDb -> Item not found in database',
      );
    }
  }

  static deleteItemFromDb(key) {
    Realm realm = _openDatabase();
    var userData = realm.find<DataModel>(key);
    var metaData = realm.find<PasswordSalt>(key);

    if (userData == null || metaData == null) return;

    realm.write(() {
      realm.delete<DataModel>(userData);
      realm.delete<PasswordSalt>(metaData);
    });

    realm.close();
  }

  static updateItem(platform, String username, String password) async {
    var realm = _openDatabase();
    var userData = realm.find<DataModel>(platform);
    var metaData = realm.find<PasswordSalt>(platform);

    if (userData == null || metaData == null) return;

    if (password.isNotEmpty) {
      var newPassData = await Encryption.encryptText(password);
      var newEncryptedPass = newPassData[0];
      var newSalt = newPassData[1];
      var newIV = newPassData[2];

      realm.write(() {
        userData.password = newEncryptedPass.base64;
        metaData.salt = newSalt;
        metaData.iv = newIV.base64;
      });
    }

    if (username.isNotEmpty) {
      realm.write(() => userData.username = username);
    }
    realm.close();
  }
}

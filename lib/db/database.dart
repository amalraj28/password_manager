import 'package:password_manager/models/data_models.dart';
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
    await Future.sync(() {
      realm.write(() {
        realm.deleteAll<DataModel>();
        realm.deleteAll<PasswordSalt>();
      });
    });
    realm.close();
  }

  static getData() {
    Realm realm = _openDatabase();
    var items = realm.all<DataModel>();
    return items;
  }

  static checkIfDataPresent() {
    var items = UserDatabase.getData();
    if (items.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static findItemFromDb({required String key}) {
    Realm realm = _openDatabase();
    var data = realm.find<DataModel>(key);
    var metaData = realm.find<PasswordSalt>(key);
    var userData = Map.identity();
    var userMetaData = Map.identity();
    if (data != null) {
      userData = {
        'platform': data.platform,
        'username': data.username,
        'password': data.password
      };
    }

    if (metaData != null) {
      userMetaData = {
        'platform': metaData.platform,
        'salt': metaData.salt,
        'iv': metaData.iv
      };
    }
    realm.close();
    return [userData, userMetaData];
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
}

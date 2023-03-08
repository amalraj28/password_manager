import 'package:password_manager/models/data_models.dart';
import 'package:realm/realm.dart';

class UserDatabase {
  static Realm _openDatabase() {
    final Configuration config = Configuration.local([DataModel.schema],
        schemaVersion: 1, shouldDeleteIfMigrationNeeded: true);
    final Realm realm = Realm(config);
    return realm;
  }

  static Future<void> addData(
      {platform = String, username = String, password = String}) async {
    var realm = _openDatabase();
    await Future.sync(() {
      realm.write(() {
        realm.add(
          DataModel(username, password, platform),
        );
      });
    });
    realm.close();
  }

  static void clearData() async {
    var realm = _openDatabase();
    await Future.sync(() {
      realm.write(() {
        realm.deleteAll<DataModel>();
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
    // bool deleted;
    var data = realm.find<DataModel>(key);
    realm.close();
    return data;
  }

  static deleteItemFromDb(key) {
    Realm realm = _openDatabase();
    var data = realm.find<DataModel>(key)!;
    realm.write(() {
      realm.delete<DataModel>(data);
    });
    realm.close();
  }
}

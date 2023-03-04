import 'package:password_manager/models/data_models.dart';
import 'package:realm/realm.dart';

class UserDatabase {
  static Realm openDatabase() {
    final Configuration config = Configuration.local([DataModel.schema]);
    final Realm realm = Realm(config);
    return realm;
  }

  static Future<void> addData(
      {platform = String, username = String, password = String}) async {
    var realm = openDatabase();
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
    var realm = openDatabase();
    await Future.sync(() {
      realm.write(() {
        realm.deleteAll<DataModel>();
      });
    });
    realm.close();
  }

  static getData() {
    Realm realm = UserDatabase.openDatabase();
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
}

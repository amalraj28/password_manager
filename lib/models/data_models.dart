import 'package:realm/realm.dart';

part 'data_models.g.dart';

@RealmModel()
class _DataModel {
  late String username;
  late String password;
  @PrimaryKey()
  late String platform;
}

@RealmModel()
class _PasswordSalt {
  @PrimaryKey()
  late String platform;
  late String salt;
  late String iv;
}

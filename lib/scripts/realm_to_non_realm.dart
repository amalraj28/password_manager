import 'package:password_manager/models/data_models.dart';
import 'package:realm/realm.dart';

Map<String, String> createObjectMapping(RealmObject object) {
  if (object is DataModel) {
    return {
      'platform': object.platform,
      'username': object.username,
      'password': object.password
    };
  } else if (object is PasswordSalt) {
    return {'platform': object.platform, 'salt': object.salt, 'iv': object.iv};
  } else {
    throw Exception('Argument of the function must be a RealmObject');
  }
}

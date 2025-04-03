import 'dart:developer';

import 'package:counter_x/hiveModels/UserHiveModel.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserServices {
  
  static const String userBox = 'userBox';
  static const String _userKey = 'currentUser';

  static Future<void> saveUser(String uid) async {
    final box = await Hive.openBox<UserHiveModel>(userBox);
    final user = UserHiveModel(uid: uid);
    await box.put(_userKey, user);
    log('User saved: ${user.toJson()}');
    await box.close();
  }
  static Future<UserHiveModel?> getUser() async {
    final box = await Hive.openBox<UserHiveModel>(userBox);
    final user = box.get(_userKey);
    await box.close();
    return user;
  }
  static Future<void> deleteUser() async {
    final box = await Hive.openBox<UserHiveModel>(userBox);
    await box.delete(_userKey);
    log("user deleq");
    await box.close();
  }

}
import 'package:hive/hive.dart';

part 'UserHiveModel.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  String? uid;

  UserHiveModel({required this.uid});

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
    };
  }

  // Create an object from JSON
  factory UserHiveModel.fromJson(Map<String, dynamic> json) {
    return UserHiveModel(
      uid: json['uid'] as String?,
    );
  }
}

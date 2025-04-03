

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? profilePic;
  DateTime? createdAt;
  bool? subscription;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.profilePic,
    this.createdAt,
    this.subscription,
  });

  // Convert UserModel to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'createdAt': createdAt?.toIso8601String(),
      'subscription': subscription,
    };
  }

  // Convert Firestore JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profilePic: json['profilePic'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      subscription: json['subscription'],
    );
  }
}

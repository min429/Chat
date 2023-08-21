import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  final String userId;
  final String userPwd;
  final String userName;

  User({required this.userId, required this.userPwd, required this.userName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      userPwd: json['userPwd'],
      userName: json['userName'],
    );
  }

  // jsonEncode를 위해 필요
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userPwd': userPwd,
      'userName': userName,
    };
  }
}

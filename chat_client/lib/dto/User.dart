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
}

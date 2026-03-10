class UserData {
  final int idUser;
  final String userName;
  final String role;
  final int status;

  UserData({
    required this.idUser,
    required this.userName,
    required this.role,
    required this.status,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      idUser: json['idUser'],
      userName: json['userName'],
      role: json['role'],
      status: json['status'],
    );
  }
}

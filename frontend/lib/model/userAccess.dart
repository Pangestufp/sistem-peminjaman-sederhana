class UserAccess {
  final int idUser;
  final int approve;
  final int reject;
  final int pay;
  final int viewAll;

  UserAccess({
    required this.idUser,
    required this.approve,
    required this.reject,
    required this.pay,
    required this.viewAll,
  });

  factory UserAccess.fromJson(Map<String, dynamic> json) {
    return UserAccess(
      idUser: json['idUser'],
      approve: json['approve'],
      reject: json['reject'],
      pay: json['pay'],
      viewAll: json['viewAll'],
    );
  }
}

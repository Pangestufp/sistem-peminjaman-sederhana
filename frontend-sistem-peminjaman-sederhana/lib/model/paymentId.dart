class PaymentId {
  final String docNo;
  final int id;

  PaymentId({required this.docNo, required this.id});

  factory PaymentId.fromJson(Map<String, dynamic> json) {
    return PaymentId(
      docNo: json['docNo'],
      id: json['id'],
    );
  }
}

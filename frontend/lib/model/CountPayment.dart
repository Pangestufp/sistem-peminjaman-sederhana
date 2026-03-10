class CountPayment {
  final int total;
  final String maxPaymentDate;

  CountPayment({
    required this.total,
    required this.maxPaymentDate,
  });

  factory CountPayment.fromJson(Map<String, dynamic> json) {
    return CountPayment(
      total: json['total'],
      maxPaymentDate: json['maxPaymentDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'maxPaymentDate': maxPaymentDate,
    };
  }
}
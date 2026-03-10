import 'package:apppeminjaman/model/PaymentId.dart';

class Payment {
  final PaymentId id;
  final double total;
  final int maxPaymentDate;
  final int? paymentDate;
  final String status;

  Payment({
    required this.id,
    required this.total,
    required this.maxPaymentDate,
    required this.paymentDate,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: PaymentId.fromJson(json['id']),
      total: (json['total'] ?? 0).toDouble(),
      maxPaymentDate: json['maxPaymentDate'],
      paymentDate: json['paymentDate'],
      status: json['status'],
    );
  }
}

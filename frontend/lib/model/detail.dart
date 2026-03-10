

import 'package:apppeminjaman/model/PaymentId.dart';

class Detail {
  final PaymentId id;
  final double subTotal;
  final String text;

  Detail({
    required this.id,
    required this.subTotal,
    required this.text,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      id: PaymentId.fromJson(json['id']),
      subTotal: (json['subTotal'] ?? 0).toDouble(),
      text: json['text'],
    );
  }
}

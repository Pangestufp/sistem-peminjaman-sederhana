
import 'package:apppeminjaman/model/Assign.dart';
import 'package:apppeminjaman/model/CountPayment.dart';
import 'package:apppeminjaman/model/DetailItem.dart';

class CreateDocRequest {
  final String creatorName;
  final String payerName;
  final int bunga;
  final List<DetailItem> detail;
  final List<CountPayment> payment;
  final List<Assign> assign;

  CreateDocRequest({
    required this.creatorName,
    required this.payerName,
    required this.bunga,
    required this.detail,
    required this.payment,
    required this.assign,
  });

  Map<String, dynamic> toJson() {
    return {
      'creatorName': creatorName,
      'payerName': payerName,
      'bunga': bunga,
      'detail': detail.map((item) => item.toJson()).toList(),
      'payment': payment.map((item) => item.toJson()).toList(),
      'assign': assign.map((item) => item.toJson()).toList(),
    };
  }
}

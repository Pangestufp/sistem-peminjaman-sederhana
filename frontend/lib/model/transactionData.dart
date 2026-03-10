

import 'package:apppeminjaman/model/Detail.dart';
//import 'package:apppeminjaman/model/Header.dart';

import 'package:apppeminjaman/model/Payment.dart';
import 'package:apppeminjaman/model/Workflow.dart';
import 'package:apppeminjaman/model/header.dart';

class TransactionData {
  final List<Payment> payments;
  final Header header;
  final List<Detail> details;
  final List<Workflow> workflows;

  TransactionData({
    required this.payments,
    required this.header,
    required this.details,
    required this.workflows,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      payments: (json['payments'] as List).map((e) => Payment.fromJson(e)).toList(),
      header: Header.fromJson(json['header']),
      details: (json['details'] as List).map((e) => Detail.fromJson(e)).toList(),
      workflows: (json['workflows'] as List).map((e) => Workflow.fromJson(e)).toList(),
    );
  }
}

class Header {
  final String docNo;
  final int creatorId;
  final String creatorName;
  final int payerId;
  final String payerName;
  final int createdDate;
  final double allTotal;
  final int bunga;
  final String status;

  Header({
    required this.docNo,
    required this.creatorId,
    required this.creatorName,
    required this.payerId,
    required this.payerName,
    required this.createdDate,
    required this.allTotal,
    required this.bunga,
    required this.status,
  });

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      docNo: json['docNo'],
      creatorId: json['creatorId'],
      creatorName: json['creatorName'],
      payerId: json['payerId'],
      payerName: json['payerName'],
      createdDate: json['createdDate'],
      allTotal: (json['allTotal'] ?? 0).toDouble(),
      bunga: json['bunga'],
      status: json['status'],
    );
  }
}

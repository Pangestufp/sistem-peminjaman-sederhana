class WorkflowId {
  final String docNo;
  final int id;
  final int pararel;

  WorkflowId({required this.docNo, required this.id, required this.pararel});

  factory WorkflowId.fromJson(Map<String, dynamic> json) {
    return WorkflowId(
      docNo: json['docNo'],
      id: json['id'],
      pararel: json['pararel'],
    );
  }
}


import 'package:apppeminjaman/model/WorkflowId.dart';

class Workflow {
  final WorkflowId id;
  final int assignedId;
  final String assignedName;
  final String assignedAction;
  final String? action;
  final int? actionDate;
  final String? reason;

  Workflow({
    required this.id,
    required this.assignedId,
    required this.assignedName,
    required this.assignedAction,
    required this.action,
    required this.actionDate,
    required this.reason,
  });

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      id: WorkflowId.fromJson(json['id']),
      assignedId: json['assignedId'],
      assignedName: json['assignedName'],
      assignedAction: json['assignedAction'],
      action: json['action'],
      actionDate: json['actionDate'],
      reason: json['reason'],
    );
  }
}

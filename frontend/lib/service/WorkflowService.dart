import 'package:apppeminjaman/model/Workflow.dart';

import 'package:apppeminjaman/authentification/ApiService.dart';

class WorkflowService {
  final ApiService _apiService = ApiService();

  Future<List<Workflow>> getAssignedWorkflows() async {
    try {
      final response = await _apiService.get('/peminjaman/getAssignedWorkflow');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((item) => Workflow.fromJson(item)).toList();
      } else {
        print('Gagal mengambil data workflow. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error saat mengambil data workflow: $e');
      return [];
    }
  }
}

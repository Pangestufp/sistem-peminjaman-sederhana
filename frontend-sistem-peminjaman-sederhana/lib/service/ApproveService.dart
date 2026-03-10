import 'package:apppeminjaman/authentification/ApiService.dart';

class ApproveService {
  final ApiService _apiService = ApiService();

  Future<String?> approveDocument({required String docNo, required String reason}) async {
    try {
      final data = {
        "docNo": docNo,
        "action": "APPROVE",
        "reason": reason,
      };

      final response = await _apiService.post('/peminjaman/approve', data);

      if (response.statusCode == 200) {
        final message = response.data['message'] ?? 'Approve Done';
        print(message);
        return message;
      } else {
        print('Gagal melakukan approve. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat melakukan approve dokumen: $e');
      return null;
    }
  }
}

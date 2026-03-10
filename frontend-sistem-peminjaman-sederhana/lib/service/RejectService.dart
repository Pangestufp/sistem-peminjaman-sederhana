import 'package:apppeminjaman/authentification/ApiService.dart';

class RejectService {
  final ApiService _apiService = ApiService();

  Future<String?> rejectDocument({required String docNo, required String reason}) async {
    try {
      final data = {
        "docNo": docNo,
        "action": "REJECT",
        "reason": reason,
      };

      final response = await _apiService.post('/peminjaman/reject', data);

      if (response.statusCode == 200) {
        final message = response.data['message'] ?? 'Reject Done';
        print(message);
        return message;
      } else {
        print('Gagal melakukan reject. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat melakukan reject dokumen: $e');
      return null;
    }
  }
}

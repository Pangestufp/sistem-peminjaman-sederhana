import 'package:apppeminjaman/authentification/ApiService.dart';

class PaymentService {
  final ApiService _apiService = ApiService();

  Future<String?> processPayment(String docNo) async {
    try {
      final data = {
        "docNo": docNo,
      };

      final response = await _apiService.post('/peminjaman/payment', data);

      if (response.statusCode == 200) {
        final message = response.data['message'] ?? 'Payment Done';
        print(message);
        return message;
      } else {
        print('Gagal melakukan pembayaran. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat melakukan pembayaran: $e');
      return null;
    }
  }
}

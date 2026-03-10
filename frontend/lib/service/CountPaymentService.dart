import 'package:apppeminjaman/authentification/ApiService.dart';
import 'package:apppeminjaman/model/CountPayment.dart';

class CountPaymentService {
  final ApiService _apiService = ApiService();

  Future<List<CountPayment>?> countPayment({
    required String total,
    required String startDate,
    required String durasiBulan,
    required String bunga,
  }) async {
    try {
      final data = {
        "total": total,
        "startdate": startDate,
        "durasiBulan": durasiBulan,
        "bunga": bunga,
      };

      final response = await _apiService.post('/peminjaman/CountPayment', data);

      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data['data'];
        return dataList.map((item) => CountPayment.fromJson(item)).toList();
      } else {
        print('Gagal menghitung pembayaran. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat menghitung pembayaran: $e');
      return null;
    }
  }
}

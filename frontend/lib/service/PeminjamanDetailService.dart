import 'package:apppeminjaman/authentification/ApiService.dart';
import 'package:apppeminjaman/model/transactionData.dart';

class PeminjamanDetailService {
  final ApiService _apiService = ApiService();

  Future<TransactionData?> getPeminjamanByDocNo(String docNo) async {
    try {
      final response = await _apiService.get(
        '/peminjaman/getDocbyDocNo',
        queryParameters: {'docNo': docNo},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        if (data.isNotEmpty) {
          return TransactionData.fromJson(data[0]);
        }
      } else {
        print('Gagal mengambil detail. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat mengambil detail dokumen: $e');
    }

    return null;
  }
}

import 'package:apppeminjaman/authentification/ApiService.dart';
import 'package:apppeminjaman/model/transactionData.dart';

class AllUserDocumentsService {
  final ApiService _apiService = ApiService();

  Future<List<TransactionData>> getAllUserDocuments() async {
    List<TransactionData> documents = [];

    try {
      final response = await _apiService.get('/peminjaman/getAllUserDoc');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        documents = data.map((docJson) => TransactionData.fromJson(docJson)).toList();
      } else {
        print('Gagal mengambil dokumen. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat mengambil dokumen user: $e');
    }

    return documents;
  }

  Future<List<TransactionData>> getAllUserLoanDocuments() async {
    List<TransactionData> documents = [];

    try {
      final response = await _apiService.get('/peminjaman/getDocbyPayerId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        documents = data.map((docJson) => TransactionData.fromJson(docJson)).toList();
      } else {
        print('Gagal mengambil dokumen. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat mengambil dokumen user: $e');
    }

    return documents;
  }

}

import 'package:apppeminjaman/authentification/ApiService.dart';
import 'package:apppeminjaman/model/CreateDocRequest.dart';

class CreateDocService {
  final ApiService _apiService = ApiService();

  Future<String?> createDoc(CreateDocRequest request) async {
    try {
      final response = await _apiService.post('/peminjaman/createDoc', request.toJson());

      if (response.statusCode == 200) {
        final docNo = response.data['data'];
        return docNo;
      } else {
        print('Gagal membuat dokumen. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat membuat dokumen: $e');
      return null;
    }
  }
}

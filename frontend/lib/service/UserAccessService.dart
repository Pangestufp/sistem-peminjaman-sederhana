import 'package:apppeminjaman/authentification/ApiService.dart';
import 'package:apppeminjaman/model/UserAccess.dart';

class UserAccessService {
  final ApiService _apiService = ApiService();

  Future<UserAccess?> getUserAccess() async {
    try {
      final response = await _apiService.get('/users/getUserAccess');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return UserAccess.fromJson(data);
      } else {
        print('Gagal mengambil akses user. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat mengambil akses user: $e');
      return null;
    }
  }
}

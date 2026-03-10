import 'package:apppeminjaman/authentification/ApiService.dart';
import 'package:apppeminjaman/model/UserData.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<UserData?> getUserData() async {
    try {
      final response = await _apiService.get('/users/getUserData');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return UserData.fromJson(data);
      } else {
        print('Gagal mengambil data user. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saat mengambil data user: $e');
      return null;
    }
  }

  Future<List<UserData>> getAllUsers() async {
    try {
      final response = await _apiService.get('/users/getAll');

      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data['data'];

        return dataList.map((json) => UserData.fromJson(json)).toList();
      } else {
        print('Gagal mengambil daftar user. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error saat mengambil daftar user: $e');
      return [];
    }
  }


}

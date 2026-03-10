import 'package:apppeminjaman/authentification/AuthStateManager.dart';
import 'package:apppeminjaman/authentification/AuthService.dart';
import 'package:apppeminjaman/authentification/ApiService.dart';
import 'package:apppeminjaman/authentification/AuthService.dart';
import 'package:apppeminjaman/authentification/AuthStateManager.dart';

class LoginService {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiService.post(
        '/authenticate',
        {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _authService.saveToken(token);
        AuthStateManager.signIn();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
}
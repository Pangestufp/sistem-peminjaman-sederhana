import 'package:apppeminjaman/authentification/AuthStateManager.dart';
import 'package:apppeminjaman/authentification/AuthService.dart';
import 'package:apppeminjaman/authentification/AuthStateManager.dart';
import 'package:apppeminjaman/authentification/AuthService.dart';
import 'package:dio/dio.dart';


class ApiService {
  final Dio _dio = Dio();
  final AuthService _authService = AuthService();
  final String baseUrl = "/SpringAPI";

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 500) {
            await _authService.deleteToken();
            AuthStateManager.signOut();
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(
      '$baseUrl$path',
      queryParameters: queryParameters,
    );
  }


  Future<Response> post(String path, dynamic data) async {
    return await _dio.post('${baseUrl}$path', data: data);
  }
}
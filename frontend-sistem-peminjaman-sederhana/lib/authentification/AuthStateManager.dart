import 'package:apppeminjaman/authentification/AuthStateManager.dart';
import 'package:apppeminjaman/authentification/AuthService.dart';
import 'dart:async';

class AuthStateManager {
  static final StreamController<bool> _authController =
  StreamController<bool>.broadcast();

  static Stream<bool> get authStateStream => _authController.stream;

  static void signIn() => _authController.add(true);
  static void signOut() => _authController.add(false);
}
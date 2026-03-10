import 'package:flutter/material.dart';
import 'package:apppeminjaman/view/homeScreen.dart';
import 'package:apppeminjaman/view/loginScreen.dart';

class AuthWrapper extends StatelessWidget {
  final bool isLoggedIn;
  const AuthWrapper({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? HomeScreen() : LoginScreen();
  }
}

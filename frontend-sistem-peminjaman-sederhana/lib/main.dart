import 'package:apppeminjaman/authentification/AuthStateManager.dart';
import 'package:apppeminjaman/authentification/AuthService.dart';
import 'package:apppeminjaman/service/AuthWrapper.dart';
import 'package:apppeminjaman/view/homeScreen.dart';
import 'package:apppeminjaman/view/loginScreen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  bool? _initialCheckDone;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() async {
    final token = await _authService.getToken();
    if (token != null) {
      AuthStateManager.signIn();
    } else {
      AuthStateManager.signOut();
    }
    setState(() {
      _initialCheckDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCheckDone == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return StreamBuilder<bool>(
      stream: AuthStateManager.authStateStream,
      initialData: false,
      builder: (context, snapshot) {
        return MaterialApp(
          home: AuthWrapper(isLoggedIn: snapshot.data ?? false),
        );
      },
    );
  }
}

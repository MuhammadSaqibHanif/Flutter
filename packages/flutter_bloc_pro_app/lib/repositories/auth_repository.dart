import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class AuthRepository {
  // Fake in-memory auth. Replace with real API calls in production.
  User? _user;

  Future<User> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'test' && password == 'password') {
      _user = User(
        id: const Uuid().v4(),
        username: username,
        token: 'fake-jwt-token',
      );
      return _user!;
    }
    throw Exception('Invalid credentials');
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _user = null;
  }

  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _user;
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool? _isLoggedIn;
  bool? get isLoggedIn => _isLoggedIn;

  String? userId;
  String? userName;
  String? role;

  bool get isAdmin => role == 'admin';

  /// LOAD SESSION (APP RESTART)
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    ApiService.authToken = prefs.getString('token');
    userId = prefs.getString('userId');
    userName = prefs.getString('userName');
    role = prefs.getString('role');

    _isLoggedIn = ApiService.authToken != null;
    notifyListeners();
  }

  /// LOGIN
  Future<void> login(String email, String password) async {
    final res = await ApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    final token = res['token'];
    final id = res['_id'];
    final name = res['name'];
    final userRole = res['role'] ?? 'user';

    if (token == null || id == null) {
      throw Exception("Invalid login response from server");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', id);
    await prefs.setString('userName', name ?? '');
    await prefs.setString('role', userRole);

    ApiService.authToken = token;

    _isLoggedIn = true;
    userId = id;
    userName = name;
    role = userRole;

    notifyListeners();
  }

  /// REGISTER (USER)
  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    final res = await ApiService.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });

    final token = res['token'];
    final id = res['_id'];
    final userNameFromRes = res['name'];
    final userRole = res['role'] ?? 'user';

    if (token == null || id == null) {
      throw Exception("Invalid register response from server");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', id);
    await prefs.setString('userName', userNameFromRes ?? '');
    await prefs.setString('role', userRole);

    ApiService.authToken = token;

    _isLoggedIn = true;
    userId = id;
    userName = userNameFromRes;
    role = userRole;

    notifyListeners();
  }

  /// LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _isLoggedIn = false;
    userId = null;
    userName = null;
    role = null;
    ApiService.authToken = null;

    notifyListeners();
  }
}

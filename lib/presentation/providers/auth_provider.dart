// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../core/services/api_service.dart';

// class AuthProvider extends ChangeNotifier {
//   bool? _isLoggedIn;
//   bool? get isLoggedIn => _isLoggedIn;
//   String? userId;
//   String? userName;


//   Future<void> loadSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     _isLoggedIn = token != null;
//     userId = prefs.getString('userId');
//     ApiService.authToken = token;
//     notifyListeners();
//   }

//   Future<void> login(String email, String password) async {
//   final res = await ApiService.post('/auth/login', {
//     'email': email,
//     'password': password,
//   });

//   final token = res['token'];
//   final userIdFromResponse = res['_id']; // ✅ FIXED

//   if (token == null || userIdFromResponse == null) {
//     throw Exception("Invalid login response");
//   }

//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('token', token);
//   await prefs.setString('userId', userIdFromResponse);

//   _isLoggedIn = true;
//   userId = userIdFromResponse;
//   ApiService.authToken = token;

//   notifyListeners();
// }

//   Future<void> register(String name, String email, String password, String phone) async {
//   final res = await ApiService.post('/auth/register', {
//     'name': name,
//     'email': email,
//     'password': password,
//     'phone': phone,
//   });

//   final token = res['token'];
//   final userIdFromResponse = res['_id'];

//   if (token == null || userIdFromResponse == null) {
//     throw Exception("Invalid register response");
//   }

//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('token', token);
//   await prefs.setString('userId', userIdFromResponse);

//   _isLoggedIn = true;
//   userId = userIdFromResponse;
//   ApiService.authToken = token;

//   notifyListeners();
// }


//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     await prefs.remove('userId');
//     _isLoggedIn = false;
//     userId = null;
//     ApiService.authToken = null;
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool? _isLoggedIn;
  bool? get isLoggedIn => _isLoggedIn;

  String? userId;
  String? userName;

  /// LOAD SESSION (APP RESTART)
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    _isLoggedIn = token != null;

    userId = prefs.getString('userId');
    userName = prefs.getString('userName'); // ✅ LOAD NAME

    ApiService.authToken = token;
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
    final name = res['name']; // ✅ FROM BACKEND

    if (token == null || id == null || name == null) {
      throw Exception("Invalid login response");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', id);
    await prefs.setString('userName', name); // ✅ SAVE NAME

    _isLoggedIn = true;
    userId = id;
    userName = name;

    ApiService.authToken = token;
    notifyListeners();
  }

  /// REGISTER
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

    if (token == null || id == null || userNameFromRes == null) {
      throw Exception("Invalid register response");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', id);
    await prefs.setString('userName', userNameFromRes); // ✅ SAVE NAME

    _isLoggedIn = true;
    userId = id;
    userName = userNameFromRes;

    ApiService.authToken = token;
    notifyListeners();
  }

  /// LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _isLoggedIn = false;
    userId = null;
    userName = null;
    ApiService.authToken = null;

    notifyListeners();
  }
}

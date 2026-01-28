import 'package:flutter/material.dart';
import 'package:mobile/presentation/providers/cart_provider.dart';
import 'package:mobile/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool? _isLoggedIn;
  bool? get isLoggedIn => _isLoggedIn;
  String? _token;

  String get token {
    if (_token == null) throw Exception("No token available");
    return _token!;
  }

  String? userId;
  String? userName;
  String? role;

  bool get isAdmin => role == 'admin';

  /// LOAD SESSION (APP RESTART)
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token'); // ✅ store token
    ApiService.authToken = _token;
    userId = prefs.getString('userId');
    userName = prefs.getString('userName');
    role = prefs.getString('role');

    _isLoggedIn = _token != null;
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

    _token = token; // ✅ store token
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
    try{
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

      _token = token; // ✅ store token
      ApiService.authToken = token;

      _isLoggedIn = true;
      userId = id;
      userName = userNameFromRes;
      role = userRole;

      notifyListeners();
      }
      catch (e) {
      // ✅ Extract backend message
      final errorMsg = ApiService.extractError(e);
      throw Exception(errorMsg);
    }
  }
  /// LOGOUT
    Future<void> logout(BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _isLoggedIn = false;
      _token = null;
      userId = null;
      userName = null;
      role = null;
      ApiService.authToken = null;

      // 🔥 CLEAR USER-SPECIFIC DATA
      context.read<WishlistProvider>().clearWishlist();
      // context.read<CartProvider>().clearCart();

      notifyListeners();
    }

}


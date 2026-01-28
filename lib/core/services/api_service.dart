import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const bool isProd = false;

  static const String baseUrl ="https://ecommerce-backend-1-5jga.onrender.com/api";
      
    //  static const String baseUrl = isProd
    //  ?"http://ecommerce-backend-1-5jga.onrender.com/api"
    //  :"http://10.127.96.237:5000/api";
   

  static String? authToken;
  
  /// 🔹 COMMON HEADERS
  static Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  /// 🔹 GET
  static Future<dynamic> get(String path) async {
    final res = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
    );
    return _handleResponse(res);
  }

  /// 🔹 POST
  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  /// 🔹 PUT
  static Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    final res = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(res);
  }

  /// 🔹 PATCH  ✅ (THIS FIXES YOUR ERROR)
  static Future<dynamic> patch(String path,
      {Map<String, dynamic>? body}) async {
    final res = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(res);
  }

  /// 🔹 DELETE
  static Future<dynamic> delete(String path) async {
    final res = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
    );
    return _handleResponse(res);
  }

  /// 🔹 RESPONSE HANDLER
  static dynamic _handleResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    } else {
      try {
        final decoded = jsonDecode(res.body);
        throw Exception(decoded['message'] ?? 'API Error');
      } catch (_) {
        throw Exception('API Error: ${res.statusCode}');
      }
    }
  }
  static String extractError(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }
  
}



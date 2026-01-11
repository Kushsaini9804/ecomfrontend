// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   // TODO: set to your backend host. Use 10.0.2.2 for Android emulator.
//   // static const String baseUrl = 'http://10.178.108.237:5000/api';
//   // static const baseUrl = "https://ecommerce-backend.onrender.com";
//   static const String baseUrl = "https://ecommerce-90u9.onrender.com/api";
//   static String? authToken;

//   static Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) async {
//   final response = await http.patch(
//     Uri.parse('$baseUrl$endpoint'),
//     headers: _headers(),
//     body: body != null ? jsonEncode(body) : null,
//   );

//   return _handleResponse(response);
// }


//   static Map<String, String> _defaultHeaders() => {
//         'Content-Type': 'application/json',
//         if (authToken != null) 'Authorization': 'Bearer $authToken',
//       };

//   // GET
//   static Future<dynamic> get(String path) async {
//     final uri = Uri.parse('$baseUrl$path');
//     final res = await http.get(uri, headers: _defaultHeaders());
    
//     return _processResponse(res);
//   }

//   // POST (body must be encodable)
//   static Future<dynamic> post(String path, Map<String, dynamic> body) async {
//     final uri = Uri.parse('$baseUrl$path');
//     final res = await http.post(uri, headers: _defaultHeaders(), body: jsonEncode(body));

//     return _processResponse(res);
//   }

//   // PUT
//   static Future<dynamic> put(String path, Map<String, dynamic> body) async {
//     final uri = Uri.parse('$baseUrl$path');
//     final res = await http.put(uri, headers: _defaultHeaders(), body: jsonEncode(body));

//     return _processResponse(res);
//   }
  

//   // DELETE — supports optional body for backends that accept it
//   static Future<dynamic> delete(String path, {Map<String, dynamic>? body}) async {
//     final uri = Uri.parse('$baseUrl$path');

//     http.Response res;
//     if (body == null) {
//       res = await http.delete(uri, headers: _defaultHeaders());
//     } else {
//       // Some backends accept a JSON body with DELETE; http package requires using Request for that
//       final request = http.Request('DELETE', uri);
//       request.headers.addAll(_defaultHeaders());
//       request.body = jsonEncode(body);
//       final streamed = await request.send();
//       res = await http.Response.fromStream(streamed);
//     }

//     return _processResponse(res);
//   }

//   // Common response processing
//   static dynamic _processResponse(http.Response res) {
//     final code = res.statusCode;
//     final body = res.body;

//     if (code >= 200 && code < 300) {
//       if (body.trim().isEmpty) return null;
//       try {
//         return jsonDecode(body);
//       } catch (_) {
//         // Not JSON — return raw body
//         return body;
//       }
//     }

//     // Try decode error message
//     String message = 'Request failed with status: $code';
//     try {
//       final decoded = jsonDecode(body);
//       if (decoded is Map && decoded['message'] != null) {
//         message = decoded['message'].toString();
//       } else if (decoded is String) {
//         message = decoded;
//       } else {
//         message = body;
//       }
//     } catch (_) {
//       message = body.isNotEmpty ? body : message;
//     }

//     throw Exception('API Error: $message (status: $code)');
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://ecommerce-90u9.onrender.com/api";

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
  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
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
}



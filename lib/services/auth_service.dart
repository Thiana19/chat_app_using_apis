import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String token;

  User({required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
    );
  }
}

class AuthService {
  static const String baseUrl = 'https://app.chatlaju.com/api/v1/login';

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {'email': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Extract the token from the response
      final String token = responseData['token'];

      _storeTokenLocally(token);

      return User(token: token);
    } else {
      // Handle login error
      throw Exception('Login failed');
    }
  }

  // Store the token securely (in-memory for demonstration purposes)
  void _storeTokenLocally(String token) {
    _token = token;
  }

  static String? _token;

  // Retrieve the stored token
  static String? getStoredToken() => _token;
}

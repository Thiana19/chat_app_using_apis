import 'package:flutter_chat_app/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  static const String baseUrl = 'https://app.chatlaju.com/api/v1/get-user';
  final String token;

  UserService(this.token);

  Future<UserModel> getUserDetails() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'}
      );
    
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}

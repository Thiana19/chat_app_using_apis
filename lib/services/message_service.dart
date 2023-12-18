import 'dart:convert';
import 'package:http/http.dart' as http;

class MessageService {
  static const String baseUrl = 'https://app.chatlaju.com/api/v1/get-messages';
  final String token;

  MessageService({required this.token});

  Future<Map<String, dynamic>> getMessages(String roomId) async {
    final url = '$baseUrl/$roomId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successful response
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        // Handle error
        throw Exception('Failed to get messages');
      }
    } catch (error) {
      // Handle network or unexpected errors
      throw Exception('Error: $error');
    }
  }
}

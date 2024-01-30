import 'dart:convert';
import 'package:http/http.dart' as http;

class SendMessageService {
  static const String baseUrl = 'https://app.chatlaju.com/api/v1/send-message';
  final String token;

  SendMessageService(this.token);

  Future<void> sendMessage(String roomId, String messageContent) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'chat_room': roomId,
          'messageContent': messageContent,
        }),
      );

      if (response.statusCode == 200) {
        print('API call successful');
        print('Response: ${response.body}');
      } else {
        print('API call failed with status code: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
}

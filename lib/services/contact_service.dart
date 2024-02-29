import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_app/models/contact_model.dart'; // Import the Contact model

class ContactService {
  static const String baseUrl = 'https://app.chatlaju.com/api/v1/get-contacts';
  final String token;

  ContactService(this.token);

  Future<List<Contact>> getContacts() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'}
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Contact.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load contacts');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}

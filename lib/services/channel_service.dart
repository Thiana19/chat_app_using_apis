import 'dart:convert';

import 'package:flutter_chat_app/models/channel_model.dart';
import 'package:http/http.dart' as http;

class ChannelService {
  static const String baseUrl = 'https://app.chatlaju.com/api/v1/get-channels';
  final String token;

  ChannelService(this.token);

  Future<List<ChannelModel>> getChannels() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'}
      );
    

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((item) => ChannelModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load channels');
      }
    } catch (error) {
      throw Exception("Error: $error");
    }
  }
}

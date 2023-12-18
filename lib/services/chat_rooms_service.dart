import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_app/models/chat_room_model.dart';

class ChatService {
  static const String baseUrl = 'https://app.chatlaju.com/api/v1/get-rooms/';
  final String token;

  ChatService(this.token);

  Future<List<ChatRoomMessage>> getChatRooms() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> chatRoomsData = json.decode(response.body);
        
        // Convert the dynamic list to List<ChatRoomMessage>
        final List<ChatRoomMessage> chatRooms = chatRoomsData
            .map((roomData) => ChatRoomMessage.fromJson(roomData))
            .toList();

        return chatRooms;
      } else {
        throw Exception('Failed to get chat rooms');
      }
    } catch (e) {
      throw Exception('Error getting chat rooms: $e');
    }
  }
}

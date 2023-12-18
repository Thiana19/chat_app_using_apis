import '../models/chat_room_model.dart';


class SearchService {
  final List<ChatRoomMessage> rooms;

  SearchService(this.rooms);

  List<ChatRoomMessage> searchRooms(String query) {
    query = query.toLowerCase();
    return rooms.where((room) {
      final String roomName = room.name.toLowerCase();
      final String message = room.message.toLowerCase();

      return roomName.contains(query) || message.contains(query);
    }).toList();
  }
}

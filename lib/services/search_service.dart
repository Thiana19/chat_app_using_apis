import 'package:flutter_chat_app/models/contact_model.dart';

import '../models/chat_room_model.dart';


class SearchServiceHome {
  final List<ChatRoomMessage> rooms;

  SearchServiceHome(this.rooms);

  List<ChatRoomMessage> searchRooms(String query) {
    query = query.toLowerCase();
    return rooms.where((room) {
      final String roomName = room.name.toLowerCase();
      final String message = room.message.toLowerCase();

      return roomName.contains(query) || message.contains(query);
    }).toList();
  }
}

class SearchServiceContact {
  final List<Contact> contacts;

  SearchServiceContact(this.contacts);

  List<Contact> searchContacts(String query) {
    query = query.toLowerCase();
    return contacts.where((contact) {
      final String contactName = contact.name.toLowerCase();

      return contactName.contains(query);
    }).toList();
  }
}

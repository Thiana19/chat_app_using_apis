import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/pages/home.dart';
import 'package:flutter_chat_app/style.dart';
import 'package:flutter_chat_app/services/message_service.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomName;
  final String token;
  final String roomId;
  final Color avatarColor;

  ChatScreen({
    required this.chatRoomName,
    required this.token,
    required this.roomId,
    required this.avatarColor,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final Map<String, dynamic> data =
          await MessageService(token: widget.token).getMessages(widget.roomId);
      final List<dynamic> loadedMessages = List.from(data['messages']);
      setState(() {
        // Reverse the order of messages before updating the state
        messages = loadedMessages.reversed.toList();
      });
    } catch (error) {
      print('Error loading messages: $error');
    }
  }

  String formatTimestamp(String timestampString) {
    DateTime timestamp = DateTime.parse(timestampString);
    return DateFormat.Hm().format(timestamp);
  }

  String getInitials(String name) {
    List<String> nameSplit = name.split(' ');
    String initials = '';
    for (String part in nameSplit) {
      initials += part[0];
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5b61b9),
      body: ListView(
        children: [
          customAppBar(context),
          header(),
          chatArea(context),
        ],
      ),
    );
  }

  Padding customAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white54,
              elevation: 0,
            ),
            child: const PrimaryText(text: 'Back', color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomListPage(token: widget.token),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrimaryText(
                text: widget.chatRoomName,
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(minWidth: 0),
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: Colors.white38,
                    padding: const EdgeInsets.all(10.0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.call, size: 24.0, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  RawMaterialButton(
                    constraints: const BoxConstraints(minWidth: 0),
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: Colors.white38,
                    padding: const EdgeInsets.all(10.0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.video_call, size: 24.0, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const Row(
            children: [
              Icon(
                Icons.info,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 5),
              PrimaryText(
                text: 'Online',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container chatArea(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 160,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 270,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = Message.fromJson(messages[index]);
                return message.direction == 'Outbound'
                    ? sender(
                        message.message,
                        formatTimestamp(message.createdAt),
                        index,
                      )
                    : receiver(
                        message.message,
                        formatTimestamp(message.createdAt),
                        index,
                      );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RawMaterialButton(
                    constraints: const BoxConstraints(minWidth: 0),
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: const Color(0xff5b61b9),
                    child: const Icon(Icons.send, size: 22.0, color: Colors.white),
                    padding: const EdgeInsets.all(10.0),
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sender(String message, String time, int index) {
    final isImage = messages[index]['attachment_type'] == 'image';
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          isImage
              ? Image.network(
                  messages[index]['attachment_path'],
                  width: 150, // Adjust the width as needed
                  height: 150, // Adjust the height as needed
                  fit: BoxFit.cover,
                )
              : Container(
                  constraints: const BoxConstraints(minWidth: 100, maxWidth: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4B49AC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: message,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          PrimaryText(
                            text: time,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          const PrimaryText(
                            text: " : Sent",
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget receiver(String message, String time, int index) {
    final isImage = messages[index]['attachment_type'] == 'image';
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CircleAvatar(
              backgroundColor: widget.avatarColor,
              child: Text(
                getInitials(widget.chatRoomName),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: isImage
                ? Image.network(
                    messages[index]['attachment_path'],
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  )
                : Container(
                    constraints: const BoxConstraints(minWidth: 100, maxWidth: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryText(
                          text: message,
                          color: Colors.black54,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryText(
                              text: time,
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            PrimaryText(
                              text: " : Received",
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

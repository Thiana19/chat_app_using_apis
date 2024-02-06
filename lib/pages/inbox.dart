import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/services/message_service.dart';
import 'package:flutter_chat_app/services/send_message_service.dart';
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
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _messageController = TextEditingController();
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

  Future<void> _sendMessage() async {
    final String messageContent = _messageController.text.trim();
    if (messageContent.isNotEmpty) {
      try {
        await SendMessageService(widget.token)
            .sendMessage(widget.roomId, messageContent);
        _messageController.clear();
        _loadMessages(); 
      } catch (error) {
        print('Error sending message: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: widget.avatarColor,
                child: Text(
                  getInitials(widget.chatRoomName),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                widget.chatRoomName,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: ListView(
        children: [
          chatArea(context),
        ],
      ),
    );
  }

  Container chatArea(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 90,
      decoration: const BoxDecoration(
        // color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 170,
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
            padding: const EdgeInsets.only(left: 10, right: 10,),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                // fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 0.5,
                    // style: BorderStyle.none,
                  ),
                ),
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RawMaterialButton(
                    constraints: const BoxConstraints(minWidth: 0),
                    onPressed: () {
                      _sendMessage();
                    },
                    elevation: 2.0,
                    // fillColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.all(10.0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.send, size: 22.0, 
                      // color: Colors.white
                    ),
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
              width: 150, 
              height: 150, 
              fit: BoxFit.cover,
            )
          : Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 150),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
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
                  Text(
                    message,
                    style: const TextStyle(
                    // color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          // color: Colors.white,
                        fontSize: 14,
                        ),
                      ),
                      const Text(
                        " : Sent",
                        style: TextStyle(
                          // color: Colors.white,
                        fontSize: 14,
                        ),
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
          isImage
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
                    color: Color(0xFFE0E0E0),
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
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                        
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            time,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            " : Received",
                            style: TextStyle(
                              color: Colors.black54,
                            fontSize: 14,
                            ),
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
}

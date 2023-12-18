class ChatRoomMessage {
  final String id;
  final String name;
  final String message;
  final String createdAt;
  final String channel;

  ChatRoomMessage({
    required this.id,
    required this.name,
    required this.message,
    required this.createdAt,
    required this.channel,
  });

  factory ChatRoomMessage.fromJson(Map<String, dynamic> json) {
    return ChatRoomMessage(
      id: json['id'],
      name: json['name'],
      message: json['latestMessage']['message'],
      createdAt: json['latestMessage']['created_at'],
      channel: json['channel'],
    );
  }
}

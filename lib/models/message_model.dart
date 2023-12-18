class Message {
  final String message;
  final String status;
  final String direction;
  final String createdAt;
  final String? attachmentType;
  final String? attachmentPath;

  Message({
    required this.message,
    required this.status,
    required this.direction,
    required this.createdAt,
    this.attachmentType,
    this.attachmentPath,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      status: json['status'],
      direction: json['direction'],
      createdAt: json['created_at'],
      attachmentType: json['attachment_type'],
      attachmentPath: json['attachment_path'],
    );
  }
}

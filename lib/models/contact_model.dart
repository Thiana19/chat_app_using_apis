class Contact {
  final int id;
  final String name;
  final String handle;
  final String channel;

  Contact({required this.id, required this.name, required this.handle, required this.channel});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      handle: json['handle'],
      channel: json['channel'],
    );
  }
}

class ChannelModel {
  final int id;
  final String name;
  final String status;

  ChannelModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// class Role {
//   final int id;
//   final String name;
//   final String displayName;
//   final String description;

//   Role({
//     required this.id,
//     required this.name,
//     required this.displayName,
//     required this.description,
//   });

//   factory Role.fromJson(Map<String, dynamic> json) {
//     return Role(
//       id: json['id'],
//       name: json['name'],
//       displayName: json['display_name'],
//       description: json['description'],
//     );
//   }
// }

// class Organization {
//   final int id;
//   final String name;

//   Organization({
//     required this.id,
//     required this.name,
//   });

//   factory Organization.fromJson(Map<String, dynamic> json) {
//     return Organization(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
// }

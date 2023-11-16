import 'dart:convert';

class Usuario {
  final String id;
  final String name;
  final String email;

  Usuario({
    required this.id,
    required this.name,
    required this.email,
  });

  Usuario copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return Usuario(
      id: id ?? this.id, 
      name: name ?? this.name, 
      email: email ?? this.email, 
    
    );
  }

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
    id: json['id'],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
  };
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String name;
  final String email;
  final double weight;
  final double height;

  Usuario({
    required this.id,
    required this.name,
    required this.email,
    required this.weight,
    required this.height,
  });

  Usuario copyWith({
    String? id,
    String? name,
    String? email,
    double? weight,
    double? height
  }) {
    return Usuario(
      id: id ?? this.id, 
      name: name ?? this.name, 
      email: email ?? this.email, 
      weight: weight ?? this.weight, 
      height: height ?? this.height,     
    );
  }

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
    id: json['id'],
    name: json["name"],
    email: json["email"],
    weight: json["weight"] ?? 0,
    height: json["height"] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
    "weight": weight,
    "height": height
  };

    factory Usuario.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Usuario(
      id: snapshot.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      weight: data['weight'] ?? 0,
      height: data['height'] ?? 0,
    );
  }
}

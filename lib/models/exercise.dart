import 'dart:convert';


class Exercise {
  late final String id;
  String? name;
  String? description;
  String? type;
  String? muscle;
  String? image;
  String? equipment;
  String? difficulty;
  String? objective;
  int? series;
  int? repetitions;


  Exercise({
    required this.id,
    this.name, 
    this.description, 
    this.type, 
    this.muscle, 
    this.image, 
    this.equipment, 
    this.difficulty, 
    this.objective,
    this.series,
    this.repetitions,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? muscle,
    String? image,
    String? equipment,
    String? difficulty,
    String? objective,
    int? series,
    int? repetitions,
  }){
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name, 
      description: description ?? this.description, 
      type: type ?? this.type,
      muscle: muscle ?? this.muscle, 
      image: image ?? this.image, 
      equipment: equipment ?? this.equipment, 
      difficulty: difficulty ?? this.difficulty, 
      objective: objective ?? this.objective,
      series: series ?? this.series,
      repetitions: repetitions ?? this.repetitions,
    );
  }

  factory Exercise.fromJson(String str) => Exercise.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Exercise.fromMap(Map<String, dynamic> json) => Exercise(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    description: json["description"] ?? '',
    type: json["type"] ?? '',
    muscle: json["muscle"] ?? '',
    image: json["image"] ?? '',
    equipment: json["equipment"] ?? '',
    difficulty: json["difficulty"] ?? '',
    objective: json["objective"] ?? '',
    series: json["series"] ?? 0,
    repetitions: json["repetitions"] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    "id" : id,
    "name": name ?? '',
    "description": description ?? '',
    "type": type ?? '',
    "muscle": muscle ?? '',
    "image": image ?? '',
    "equipment": equipment ?? '',
    "difficulty": difficulty ?? '',
    "objective": objective ?? '',
    "series": series ?? 0,
    "repetitions": repetitions ?? 0,

  };

    

}
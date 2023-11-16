import 'dart:convert';

class Exercise {
  final String exerciseId;
  final String name;
  final String description;
  final String type;
  final String muscle;
  final String image;
  final String equipment;
  final String difficulty;
  final String objective;

  Exercise({
    required this.exerciseId,
    required this.name, 
    required this.description, 
    required this.type, 
    required this.muscle, 
    required this.image, 
    required this.equipment, 
    required this.difficulty, 
    required this.objective
  });

  Exercise copyWith({
    String? exerciseId,
    String? name,
    String? description,
    String? type,
    String? muscle,
    String? image,
    String? equipment,
    String? difficulty,
    String? objective,
  }){
    return Exercise(
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name, 
      description: description ?? this.description, 
      type: type ?? this.type,
      muscle: muscle ?? this.muscle, 
      image: image ?? this.image, 
      equipment: equipment ?? this.equipment, 
      difficulty: difficulty ?? this.difficulty, 
      objective: objective ?? this.objective
    );
  }

  factory Exercise.fromJson(String str) => Exercise.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Exercise.fromMap(Map<String, dynamic> json) => Exercise(
    exerciseId: json["exerciseId"],
    name: json["name"],
    description: json["description"],
    type: json["type"],
    muscle: json["muscle"],
    image: json["image"],
    equipment: json["equipment"],
    difficulty: json["difficulty"],
    objective: json["objective"]
  );

  Map<String, dynamic> toMap() => {
    "exerciseId" : exerciseId,
    "name": name,
    "description": description,
    "type": type,
    "muscle": muscle,
    "image": image,
    "equipment": equipment,
    "difficulty": difficulty,
    "objective": objective
  };
}
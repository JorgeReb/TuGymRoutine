import 'package:flutter/material.dart';

import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';

class ListExerciseView extends StatelessWidget {
  const ListExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => const AddExercisePage()));
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.background, size: 30),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        width: double.infinity,
        child: FutureBuilder<List<Exercise>>(
          future: getExercises(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) { 
              return Text('Error: ${snapshot.error}',style: const TextStyle(color: Colors.white));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay ejercicios disponibles.',style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ));
            } else {
              return ExerciseListScreen(exercises: snapshot.data!);
            }
          }
        ),
      ),
    );
  }

  Future<List<Exercise>> getExercises() async {
    final List<Exercise> exercises = await ExerciseService().getExercises();

    final List<Exercise> exerciseList = exercises.map((exercise) {
      return Exercise(
        exerciseId: exercise.exerciseId,
        name: exercise.name,
        description: exercise.description,
        type: exercise.type,
        muscle: exercise.muscle,
        image: exercise.image,
        equipment: exercise.equipment,
        difficulty: exercise.difficulty,
        objective: exercise.objective,
      );
    }).toList();
    return exerciseList;
  }
}

class ExerciseListScreen extends StatefulWidget {
  final List<Exercise> exercises;

  const ExerciseListScreen({super.key, required this.exercises});

  @override
  // ignore: library_private_types_in_public_api
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Exercise> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    filteredExercises = widget.exercises;
  }

  void _filterExercises(String searchTerm) {
    setState(() {
      filteredExercises = widget.exercises.where((exercise) => exercise.name.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterExercises(value);
              },
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              cursorColor: Theme.of(context).colorScheme.secondary,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                labelText: 'Buscar por nombre',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  minVerticalPadding: 10,
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ExercisePage(exercise: filteredExercises[index])));
                  },
                  title: Text(filteredExercises[index].name,style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
                  subtitle: Text(filteredExercises[index].muscle,style: TextStyle(fontWeight: FontWeight.w100, color: Theme.of(context).colorScheme.secondary),maxLines: 2),
                  leading: Image.asset(
                    'assets/foto_login.png',
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

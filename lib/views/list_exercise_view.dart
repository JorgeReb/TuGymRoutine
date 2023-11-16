import 'package:flutter/material.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/pages/admin/add_exercise_page.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';

class ListExerciseView extends StatelessWidget {
  const ListExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: secundaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExercisePage()));
        },
        child: const Icon(Icons.add, color: primaryColor, size: 30),
      ),
      body: Container(
        color: primaryColor,
        width: double.infinity,
        child: FutureBuilder<List<Exercise>>(
            future: getExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Muestra un mensaje de error si hay un problema
                return Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Muestra un mensaje si no hay datos disponibles
                return const Center(
                    child: Text(
                  'No hay ejercicios disponibles.',
                  style: TextStyle(color: Colors.white),
                ));
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final exercise = snapshot.data![index];
                    return ListTile(
                      minVerticalPadding: 10,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExercisePage(exercise: exercise)));
                      },
                      title: Text(
                        exercise.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(exercise.description,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w100),maxLines: 2),
                      leading: Image.asset(
                        'assets/foto_login.png',
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                      ),
                    );
                  },
                );
              }
            }),
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

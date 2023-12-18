import 'package:flutter/material.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/models/workout.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';

// ignore: must_be_immutable
class RoutinePage extends StatelessWidget {
  Workout workout;

  RoutinePage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    getExercises() async {
      final exercises = workout.exercises!.values.toList();
      final List<String> exercisesIds = [];

      for (var i = 0; i < exercises.length; i++) {
        exercisesIds.add(exercises[i].id);
      }

      return await ExerciseService().getExercisesByIds(exercisesIds);
    }

    return Scaffold(
      body: FutureBuilder(
        future: getExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final List<Exercise> exercises = snapshot.data;
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {                      
                      return Column(
                        children: [
                          ListTile(
                            title: Text(exercises[index].name!,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            subtitle: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        "\n${exercises[index].description!}\n\n",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.w200)),
                                TextSpan(
                                    text:
                                        "Series y repeticiones: ${workout.exercises![index + 1]!.series!} x ${workout.exercises![index + 1]!.repetitions!}",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.w200)),
                              ]),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Divider(
                            height: 1,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          if (index+1 == exercises.length) 
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: TextButton(
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Colors.blue),
                                  fixedSize: MaterialStatePropertyAll(Size(300, 30))
                                ),
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => ExerciseProgressPage(workout: workout, exercises: exercises,)));
                                },
                                child: Text('Iniciar entrenamiento', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                              ),
                            )
                          
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 25.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Navegar a la página anterior al presionar el botón
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

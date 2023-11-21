import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tu_gym_routine/blocs/user/user_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';
import 'package:tu_gym_routine/views/views.dart';


class ExercisesView extends StatelessWidget {
  const ExercisesView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.read<UserBloc>().add(ChangeViewUserEvent(view: const LogoView()));
        Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage()));
        return true;
      },
      child: Scaffold(
        body: Container(
          color: primaryColor,
          width: double.infinity,
          child: FutureBuilder<List<Exercise>>(
            future: getExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay ejercicios disponibles.',style: TextStyle(color: Colors.white)));
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
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ShowExercisePage(exercise: exercise)));
                      },
                      title: Text(
                        exercise.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(exercise.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w100
                        ),
                        maxLines: 2
                      ),
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
            }
          ),
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

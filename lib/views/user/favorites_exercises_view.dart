import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';

class FavoritesExercisesView extends StatefulWidget {
  final Usuario user;

  const FavoritesExercisesView({super.key, required this.user});

  @override
  State<FavoritesExercisesView> createState() => _FavoritesExercisesViewState();
}

class _FavoritesExercisesViewState extends State<FavoritesExercisesView> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Exercise>> getExercisesId() async {
    final userUid = widget.user.id;

    final DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    final Map<String, dynamic>? userData =
        document.data() as Map<String, dynamic>?;

    final List<String>? favorites =
        (userData!['favorites_exercises'] ?? [])?.cast<String>();

    final List<Exercise> favoritesExercises =
        await ExerciseService().getExercisesByIds(favorites!);

    return favoritesExercises;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInDown(
        delay: const Duration(milliseconds: 200),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getExercisesId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(padding: EdgeInsets.only(top: 50),child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}',style: TextStyle(color: Theme.of(context).colorScheme.secondary));
              } else {
                final List<Exercise> listExercises = snapshot.data!;
                return SizedBox(
                  height: 700,
                  child: ListView.builder(
                    itemCount: listExercises.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        minVerticalPadding: 10,
                        title: Text(listExercises[index].name!,style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
                        subtitle: Text(listExercises[index].muscle!,style: TextStyle(fontWeight: FontWeight.w100, color: Theme.of(context).colorScheme.secondary),maxLines: 2),
                        leading: Image.asset(
                          'assets/foto_login.png',
                          alignment: Alignment.center,
                          height: 30,
                          width: 30,
                        ),
                      );
                    }
                  ),
                );
              }
            }
          ),
        ),
      ),
    );
  }
}

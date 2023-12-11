import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tu_gym_routine/blocs/user/user_bloc.dart';
import 'package:tu_gym_routine/models/workout.dart';
import 'package:tu_gym_routine/pages/home_page.dart';
import 'package:tu_gym_routine/pages/user/routine_page.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';
import 'package:tu_gym_routine/views/logo_view.dart';

class WorkoutsView extends StatelessWidget {
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<UserBloc>().add(ChangeViewUserEvent(view: const LogoView()));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
        return true;
      },
      child: FadeInDown(
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: FutureBuilder<List<Workout>>(
              future: getWorkouts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final List<Workout> workout = snapshot.data!;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(workout[index].name!,style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                            subtitle: Text(workout[index].description!,style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w200)),
                            minVerticalPadding: 20,
                            leading: Icon(FontAwesomeIcons.dumbbell, color: Theme.of(context).colorScheme.secondary, size: 20),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RoutinePage(workout: workout[index])));
                            },
                          ),
                      
                        Divider(height: 1, color: Theme.of(context).colorScheme.secondary,)
                        ],
                      );
                    },
                    itemCount: workout.length,
                  );
                }
              }
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Workout>> getWorkouts() async {
    final List<Workout> workouts = await ExerciseService().getWorkouts();
    return workouts;
  }
}

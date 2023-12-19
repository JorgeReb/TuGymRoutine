// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/models/workout.dart';
import 'package:tu_gym_routine/pages/home_page.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';
import 'package:tu_gym_routine/services/user_service.dart';
import 'package:tu_gym_routine/views/user/workouts_view.dart';
import 'package:tu_gym_routine/widgets/shared/custom_alert_dialog.dart';

// ignore: must_be_immutable
class ExerciseProgressPage extends StatefulWidget {
  List<Exercise> exercises;
  Workout workout;

  ExerciseProgressPage({super.key, required this.workout, required this.exercises});

  @override
  State<ExerciseProgressPage> createState() => _ExerciseProgressPageState();
}

class _ExerciseProgressPageState extends State<ExerciseProgressPage> {

  late List<Exercise> exercises = widget.workout.exercises!.values.toList();
   
  final List<List<TextEditingController>> kilosControllerList = [];
  final List<List<TextEditingController>> repetitionsControllerList = [];
  
  Map exerciseMap = {};  

  @override
  void initState() {
    for (var i = 0; i < widget.workout.exercises!.length; i++) {
      List<TextEditingController> kilosControllers = [];
      List<TextEditingController> repetitionsControllers = [];
      for (var j = 0; j < widget.workout.exercises![i+1]!.series!; j++) {
        kilosControllers.add(TextEditingController());
        repetitionsControllers.add(TextEditingController());
      }
      kilosControllerList.add(kilosControllers);
      repetitionsControllerList.add(repetitionsControllers);
    }     

    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInDown(
        child: SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              TimerWidget(exercises: exercises, workout: widget.workout, kilosControllerList: kilosControllerList, repetitionsControllerList: repetitionsControllerList, exerciseMap: exerciseMap),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.workout.exercises!.length,
                  itemBuilder: (context, indice) {
                    final map = {
                      (indice+1).toString():{
                        "id": widget.workout.exercises![indice+1]!.id,
                      }
                    };
                    exerciseMap.addAll(map);
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: ListTile(
                        title: Text(widget.exercises[indice].name!,style: TextStyle(color:Theme.of(context).colorScheme.secondary,fontSize: 17)),
                        subtitle: DataTable(
                          dividerThickness: 0.01,
                          columns: [
                            DataColumn(label: Text('Serie',style: TextStyle(color: Theme.of(context).colorScheme.secondary))),
                            DataColumn(label: Text('  Kilos',style: TextStyle(color: Theme.of(context).colorScheme.secondary))),
                            DataColumn(label: Text('Repeticiones',style: TextStyle(color: Theme.of(context).colorScheme.secondary))),
                          ],
                          rows: List.generate(exercises[indice].series!, (index) =>      
                            DataRow(
                              cells: [
                                DataCell(Text("${index+1}", style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
                                DataCell(
                                  SizedBox(
                                    height: 40,
                                    width: 55,
                                    child: TextField(
                                      controller: kilosControllerList[indice][index],
                                      maxLength: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))), counterText: '', contentPadding: EdgeInsets.only(bottom: 3))
                                    ),
                                  )
                                ),
                                DataCell(
                                  SizedBox(
                                    height: 40,
                                    width: 55,
                                    child: TextField(
                                      controller: repetitionsControllerList[indice][index],
                                      maxLength: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                      keyboardType: TextInputType.number,
                                      decoration:  InputDecoration(hintText: exercises[indice].repetitions.toString(),border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))), counterText: '', contentPadding: const EdgeInsets.only(bottom: 3), hintStyle: const TextStyle(fontWeight: FontWeight.w100))
                                    ),
                                  )
                                ),
                              ]
                            )
                          ), //dataRows
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),  
      ),
    );
  }
}

// ignore: must_be_immutable
class TimerWidget extends StatefulWidget {
  Map exerciseMap;
  List<Exercise> exercises;
  Workout workout;
  List<List<TextEditingController>> kilosControllerList;
  List<List<TextEditingController>> repetitionsControllerList;

  TimerWidget({
    super.key, 
    required this.exercises, 
    required this.workout,
    required this.kilosControllerList,
    required this.repetitionsControllerList, 
    required this.exerciseMap,
    });

  @override
  State<TimerWidget> createState() => _TimerState();
}

class _TimerState extends State<TimerWidget> {
  late final Timer timer;
  int seconds = 0;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Usuario? user;
  

  @override
  void initState() {
     _cargarUsuarioDesdeBD();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds += 1;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  
  Future<void> _cargarUsuarioDesdeBD() async {
    Usuario userDb = await UserService().getUserById(currentUser!.uid);
    setState(() {
      user = userDb;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.only(top: 55, left: 10),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                CustomAlertDialog(
                  icon: alertIcon, 
                  text: const Text('¿Estás seguro de querer cancelar el entrenamiento?',style: TextStyle(color: Colors.white),textAlign: TextAlign.center), 
                  color: alertColor, 
                  textButton: TextButton(
                    onPressed: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage())),  
                    child: const Text("Cancelar", style: TextStyle(color: alertColor))
                  )
                ).showCustomDialog(context);
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Temporizador\n',
                    style: TextStyle(color:Theme.of(context).colorScheme.secondary, fontSize: 15)),
                TextSpan(text: _formatTime(seconds),style: TextStyle(color:Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.w200,fontSize: 15)),
              ])),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5),
              child: ElevatedButton(
                style: const ButtonStyle(backgroundColor:MaterialStatePropertyAll(succesColor),fixedSize:MaterialStatePropertyAll(Size(190, 15))),
                onPressed: () {
                  Map workoutMap = {};
                  for (var i = 0; i < widget.workout.exercises!.length; i++) {
                    int exerciseNumber = i+1;
                    workoutMap[exerciseNumber.toString()] = {
                      "id": widget.exercises[i].id,
                      "series": {}
                    };
                    for (var j = 0; j < widget.workout.exercises![exerciseNumber]!.series!; j++) { 
                      workoutMap[exerciseNumber.toString()]['series'][(j+1).toString()] = {
                        "kilos":(widget.kilosControllerList[i][j].text.isNotEmpty) ? int.parse(widget.kilosControllerList[i][j].text) : 0,
                        "repetitions":(widget.kilosControllerList[i][j].text.isNotEmpty) ? int.parse(widget.repetitionsControllerList[i][j].text) : 0
                      };
                    }   
                  }   
                  CustomAlertDialog(
                    icon: successIcon, 
                    text: const Text('¿Estás seguro de querer finalizar el entrenamiento?',style: TextStyle(color: Colors.white),textAlign: TextAlign.center), 
                    color: succesColor, 
                    textButton: TextButton(
                      onPressed: () async{
                        final data = {
                        "exercises":workoutMap,
                        "user_id": user!.id,
                        "workout_id": widget.workout.workoutId,
                        "workout_name": widget.workout.name,
                        "time": _formatTime(seconds)
                        };
                        await ExerciseService().addHistoryUserWorkouts(data) ;
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage()));
                      },  
                      child: const Text("Finalizar", style: TextStyle(color: succesColor))
                    )
                  ).showCustomDialog(context);                  
                },
                child: const Text('Finalizar entrenamiento',style: TextStyle(color: Colors.white))
              ),
            )
          ],
        ),
      ),
    );
  }
}



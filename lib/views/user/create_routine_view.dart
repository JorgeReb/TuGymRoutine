// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tu_gym_routine/blocs/routine/routine_bloc.dart';
import 'package:tu_gym_routine/methods/get_exercises_method.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/models/workout.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';
import 'package:tu_gym_routine/widgets/user/create_routine/list_exercises.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';

class CreateRoutineView extends StatefulWidget {
  const CreateRoutineView({super.key});

  @override
  State<CreateRoutineView> createState() => _CreateRoutineViewState();
}

class _CreateRoutineViewState extends State<CreateRoutineView> {
  final GlobalKey<FormState> createRoutineKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    late String exerciseId;
    late String exerciseName;

    final theme = Theme.of(context).colorScheme;
     final snackBar = SnackBar(
      content: Text('Rutina creada', style: TextStyle(color: theme.background),),
      backgroundColor: theme.secondary,
      duration: const Duration(seconds: 2),
    );

    return Scaffold(
      backgroundColor: theme.background,
      body: SingleChildScrollView(
        child: Form(
          key: createRoutineKey,
          child: BlocBuilder<RoutineBloc, RoutineState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30, top: 10, bottom: 10),
                child: Column(
                  children: [
                    if (state.showInputName == true) _AddExercise(createRoutineKey: createRoutineKey),
                    if (state.showExercises == true)  
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: FutureBuilder<List<Exercise>>(
                            future: getExercises(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text('No hay ejercicios disponibles.',style: TextStyle(color: Theme.of(context).colorScheme.secondary)));
                              } else {
                                return ListExercises(exercises: snapshot.data!, returnExercise: (id, name) {
                                  exerciseId = id;
                                  exerciseName = name;
                                });
                              }
                            }
                          ),
                        ),
                        if(state.workout!.exercises!.isNotEmpty) 
                            Padding(
                              padding: const EdgeInsets.only(top:  20),
                              child:  ElevatedButton(
                                style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(300, 30)),backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                                onPressed: () async{
                                  await ExerciseService().addWorkout(context.read<RoutineBloc>().state.workout!);

                                  context.read<RoutineBloc>().state.workout = Workout(
                                    name: '',
                                    numberOfExercises: 0,
                                    exercises: {}
                                  );
                                


                                  
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  context.read<RoutineBloc>().add(ChangeEnabledInputsRoutine(isChooseExercise: true, isExerciseChosen: false, isShowExercise: false));

                                },
                                child: const Text('Finalizar rutina', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                    if (state.exercisesChoosen == true)  
                    _Template(exerciseId: exerciseId, exerciseName: exerciseName),
                  ],
                ),
              );
            }
          )
        ),
      ),
    );
  }
}

class _AddExercise extends StatelessWidget {
  
  final GlobalKey<FormState> createRoutineKey;
  const _AddExercise({required this.createRoutineKey});

  @override
  Widget build(BuildContext context) {
  TextEditingController routineNameCtrl = TextEditingController();
    return Column(
      children: [
        CustomInputField(
          nombreCampo: 'Nombre de la rutina',
          icon: FontAwesomeIcons.fileSignature,
          isObscureText: false,
          controller: routineNameCtrl,
          validator: validateName
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(300, 30)),backgroundColor: MaterialStatePropertyAll(Colors.blue)),
          onPressed: () {
            if(createRoutineKey.currentState!.validate()){
              context.read<RoutineBloc>().state.workout!.name = routineNameCtrl.text;
              context.read<RoutineBloc>().add(ChangeEnabledInputsRoutine(isChooseExercise: false, isExerciseChosen: false, isShowExercise: true));
            }
          },
          child: const Text('Añadir ejercicio', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class _Template extends StatefulWidget {
  late String exerciseId;
  late String exerciseName;

  _Template({required this.exerciseId, required this.exerciseName});
  
  @override
  State<_Template> createState() => _TemplateState();
}

class _TemplateState extends State<_Template> {
  int exerciseCont = 1;

  @override
  Widget build(BuildContext context) {

    TextEditingController seriesCtrl = TextEditingController();
    TextEditingController repetitionsCtrl = TextEditingController();   

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Expanded(child: CustomRoutineInput(nombreCampo: 'Series', icon: FontAwesomeIcons.sort, isObscureText: false, controller: seriesCtrl, validator: validateUpdateInputsExercise)),
            const SizedBox(width: 10),
            Expanded(child: CustomRoutineInput(nombreCampo: 'Repeticiones', icon: FontAwesomeIcons.repeat, isObscureText: false, controller: repetitionsCtrl, validator: validateUpdateInputsExercise)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextButton(
            onPressed: () {
              context.read<RoutineBloc>().state.workout!.numberOfExercises = context.read<RoutineBloc>().state.workout!.numberOfExercises! + exerciseCont;

              context.read<RoutineBloc>().state.workout!.exercises![context.read<RoutineBloc>().state.workout!.numberOfExercises!] = 
              Exercise(exerciseId: widget.exerciseId, name: widget.exerciseName, series: int.parse(seriesCtrl.text), repetitions: int.parse(repetitionsCtrl.text));

              setState(() {
                seriesCtrl.text = '';
                repetitionsCtrl.text = '';
              });

              context.read<RoutineBloc>().add(ChangeEnabledInputsRoutine(isChooseExercise: false, isExerciseChosen: false, isShowExercise: true));
          }, child: const Text('Agregar a la rutina')),
        )          
      ],
    );
  }
}



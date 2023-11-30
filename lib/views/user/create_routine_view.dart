import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tu_gym_routine/blocs/routine/routine_bloc.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';
import 'package:tu_gym_routine/widgets/shared/custom_input_field.dart';

class CreateRoutineView extends StatefulWidget {
  const CreateRoutineView({super.key});

  @override
  State<CreateRoutineView> createState() => _CreateRoutineViewState();
}

class _CreateRoutineViewState extends State<CreateRoutineView> {
  final GlobalKey<FormState> createRoutineKey = GlobalKey();
  TextEditingController routineNameCtrl = TextEditingController();
  TextEditingController seriesCtrl = TextEditingController();
  TextEditingController repetitionsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
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
                    if (state.showInputName == true) _AddExercise(createRoutineKey: createRoutineKey, routineNameCtrl: routineNameCtrl),
                    if (state.showExercises == true) _ChooseExercise(),
                    if (state.exercisesChoosen == true)  _Template(seriesCtrl: seriesCtrl, repetitionsCtrl: repetitionsCtrl)
                  ],
                ),
              );
            })),
      ),
    );
  }
}

class _AddExercise extends StatelessWidget {
  
  final GlobalKey<FormState> createRoutineKey;
  final TextEditingController routineNameCtrl;
  const _AddExercise({required this.createRoutineKey, required this.routineNameCtrl});

  @override
  Widget build(BuildContext context) {
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
              context.read<RoutineBloc>().add(ChangeEnabledInputsRoutine(isChooseExercise: false, isExerciseChosen: false, isShowExercise: true, routineName: routineNameCtrl.text, exerciseName: '', series: 0, repetitions: 0, exercises: []));
              context.read<RoutineBloc>().state.routineName = routineNameCtrl.text;
            }
          },
          child: const Text('Añadir ejercicio', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class _Template extends StatefulWidget {
  final TextEditingController seriesCtrl;
  final TextEditingController repetitionsCtrl;
  
  const _Template({required this.seriesCtrl, required this.repetitionsCtrl});

  @override
  State<_Template> createState() => _TemplateState();
}

class _TemplateState extends State<_Template> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Expanded(child: _CustomRoutineInput(nombreCampo: 'Series', icon: FontAwesomeIcons.sort, isObscureText: false, controller: widget.seriesCtrl, validator: validateUpdateInputsExercise)),
            const SizedBox(width: 10),
            Expanded(child: _CustomRoutineInput(nombreCampo: 'Repeticiones', icon: FontAwesomeIcons.repeat, isObscureText: false, controller: widget.repetitionsCtrl, validator: validateUpdateInputsExercise)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextButton(
            onPressed: () {
              final routineBloc = context.read<RoutineBloc>();
              print("${context.read<RoutineBloc>().state.routineName}, ${context.read<RoutineBloc>().state.exerciseName},${widget.seriesCtrl.text}, ${widget.repetitionsCtrl.text}");
               routineBloc.state.exercises!.add({"exerciseName": context.read<RoutineBloc>().state.exerciseName, "series": widget.seriesCtrl.text, "repetitions" : widget.repetitionsCtrl.text});
             
              print(routineBloc.state.exercises);

              
              routineBloc.add(ChangeEnabledInputsRoutine(isChooseExercise: false, isExerciseChosen: false, isShowExercise: true, routineName:  context.read<RoutineBloc>().state.routineName!, exerciseName: '', series: 0, repetitions: 0, exercises: context.read<RoutineBloc>().state.exercises!));
              setState(() {
                widget.seriesCtrl.text = '';
                widget.repetitionsCtrl.text = '';
              });
          }, child: const Text('Agregar a la rutina')),
        )          
      ],
    );
  }
}

class _ChooseExercise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: FutureBuilder<List<Exercise>>(
          future: getExercises(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No hay ejercicios disponibles.',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)));
            } else {
              return _ExerciseListScreen(exercises: snapshot.data!);
            }
          }),
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

// ignore: must_be_immutable
class _CustomRoutineInput extends StatelessWidget {
  final String nombreCampo;
  final IconData icon;
  final bool isObscureText;
  final TextEditingController controller;
  String? Function(String? val)? validator;

  _CustomRoutineInput({
    required this.nombreCampo,
    required this.icon,
    required this.isObscureText,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscureText,
      cursorColor: Theme.of(context).colorScheme.secondary,
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent.withOpacity(0.6)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.6))),
        suffixIcon: Icon(icon,
            color: Theme.of(context).colorScheme.secondary, size: 20),
        labelText: nombreCampo,
        labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary, fontSize: 14),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: Theme.of(context).colorScheme.secondary)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: Theme.of(context).colorScheme.secondary)),
      ),
    );
  }
}

class _ExerciseListScreen extends StatefulWidget {
  final List<Exercise> exercises;

  const _ExerciseListScreen({required this.exercises});

  @override
  // ignore: library_private_types_in_public_api
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<_ExerciseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Exercise> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    filteredExercises = widget.exercises;
  }

  void _filterExercises(String searchTerm) {
    setState(() {
      filteredExercises = widget.exercises
          .where((exercise) =>
              exercise.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      height: 500,
      width: double.infinity,
      child: Column(
        children: [
          Text('Añadir ejercicios' , style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterExercises(value);
              },
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              cursorColor: Theme.of(context).colorScheme.secondary,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary)),
                labelText: 'Buscar por nombre',
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    context.read<RoutineBloc>().add(ChangeEnabledInputsRoutine(isChooseExercise: false, isExerciseChosen: true, isShowExercise: false, routineName: context.read<RoutineBloc>().state.routineName!, exerciseName: filteredExercises[index].name, series: 0, repetitions: 0, exercises: []));
                  },
                  title: Text(filteredExercises[index].name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary)),
                  subtitle: Text(filteredExercises[index].muscle,
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Theme.of(context).colorScheme.secondary),
                      maxLines: 2),
                 
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

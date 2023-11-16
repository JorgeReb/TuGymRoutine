import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
;
import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/blocs/exercise_admin/exercise_admin_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';
import 'package:tu_gym_routine/views/views.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';

class ExercisePage extends StatelessWidget {
  final Exercise exercise;

  const ExercisePage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ExerciseAdminBloc>().add(ChangeEnabledInputs(isEnabled: false));
        Navigator.push(context,MaterialPageRoute(builder: (context) => const AdminPage()));
        return true;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Container(
            color: primaryColor,
            child: FadeInDown(
              delay: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  _InfoExercise(exercise),
                  _FormExercise(exercise: exercise),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: GestureDetector(
                        onTap: () {
                          context.read<ExerciseAdminBloc>().add(ChangeEnabledInputs(isEnabled: false));
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const AdminPage()));
                        },
                        child: const Icon(Icons.logout,color: Colors.grey, size: 50)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormExercise extends StatefulWidget {
  final Exercise exercise;

  const _FormExercise({required this.exercise});

  @override
  State<_FormExercise> createState() => _FormExerciseState();
}

class _FormExerciseState extends State<_FormExercise> {
  GlobalKey<FormState> exerciseForm = GlobalKey();
  late TextEditingController nameCtrl;
  late TextEditingController descriptionCtrl;
  late TextEditingController typeCtrl;
  late TextEditingController muscleCtrl;
  late TextEditingController imageCtrl;
  late TextEditingController equipmentCtrl;
  late TextEditingController difficultyCtrl;
  late TextEditingController objectiveCtrl;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    descriptionCtrl = TextEditingController(text: widget.exercise.description);
    nameCtrl = TextEditingController(text: widget.exercise.name);
    typeCtrl = TextEditingController(text: widget.exercise.type);
    muscleCtrl = TextEditingController(text: widget.exercise.muscle);
    imageCtrl = TextEditingController(text: widget.exercise.image);
    equipmentCtrl = TextEditingController(text: widget.exercise.equipment);
    difficultyCtrl = TextEditingController(text: widget.exercise.difficulty);
    objectiveCtrl = TextEditingController(text: widget.exercise.objective);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        height: 550,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: exerciseForm,
            child: BlocBuilder<ExerciseAdminBloc, ExerciseAdminState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Expanded(
                    child: Column(
                      children: [
                        CustomAdminInputField(
                          controller: nameCtrl,
                          isEnabled: state.isEnabled,
                          label: 'Nombre',
                          icon: const Icon(FontAwesomeIcons.dumbbell,color: primaryColor),
                          validator: validateUpdateInputsExercise
                        ),
                        const SizedBox(height: 5),
                        CustomAdminInputField(
                          controller: descriptionCtrl,
                          isEnabled: state.isEnabled,
                          label: 'Descripción',
                          icon: const Icon(Icons.description_rounded,color: primaryColor),
                          validator: validateUpdateInputsExercise
                        ),
                        const SizedBox(height: 5),
                        CustomAdminInputField(
                          controller: typeCtrl,
                          isEnabled: state.isEnabled,
                          label: 'Tipo',
                          icon: const Icon(Icons.type_specimen,color: primaryColor),
                          validator: validateUpdateInputsExercise
                        ),
                        const SizedBox(height: 5),
                        CustomAdminInputField(
                          controller: muscleCtrl,
                          isEnabled: state.isEnabled,
                          label: 'Músculo',
                          icon: const Icon(FontAwesomeIcons.childReaching,color: primaryColor),
                          validator: validateUpdateInputsExercise
                        ),
                        const SizedBox(height: 5),
                        CustomAdminInputField(
                          controller: imageCtrl,
                          isEnabled: state.isEnabled,
                          label: 'Imagen',
                          icon: const Icon(Icons.image, color: primaryColor),
                          validator: validateUpdateInputsExercise
                        ),
                        const SizedBox(height: 5),
                        CustomAdminInputField(
                          controller: equipmentCtrl,
                          isEnabled: state.isEnabled,
                          label: 'Equipamiento',
                          icon: const Icon(FontAwesomeIcons.screwdriverWrench,color: primaryColor),
                          validator: validateUpdateInputsExercise
                        ),
                        const SizedBox(height: 5),
                        CustomAdminInputField(
                          controller: difficultyCtrl,
                          isEnabled: state.isEnabled,
                          label: 'Dificultad',
                          icon: const Icon(Icons.equalizer, color: primaryColor),
                          validator: validateUpdateInputsExercise
                        ),
                        const SizedBox(height: 5),
                        CustomAdminInputField(
                          controller: objectiveCtrl,
                          isEnabled: state.isEnabled,
                          label: 'Objetivo',
                          icon: const Icon(FontAwesomeIcons.bullseye,color: primaryColor),
                          validator: validateUpdateInputsExercise),
                        if (state.isEnabled) acceptUpdateButton(context)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding acceptUpdateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextButton(
          onPressed: () async {
            if (exerciseForm.currentState!.validate()) {
              try {
                await ExerciseService().updateExercise(
                    widget.exercise.exerciseId,
                    nameCtrl.text,
                    descriptionCtrl.text,
                    typeCtrl.text,
                    muscleCtrl.text,
                    imageCtrl.text,
                    equipmentCtrl.text,
                    difficultyCtrl.text,
                    objectiveCtrl.text
                );
                // ignore: use_build_context_synchronously
                context.read<ExerciseAdminBloc>().add(ChangeEnabledInputs(isEnabled: false));

                final Exercise exercise = Exercise(
                  exerciseId: widget.exercise.exerciseId,
                  name: nameCtrl.text,
                  description: descriptionCtrl.text,
                  type: typeCtrl.text,
                  muscle: muscleCtrl.text,
                  image: imageCtrl.text,
                  equipment: equipmentCtrl.text,
                  difficulty: difficultyCtrl.text,
                  objective: objectiveCtrl.text
                );
                // ignore: use_build_context_synchronously
                Navigator.push(context,MaterialPageRoute(builder: (context) => ExercisePage(exercise: exercise)));
              } catch (e) {
                return;
              }
            }
          },
          style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(115, 20)),backgroundColor: MaterialStatePropertyAll(Colors.blue)),
          child: const Text('Modificar', style: TextStyle(color: secundaryColor))),
    );
  }
}

class _InfoExercise extends StatelessWidget {
  final Exercise exercise;
  const _InfoExercise(this.exercise);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 60, bottom: 35),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        height: 225,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Image.asset(
                        'assets/foto_login.png',
                        height: 140,
                        width: 130,
                      ),
                    ),
                    _ExerciseName(exercise.name)
                  ],
                ),
              ),
              _ActionsButtons(exercise),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsButtons extends StatelessWidget {
  final Exercise exercise;
  const _ActionsButtons(this.exercise);

  @override
  Widget build(BuildContext context) {
    bool isSure = false;
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Column(
        children: [
          _updateExerciseButton(context),
          const SizedBox(width: 20),
          _deleteExerciseButton(isSure, context),
        ],
      ),
    );
  }

  TextButton _updateExerciseButton(BuildContext context) {
    return TextButton(
        onPressed: () => BlocProvider.of<ExerciseAdminBloc>(context).add(ChangeEnabledInputs(isEnabled: true)),
        style: const ButtonStyle(
            fixedSize: MaterialStatePropertyAll(Size(125, 20)),
            backgroundColor: MaterialStatePropertyAll(Colors.blue)),
        child: const Text('Modificar ejercicio',style: TextStyle(color: secundaryColor)));
  }

  TextButton _deleteExerciseButton(bool isSure, BuildContext context) {
    return TextButton(
      onPressed: () {
        CustomAlertDialog(
          icon: alertIcon,
          text: askIsSureExercise,
          color: alertColor,
          textButton: TextButton(
              onPressed: () async {
                isSure = true;
                if (isSure == true) {
                  await ExerciseService().deleteExercise(exercise.exerciseId);
                  // ignore: use_build_context_synchronously
                  BlocProvider.of<AdminBloc>(context).add(ChangeViewEvent(view: const ListExerciseView()));
                  // ignore: use_build_context_synchronously
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const AdminPage()));
                }
              },
              child: confirmDeleteText),
        ).showCustomDialog(context);
      },
      style: const ButtonStyle(
          fixedSize: MaterialStatePropertyAll(Size(125, 20)),
          backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
      child: const Text('Eliminar ejercicio',
          style: TextStyle(color: secundaryColor)),
    );
  }
}

// ignore: must_be_immutable
class _ExerciseName extends StatelessWidget {
  String name;
  _ExerciseName(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        name,
        style: const TextStyle(color: primaryColor, fontSize: 20),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}

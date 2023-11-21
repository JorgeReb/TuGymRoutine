// ignore_for_file: use_build_context_synchronously
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/blocs/exercise_admin/exercise_admin_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/exercise.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';
import 'package:tu_gym_routine/views/views.dart';
import 'package:tu_gym_routine/widgets/admin/form_label_input.dart';
import 'package:tu_gym_routine/widgets/admin/return_button.dart';
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
                  const ReturnButton(),
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
  late TextEditingController imageCtrl;
  late String typeValue;
  late String muscleValue;
  late String equipmentValue;
  late String difficultyValue;
  late String objectiveValue;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    descriptionCtrl = TextEditingController(text: widget.exercise.description);
    nameCtrl = TextEditingController(text: widget.exercise.name);
    imageCtrl = TextEditingController(text: widget.exercise.image);
    typeValue = widget.exercise.type;
    muscleValue = widget.exercise.muscle;
    equipmentValue = widget.exercise.equipment;
    difficultyValue = widget.exercise.difficulty;
    objectiveValue = widget.exercise.objective;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        height: 450,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: exerciseForm,
            child: BlocBuilder<ExerciseAdminBloc, ExerciseAdminState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          CustomAdminInputField(
                              controller: nameCtrl,
                              isEnabled: state.isEnabled,
                              label: 'Nombre',
                              icon: const Icon(FontAwesomeIcons.dumbbell,color: primaryColor, size: 15),
                              validator: validateUpdateInputsExercise),
                          CustomAdminInputField(
                              controller: descriptionCtrl,
                              isEnabled: state.isEnabled,
                              label: 'Descripción',
                              icon: const Icon(Icons.description_rounded,color: primaryColor, size: 20),
                              validator: validateUpdateInputsExercise),
                          const SizedBox(height: 10),
                          const FormLabelInput(name: 'Tipos'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.type,
                            onItemSelected: (value) => setState(() => typeValue = value),
                            items: types,
                            icon: const Icon(Icons.type_specimen,color: primaryColor),
                          ),
                          const SizedBox(height: 10),
                          const FormLabelInput(name: 'Músculo'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.muscle,
                            onItemSelected: (value) => setState(() => muscleValue = value),
                            items: muscles,
                            icon: const Icon(FontAwesomeIcons.childReaching,color: primaryColor),
                          ),
                          CustomAdminInputField(
                              controller: imageCtrl,
                              isEnabled: state.isEnabled,
                              label: 'Imagen',
                              icon:const Icon(Icons.image, color: primaryColor),
                              validator: validateUpdateInputsExercise),
                          const SizedBox(height: 10),
                          const FormLabelInput(name: 'Equipamiento'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.equipment,
                            onItemSelected: (value) => setState(() => equipmentValue = value),
                            items: equipments,
                            icon: const Icon(FontAwesomeIcons.screwdriverWrench, color: primaryColor),
                          ),
                          const SizedBox(height: 10),
                          const FormLabelInput(name: 'Dificultad'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.difficulty,
                            onItemSelected: (value) => setState(() => difficultyValue = value),
                            items: difficulties,
                            icon: const Icon(Icons.equalizer, color: primaryColor),
                          ),
                          const SizedBox(height: 10),
                          const FormLabelInput(name: 'Objetivo'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.objective,
                            onItemSelected: (value) => setState(() => objectiveValue = value),
                            items: objectives,
                            icon: const Icon(FontAwesomeIcons.bullseye, color: primaryColor),
                          ),
                          if (state.isEnabled) acceptUpdateButton(context)
                        ],
                      ),
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
                    typeValue,
                    muscleValue,
                    imageCtrl.text,
                    equipmentValue,
                    difficultyValue,
                    objectiveValue
                );
                
                context.read<ExerciseAdminBloc>().add(ChangeEnabledInputs(isEnabled: false));

                final Exercise exercise = Exercise(
                    exerciseId: widget.exercise.exerciseId,
                    name: nameCtrl.text,
                    description: descriptionCtrl.text,
                    type: typeValue,
                    muscle: muscleValue,
                    image: imageCtrl.text,
                    equipment: equipmentValue,
                    difficulty: difficultyValue,
                    objective: objectiveValue);
             
                Navigator.push(context,MaterialPageRoute(builder: (context) =>ExercisePage(exercise: exercise)));

              } catch (e) {
                return;
              }
            }
          },
          style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(115, 20)),backgroundColor: MaterialStatePropertyAll(Colors.blue)),
          child:const Text('Modificar', style: TextStyle(color: secundaryColor))),
    );
  }
}


class _SelectItems extends StatefulWidget {
  final List<String> items;
  final Icon icon;
  final Function(String) onItemSelected;
  final String initialValue;
  final bool isEnabled;

  const _SelectItems({
    required this.isEnabled,
    required this.initialValue,
    required this.items,
    required this.icon,
    required this.onItemSelected
  });

  @override
  State<_SelectItems> createState() => _SelectItemsState();
}

class _SelectItemsState extends State<_SelectItems> {
  late String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isEnabled ? false : true,
      child: DropdownButtonFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Seleccione al menos una opción';
          }
          return null;
        },
        value: widget.initialValue,
        padding: const EdgeInsets.only(right: 7),
        icon: Padding(padding: const EdgeInsets.only(bottom: 5), child: widget.icon,
        ),
        iconSize: 20,
        items: widget.items.map((item) {
          return DropdownMenuItem(
            alignment: Alignment.centerLeft,
            value: item,
            child: Text(item, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
        focusColor: primaryColor,
        dropdownColor: secundaryColor,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:widget.isEnabled ? primaryColor : Colors.grey.shade400, width: widget.isEnabled ? 1 : 0.5)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:widget.isEnabled ? primaryColor : Colors.grey.shade400,width: widget.isEnabled ? 1 : 0.5)),
        ),
        borderRadius: BorderRadius.circular(20),
        isExpanded: true,
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
            widget.onItemSelected(value);
          });
        }
      ),
    );
  }
}

class _InfoExercise extends StatelessWidget {
  final Exercise exercise;
  const _InfoExercise(this.exercise);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 25),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        height: 205,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset('assets/foto_login.png',height: 130,width: 130),
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
      style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(125, 20)),backgroundColor: MaterialStatePropertyAll(Colors.blue)),
      child: const Text('Modificar ejercicio',style: TextStyle(color: secundaryColor))
    );
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
                
                BlocProvider.of<AdminBloc>(context).add(ChangeViewEvent(view: const ListExerciseView()));
                
                Navigator.push(context,MaterialPageRoute(builder: (context) => const AdminPage()));
              }
            },
            child: confirmDeleteText),
        ).showCustomDialog(context);
      },
      style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(125, 20)),backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
      child: const Text('Eliminar ejercicio',style: TextStyle(color: secundaryColor)),
    );
  }
}

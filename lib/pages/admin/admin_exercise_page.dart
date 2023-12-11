// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

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

class ExercisePage extends StatefulWidget {
  final Exercise exercise;

  const ExercisePage({super.key, required this.exercise});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  Future<String> getImageFS() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(widget.exercise.image!);

      final publicUrl = storageRef.getDownloadURL();
      return await publicUrl;
    } on FirebaseException catch (e) {
      if (e.message == "No object exists at the desired reference.") return 'Error';
      return '';
    }
  }

  @override
  void initState() {
    getImageFS();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        context
            .read<ExerciseAdminBloc>()
            .add(ChangeEnabledInputs(isEnabled: false));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AdminPage()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: getImageFS(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('');
                } else {
                  final imagen = snapshot.data!;
                  return Container(
                    color: Theme.of(context).colorScheme.background,
                    child: FadeInDown(
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          _InfoExercise(widget.exercise, imagen),
                          _FormExercise(exercise: widget.exercise),
                          const ReturnButton(),
                        ],
                      ),
                    ),
                  );
                }
              }),
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
  late String typeValue;
  late String muscleValue;
  late String imageValue;
  late String auxImage;
  late String equipmentValue;
  late String difficultyValue;
  late String objectiveValue;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    descriptionCtrl = TextEditingController(text: widget.exercise.description);
    nameCtrl = TextEditingController(text: widget.exercise.name);
    typeValue = widget.exercise.type!;
    muscleValue = widget.exercise.muscle!;
    imageValue = widget.exercise.image!;
    auxImage = widget.exercise.image!;
    equipmentValue = widget.exercise.equipment!;
    difficultyValue = widget.exercise.difficulty!;
    objectiveValue = widget.exercise.objective!;
  }

  void _pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    Uint8List imagebyte = await image.readAsBytes();
    String base64 = base64Encode(imagebyte);
    setState(() {
      imageValue = base64;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        height: 415,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: exerciseForm,
            child: BlocBuilder<ExerciseAdminBloc, ExerciseAdminState>(
              builder: (context, state) {
                final isEnabled = state.isEnabled;
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
                              icon: Icon(FontAwesomeIcons.dumbbell,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  size: 15),
                              validator: validateUpdateInputsExercise),
                          CustomAdminInputField(
                              controller: descriptionCtrl,
                              isEnabled: state.isEnabled,
                              label: 'Descripción',
                              icon: Icon(Icons.description_rounded,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  size: 20),
                              validator: validateUpdateInputsExercise),
                          const SizedBox(height: 10),
                          const FormLabelInput(name: 'Tipos'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.type!,
                            onItemSelected: (value) =>
                                setState(() => typeValue = value),
                            items: types,
                            icon: Icon(Icons.type_specimen,
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                          const SizedBox(height: 10),
                          const FormLabelInput(name: 'Músculo'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.muscle!,
                            onItemSelected: (value) =>
                                setState(() => muscleValue = value),
                            items: muscles,
                            icon: Icon(FontAwesomeIcons.childReaching,
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                             const SizedBox(height: 10),
                          const FormLabelInput(name: 'Equipamiento'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.equipment!,
                            onItemSelected: (value) =>
                                setState(() => equipmentValue = value),
                            items: equipments,
                            icon: Icon(FontAwesomeIcons.screwdriverWrench,
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                          const SizedBox(height: 10),
                          const FormLabelInput(name: 'Dificultad'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.difficulty!,
                            onItemSelected: (value) =>
                                setState(() => difficultyValue = value),
                            items: difficulties,
                            icon: Icon(Icons.equalizer,
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                          const SizedBox(height: 10),
                          const FormLabelInput(name: 'Objetivo'),
                          _SelectItems(
                            isEnabled: state.isEnabled,
                            initialValue: widget.exercise.objective!,
                            onItemSelected: (value) =>
                                setState(() => objectiveValue = value),
                            items: objectives,
                            icon: Icon(FontAwesomeIcons.bullseye,
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                          Row(
                            children: [
                              const FormLabelInput(name: 'Imagen'),
                              const SizedBox(width: 50),
                              IgnorePointer(
                                ignoring: isEnabled ? false : true,
                                child: TextButton(
                                    onPressed: () => _pickImage(),
                                    child: Text(
                                      'Subir imagen',
                                      style: TextStyle(
                                          color: isEnabled
                                              ? Colors.blue
                                              : Colors.grey.shade400,
                                          fontWeight: FontWeight.w400),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 108.0),
                                child: Icon(
                                  Icons.image,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              )
                            ],
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
      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
      child: TextButton(
          onPressed: () async {
            if (exerciseForm.currentState!.validate()) {
              try {
                if (imageValue == auxImage) imageValue = auxImage;
                await ExerciseService().updateExercise(
                    widget.exercise.id,
                    nameCtrl.text,
                    descriptionCtrl.text,
                    typeValue,
                    muscleValue,
                    imageValue,
                    equipmentValue,
                    difficultyValue,
                    objectiveValue);
                context
                    .read<ExerciseAdminBloc>()
                    .add(ChangeEnabledInputs(isEnabled: false));

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AdminPage()));
              } catch (e) {
                return;
              }
            }
          },
          style: const ButtonStyle(
              fixedSize: MaterialStatePropertyAll(Size(115, 20)),
              backgroundColor: MaterialStatePropertyAll(Colors.blue)),
          child:
              const Text('Modificar', style: TextStyle(color: Colors.white))),
    );
  }
}

class _SelectItems extends StatefulWidget {
  final List<String> items;
  final Icon icon;
  final Function(String) onItemSelected;
  final String initialValue;
  final bool isEnabled;

  const _SelectItems(
      {required this.isEnabled,
      required this.initialValue,
      required this.items,
      required this.icon,
      required this.onItemSelected});

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
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: widget.icon,
          ),
          iconSize: 20,
          items: widget.items.map((item) {
            return DropdownMenuItem(
              alignment: Alignment.centerLeft,
              value: item,
              child: Text(item,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.background,
                      fontWeight: FontWeight.w400)),
            );
          }).toList(),
          focusColor: Theme.of(context).colorScheme.background,
          dropdownColor: Theme.of(context).colorScheme.secondary,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(0),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: widget.isEnabled
                        ? Theme.of(context).colorScheme.background
                        : Colors.grey.shade400,
                    width: widget.isEnabled ? 1 : 0.5)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: widget.isEnabled
                        ? Theme.of(context).colorScheme.background
                        : Theme.of(context).colorScheme.secondary,
                    width: widget.isEnabled ? 1 : 0.5)),
          ),
          borderRadius: BorderRadius.circular(20),
          isExpanded: true,
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
              widget.onItemSelected(value);
            });
          }),
    );
  }
}

class _InfoExercise extends StatefulWidget {
  final Exercise exercise;
  final String imagen;
  const _InfoExercise(this.exercise, this.imagen);

  @override
  State<_InfoExercise> createState() => _InfoExerciseState();
}

class _InfoExerciseState extends State<_InfoExercise> {
  @override
  Widget build(BuildContext context) {
    const imageBackgroundColor = primaryColor;
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                  height: 215,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: imageBackgroundColor,
                      boxShadow: [BoxShadow(blurRadius: 15)]),
                  child: (widget.imagen != "Error")
                      ? CachedNetworkImage(
                          imageUrl: widget.imagen,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          fit: BoxFit.cover,
                          'assets/foto_login.png',
                          alignment: Alignment.center,
                        )),
            ),
          ],
        ),
        _ActionsButtons(widget.exercise)
      ],
    );
    // return Padding(
    //   padding: const EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 25),
    //   child: Container(
    //     decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary,borderRadius: BorderRadius.circular(20)),
    //     width: double.infinity,
    //     height: 210,
    //     child: Padding(
    //       padding: const EdgeInsets.only(top: 10),
    //       child: Row(
    //         children: [
    //           SizedBox(
    //             width: 200,
    //             child: Column(
    //               children: [
    //                 Padding(
    //                     padding: const EdgeInsets.only(top: 5),
    //                     child: (widget.imagen != "Error")
    //                         ? CachedNetworkImage(
    //                             imageUrl: widget.imagen,
    //                             width: 160,
    //                             height: 130,
    //                           )
    //                         : Image.asset(
    //                             width: 130,
    //                             height: 130,
    //                             'assets/foto_login.png',
    //                             alignment: Alignment.center,
    //                           )),
    //                 _ExerciseName(widget.exercise.name)
    //               ],
    //             ),
    //           ),
    //           _ActionsButtons(widget.exercise),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
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
        style: TextStyle(
            color: Theme.of(context).colorScheme.background, fontSize: 20),
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
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 40),
        child: Row(
          children: [
            _updateExerciseButton(context),
            const SizedBox(width: 20),
            _deleteExerciseButton(isSure, context),
          ],
        ),
      );
    });
  }

  TextButton _updateExerciseButton(BuildContext context) {
    return TextButton(
        onPressed: () => BlocProvider.of<ExerciseAdminBloc>(context)
            .add(ChangeEnabledInputs(isEnabled: true)),
        style: const ButtonStyle(
            fixedSize: MaterialStatePropertyAll(Size(145, 20)),
            backgroundColor: MaterialStatePropertyAll(Colors.blue)),
        child: const Text('Modificar ejercicio',
            style: TextStyle(color: Colors.white)));
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
                  await ExerciseService().deleteExercise(exercise.id);

                  BlocProvider.of<AdminBloc>(context)
                      .add(ChangeViewEvent(view: const ListExerciseView()));

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminPage()));
                }
              },
              child: confirmDeleteText),
        ).showCustomDialog(context);
      },
      style: const ButtonStyle(
          fixedSize: MaterialStatePropertyAll(Size(145, 20)),
          backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
      child: const Text('Eliminar ejercicio',
          style: TextStyle(color: Colors.white)),
    );
  }
}

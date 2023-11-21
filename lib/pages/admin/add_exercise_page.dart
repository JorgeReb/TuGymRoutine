import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tu_gym_routine/blocs/exercise_admin/exercise_admin_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';
import 'package:tu_gym_routine/widgets/admin/custom_admin_input.dart';
import 'package:tu_gym_routine/widgets/admin/form_label_input.dart';
import 'package:tu_gym_routine/widgets/admin/return_button.dart';

class AddExercisePage extends StatelessWidget {
  const AddExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: FadeInDown(
          delay: const Duration(milliseconds: 300),
          child: const Padding(
            padding: EdgeInsets.only(top: 70, left: 20, right: 20),
            child: Column(
              children: [
                _FormExercise(),
                ReturnButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormExercise extends StatefulWidget {
  const _FormExercise();

  @override
  State<_FormExercise> createState() => _FormExerciseState();
}

class _FormExerciseState extends State<_FormExercise> {
  GlobalKey<FormState> addExerciseForm = GlobalKey();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  late String typeValue;
  late String muscleValue;
  late String imageValue;
  late String equipmentValue;
  late String difficultyValue;
  late String objectiveValue;
  bool isEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        height: 650,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: addExerciseForm,
            child: BlocBuilder<ExerciseAdminBloc, ExerciseAdminState>(
              builder: (context, state) {                        
                return SingleChildScrollView(
                  child: Column(children: [
                    const SizedBox(height: 5),
                    const FormLabelInput(name: 'Nombre'),
                    CustomAdminInputField(
                        controller: nameCtrl,
                        isEnabled: true,
                        icon: const Icon(FontAwesomeIcons.dumbbell,color: primaryColor, size: 15),
                        validator: validateUpdateInputsExercise),
                    const SizedBox(height: 5),
                    const FormLabelInput(name: 'Descripción'), 
                    CustomAdminInputField(
                      controller: descriptionCtrl,
                      isEnabled: true,
                      icon: const Icon(Icons.description_rounded,color: primaryColor, size: 17),
                      validator: validateUpdateInputsExercise,
                    ),
                    const SizedBox(height: 5),
                    const FormLabelInput(name: 'Tipos'),
                    _SelectItems(
                      onItemSelected: (value) => setState(() => typeValue = value),
                      items: types,
                      icon: const Icon(Icons.type_specimen, color: primaryColor),
                    ),
                    const SizedBox(height: 5),
                    const FormLabelInput(name: 'Músculos'),
                    _SelectItems(
                      onItemSelected: (value) => setState(() => muscleValue = value),
                      items: muscles,
                      icon: const Icon(FontAwesomeIcons.childReaching,color: primaryColor),
                    ),
                    const SizedBox(height: 5),
                    const FormLabelInput(name: 'Imagen'),
                    _SelectItems(
                      onItemSelected: (value) => setState(() => imageValue = value),
                      items: equipments,
                      icon: const Icon(Icons.image, color: primaryColor),
                    ),
                    const SizedBox(height: 5),
                    const FormLabelInput(name: 'Equipamiento'),
                    _SelectItems(
                      onItemSelected: (value) => setState(() => equipmentValue = value),
                      items: equipments,icon: const Icon(FontAwesomeIcons.screwdriverWrench,color: primaryColor),
                    ),
                    const SizedBox(height: 5),
                    const FormLabelInput(name: 'Dificultades'),
                    _SelectItems(
                      onItemSelected: (value) => setState(() => difficultyValue = value),
                      items: difficulties, icon: const Icon(Icons.equalizer, color: primaryColor),
                    ),
                    const SizedBox(height: 5),
                    const FormLabelInput(name: 'Objetivos'),
                    _SelectItems(
                        onItemSelected: (value) => setState(() => objectiveValue = value),
                        items: objectives,icon: const Icon(FontAwesomeIcons.bullseye,color: primaryColor)
                    ),
                    addExerciseButton(context),                      
                  ]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding addExerciseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextButton(
        onPressed: () async {
          if (addExerciseForm.currentState!.validate()) {
            try {
              //*¿Hago una función sólo para que me haga la petición y la llamo? */
              await ExerciseService().addExercise(
                nameCtrl.text,
                descriptionCtrl.text,
                typeValue,
                muscleValue,
                imageValue,
                equipmentValue,
                difficultyValue,
                objectiveValue
              );
              // ignore: use_build_context_synchronously
              Navigator.push(context,MaterialPageRoute(builder: (context) => const AdminPage()));
            } catch (e) {
              return;
            } 
          }
        },
        style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(115, 20)),backgroundColor: MaterialStatePropertyAll(Colors.blue)),
        child: const Text('Añadir', style: TextStyle(color: secundaryColor))
      ),
    );
  }
}


class _SelectItems extends StatefulWidget {
  final List<String> items;
  final Icon icon;
  final Function(String) onItemSelected;

  const _SelectItems({
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
    return DropdownButtonFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione al menos una opción';
        }
        return null;
      },
      padding: const EdgeInsets.only(right: 7),
      icon: widget.icon,
      iconSize: 20,
      items: widget.items.map((item) {
        return DropdownMenuItem(
          alignment: Alignment.centerLeft,
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      focusColor: primaryColor,
      dropdownColor: secundaryColor,
      decoration: InputDecoration( 
        errorStyle: TextStyle(color: Colors.redAccent.withOpacity(0.6)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.6))),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
      ),
      borderRadius: BorderRadius.circular(20),
      isExpanded: true,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
          widget.onItemSelected(value);
        });
      }
    );
  }
}

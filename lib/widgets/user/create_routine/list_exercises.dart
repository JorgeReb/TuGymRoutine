// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tu_gym_routine/blocs/routine/routine_bloc.dart';
import 'package:tu_gym_routine/models/exercise.dart';

class ListExercises extends StatefulWidget {
  final List<Exercise> exercises;
  final void Function(String) returnExerciseId;

  const ListExercises({super.key, required this.exercises, required this.returnExerciseId});

  @override
  // ignore: library_private_types_in_public_api
  _ListExercisesState createState() => _ListExercisesState();
}

class _ListExercisesState extends State<ListExercises> {
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
          exercise.name!.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      height: 600,
      width: double.infinity,
      child: Column(
        children: [
          Text('Añadir ejercicios', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
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
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
                labelText: 'Buscar por nombre',
                labelStyle:TextStyle(color: Theme.of(context).colorScheme.secondary),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
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
                    widget.returnExerciseId(filteredExercises[index].id);
                    context.read<RoutineBloc>().add(ChangeEnabledInputsRoutine(isChooseExercise: false, isExerciseChosen: true, isShowExercise: false));
                  },
                  title: Text(filteredExercises[index].name!,style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary)),
                  subtitle: Text(filteredExercises[index].muscle!,style: TextStyle(fontWeight: FontWeight.w100,color: Theme.of(context).colorScheme.secondary),maxLines: 2), 
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
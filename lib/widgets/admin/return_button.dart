import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tu_gym_routine/blocs/exercise_admin/exercise_admin_bloc.dart';
import 'package:tu_gym_routine/pages/admin/admin_page.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: GestureDetector(
          onTap: () {
            context.read<ExerciseAdminBloc>().add(ChangeEnabledInputs(isEnabled: false));
            Navigator.push(context,MaterialPageRoute(builder: (context) => const AdminPage()));
          },
          child: const Icon(Icons.logout, color: Colors.grey, size: 50)
      ),
    );
  }
}
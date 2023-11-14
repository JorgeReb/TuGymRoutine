import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/blocs/user_admin/user_admin_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/pages/admin/admin_page.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/user_service.dart';
import 'package:tu_gym_routine/views/list_user_view.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';

class UserActionsButtons extends StatelessWidget {
  final Usuario user;
  const UserActionsButtons({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool isSure = false;

    return Padding(
      padding: const EdgeInsets.only(left: 75),
      child: Column(
        children: [
          IsAdminButton(user: user),
          TextButton(
              onPressed: () => BlocProvider.of<UserAdminBloc>(context).add(ChangeEnabledInputs(isEnabled: true)),
              style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(115, 20)),backgroundColor: MaterialStatePropertyAll(Colors.green)),
              child: const Text('Modificar usuario',style: TextStyle(color: secundaryColor))
          ),
          deleteUserButton(isSure, context),
        ],
      ),
    );
  }

  TextButton deleteUserButton(bool isSure, BuildContext context) {
    return TextButton(
      onPressed: () {
        CustomAlertDialog(
          icon: alertIcon,
          text: askIsSure,
          color: alertColor,
          textButton: TextButton(
              onPressed: () async {
                isSure = true;
                if (isSure == true) {
                  await UserService().deleteUser(user.id);
                  // ignore: use_build_context_synchronously
                  BlocProvider.of<AdminBloc>(context).add(ChangeViewEvent(view: const ListUserView()));
                  // ignore: use_build_context_synchronously
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const AdminPage()));
                }
              },
              child: confirmDeleteText),
        ).showCustomDialog(context);
      },
      style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(115, 20)),backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
      child: const Text('Eliminar usuario',style: TextStyle(color: secundaryColor)),
    );
  }
}
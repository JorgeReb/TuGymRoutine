import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tu_gym_routine/blocs/user_admin/user_admin_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/pages/admin/admin_page.dart';
import 'package:tu_gym_routine/services/user_service.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';
import 'package:tu_gym_routine/widgets/admin/return_button.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';

// ignore: must_be_immutable
class UserPage extends StatelessWidget {
  Usuario? user;

  UserPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<UserAdminBloc>().add(ChangeEnabledInputs(isEnabled: false));
        Navigator.push(context,MaterialPageRoute(builder: (context) => const AdminPage()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: FadeInDown(
              delay: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  _InfoUser(user!),
                  _FormUser(user: user!),
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

class _InfoUser extends StatelessWidget {
  final Usuario user;
  const _InfoUser(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 60, bottom: 35),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        height: 175,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  children: [
                    const _UserImage('https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
                    _UserName(user.name)
                  ],
                ),
              ),
              UserActionsButtons(user: user),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormUser extends StatefulWidget {
  final Usuario user;

  const _FormUser({required this.user});

  @override
  State<_FormUser> createState() => _FormUserState();
}

class _FormUserState extends State<_FormUser> {
  GlobalKey<FormState> userForm = GlobalKey();
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController weightCtrl;
  late final TextEditingController heightCtrl;
  bool isEnabled = false;
  bool isOk = false;

  @override
  void initState() {
    super.initState();
    emailCtrl = TextEditingController(text: widget.user.email);
    nameCtrl = TextEditingController(text: widget.user.name);
    weightCtrl = TextEditingController(text: widget.user.weight.toString());
    heightCtrl = TextEditingController(text: widget.user.height.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: userForm,
              child: BlocBuilder<UserAdminBloc, UserAdminState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      _CustomInputField(
                        controller: nameCtrl,
                        label: 'Nombre',
                        icon: Icon(Icons.account_circle_rounded,color: Theme.of(context).colorScheme.background),
                        isEnabled: state.isEnabled,
                        validator: validateName
                      ),
                      const SizedBox(height: 5),
                      _CustomInputField(
                        controller: emailCtrl,
                        label: 'Email',
                        icon: Icon(Icons.email, color: Theme.of(context).colorScheme.background),
                        isEnabled: state.isEnabled,
                        validator: validateEmail
                      ),
                      const SizedBox(height: 5),
                      _CustomInputField(
                        controller: weightCtrl,
                        label: 'Peso',
                        icon: Icon(Icons.email, color: Theme.of(context).colorScheme.background),
                        isEnabled: state.isEnabled,
                        validator: validateWeight
                      ),
                      const SizedBox(height: 5),
                      _CustomInputField(
                        controller: heightCtrl,
                        label: 'Altura',
                        icon: Icon(Icons.email, color: Theme.of(context).colorScheme.background),
                        isEnabled: state.isEnabled,
                        validator: validateHeight
                      ),
                      const SizedBox(height: 25),

                      if (state.isEnabled)
                      TextButton(
                        onPressed: () async {
                          if (userForm.currentState!.validate()) {
                            await UserService().updateUser(widget.user.id,emailCtrl.text.trim(), nameCtrl.text, double.parse(weightCtrl.text), double.parse(heightCtrl.text));
                            // ignore: use_build_context_synchronously
                            context.read<UserAdminBloc>().add(ChangeEnabledInputs(isEnabled: false));
                          } else {
                            isOk = true;
                          }
                          if (isOk == false) return;
                        },
                        style: const ButtonStyle(
                          fixedSize:MaterialStatePropertyAll(Size(115, 20)),
                          backgroundColor:MaterialStatePropertyAll(Colors.blue)),
                          child: const Text('Modificar',style: TextStyle(color: Colors.white)
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _CustomInputField extends StatelessWidget {
  final String label;
  final Icon icon;
  final bool isEnabled;
  final TextEditingController controller;
  String? Function(String? val)? validator;

  _CustomInputField({
    required this.label,
    required this.icon,
    required this.isEnabled,
    required this.validator,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Theme.of(context).colorScheme.background),
      controller: controller,
      enabled: isEnabled,
      cursorColor: Theme.of(context).colorScheme.background,
      validator: validator,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent.withOpacity(0.6)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.6))),
        border: const UnderlineInputBorder(),
        label: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.background)),
        suffixIcon: icon,
        labelStyle:  TextStyle(color: Theme.of(context).colorScheme.background),
        focusedBorder:  UnderlineInputBorder(borderSide: BorderSide(width: 1,color: Theme.of(context).colorScheme.background)),
        enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(width: 1,color: Theme.of(context).colorScheme.background)),
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  final String image;

  const _UserImage(
    this.image,
  );

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Image.network(
          image,
          color: Theme.of(context).colorScheme.secondary,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _UserName extends StatelessWidget {
  String name;
  _UserName(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Text(name,style: TextStyle(color: Theme.of(context).colorScheme.background, fontSize: 20),
      ),
    );
  }
}

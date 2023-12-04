// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tu_gym_routine/blocs/user/user_bloc.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/user_service.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';
import 'package:tu_gym_routine/views/views.dart';

class ProfileView extends StatelessWidget {
  final Usuario user;
  const ProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<UserBloc>().add(ChangeViewUserEvent(view: const LogoView()));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FadeInDown(
          delay: const Duration(milliseconds: 200),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const _UserImage(),
                Text(user.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w200
                  )
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: _ProfileForm(user: user),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileForm extends StatefulWidget {
  final Usuario user;
  const _ProfileForm({required this.user});

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  GlobalKey<FormState> profileFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    TextEditingController nameCtrl   = TextEditingController(text: widget.user.name);
    TextEditingController emailCtrl  = TextEditingController(text: widget.user.email);
    TextEditingController weightCtrl = TextEditingController(text: widget.user.weight.toString());
    TextEditingController heigthCtrl = TextEditingController(text: widget.user.height.toString());
    return Form(
      key: profileFormKey,
      child: Column(
        children: [
          _CustomProfileInput(
            controller: nameCtrl,
            validator: validateName,
            nombreCampo: 'Nombre',
            icon: Icons.account_circle,
            isObscureText: false,
          ),
          const SizedBox(height: 30),
          _CustomProfileInput(
            controller: emailCtrl,
            nombreCampo: 'Correo',
            icon: Icons.email,
            isObscureText: false,
            validator: validateEmail,
          ),
          const SizedBox(height: 30),
          _CustomProfileInput(
            controller: weightCtrl,
            nombreCampo: 'Peso',
            icon: FontAwesomeIcons.weightScale,
            isObscureText: false,
            validator: validateWeight,
          ),
          const SizedBox(height: 30),
          _CustomProfileInput(
            controller: heigthCtrl,
            nombreCampo: 'Altura',
            icon: FontAwesomeIcons.rulerVertical,
            isObscureText: false,
            validator: validateHeight,
          ),
          const SizedBox(height: 40),
          _SaveChanges(
              profileFormKey: profileFormKey,
              uid: widget.user.id,
              nameCtrl: nameCtrl,
              emailCtrl: emailCtrl,
              weightCtrl: weightCtrl,
              heightCtrl: heigthCtrl),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SaveChanges extends StatelessWidget {
  final String uid;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController heightCtrl;

  const _SaveChanges({
    required this.profileFormKey,
    required this.uid,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.weightCtrl,
    required this.heightCtrl,
  });

  final GlobalKey<FormState> profileFormKey;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style:  const ButtonStyle(fixedSize:  MaterialStatePropertyAll(Size(300, 30)), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
      onPressed: () async {
        if (profileFormKey.currentState!.validate()) {
          mostrarSnackbar(context);
          await UserService().updateUser(
              uid,
              emailCtrl.text.trim(),
              nameCtrl.text.trim(),
              double.parse(weightCtrl.text),
              double.parse(heightCtrl.text)
          );
          
          context.read<UserBloc>().add(ChangeViewUserEvent(view: const LogoView()));
          
          await Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePage()));

          return;
        }
      },
      child: const Text('Guardar', style: TextStyle(color: Colors.white ))
    );
  }
}

mostrarSnackbar(BuildContext context) {
  const snackBar = SnackBar(
    content: Text('Usuario modificado'),
    duration: Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class _CustomProfileInput extends StatelessWidget {
  final String nombreCampo;
  final IconData icon;
  final bool isObscureText;
  TextEditingController controller = TextEditingController();
  String? Function(String? val)? validator;

  _CustomProfileInput({
    required this.nombreCampo,
    required this.icon,
    required this.isObscureText,
    required this.controller,
    required this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      validator: validator,
      style:  TextStyle(color: Theme.of(context).colorScheme.secondary),
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent.withOpacity(0.6)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent.withOpacity(0.6))),
        border: const UnderlineInputBorder(),
        suffixIcon: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        labelText: nombreCampo,
        labelStyle:  TextStyle(color: Theme.of(context).colorScheme.secondary),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1,color: Theme.of(context).colorScheme.secondary,))
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: ClipOval(
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
              color: Theme.of(context).colorScheme.background,
              width: 150,
            ),
          ),
        ),
      ),
    );
  }
}

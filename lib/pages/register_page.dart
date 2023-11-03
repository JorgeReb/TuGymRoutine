import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/constants/constants.dart';

import 'package:tu_gym_routine/services/user_service.dart';
import '../validations/fields_validations.dart';
import '../widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          const SizedBox(height: 100),
          const NameLogo(),
          Container(
            height: 650,
            margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
            child: const _RegisterForm(),
          ),
        ]),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  FirebaseAuth auth = FirebaseAuth.instance;

  GlobalKey<FormState> registerFormKey = GlobalKey();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: registerFormKey,
      child: Column(
        children: [
          const ImageLogo(),
          const SizedBox(height: 15),
          CustomInputField(
            validator: validateName,
            controller: nameCtrl,
            nombreCampo: 'Nombre',
            icon: Icons.account_circle_rounded,
            isObscureText: false,
          ),
          const SizedBox(height: 25),
          CustomInputField(
            validator: validateEmail,
            controller: emailCtrl,
            nombreCampo: 'Correo',
            icon: Icons.email,
            isObscureText: false,
          ),
          const SizedBox(height: 25),
          CustomInputField(
            validator: validatePassword,
            controller: passwordCtrl,
            nombreCampo: 'Contraseña',
            icon: Icons.lock,
            isObscureText: true,
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () async {
              if (registerFormKey.currentState!.validate()) {
                  await registerUser();
                  setState(() {});
                }
              },
            child: const Text('Registrarse')
          ),
          const SizedBox(height: 5),
          const NavigateToLoginButton(),
          const SizedBox(height: 40),
          const Expanded(child: CustomFooter()),
        ],
      ),
    );
  }

  Future<void> registerUser() async {
    try {
      UserService().addUser(emailCtrl.text.trim(),passwordCtrl.text.trim(),nameCtrl.text.trim())
        .then((value) {
        return CustomAlertDialog(
          icon: successIcon,
          text: succesTextRegister,
          color: succesColor,
          textButton: TextButton(child: aceptText,onPressed: () => Navigator.pushNamed(context, '/home'))
        ).showCustomDialog(context);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        // ignore: use_build_context_synchronously
        return CustomAlertDialog(
          icon: alertIcon,
          text: weakPasswordText,
          color: alertColor,
          textButton: TextButton(child: cancelText, onPressed: () => Navigator.pop(context))
        ).showCustomDialog(context);
      } else if (e.code == "email-already-in-use") {
        // ignore: use_build_context_synchronously
        return CustomAlertDialog(
          icon: alertIcon,
          text: isRegisterdText,
          color: alertColor,
          textButton: TextButton(child: cancelText, onPressed: () => Navigator.pop(context))
          ).showCustomDialog(context);
      } else {
        // ignore: use_build_context_synchronously
        return CustomAlertDialog(
          icon: alertIcon,
          text: alertTextRegister,
          color: alertColor,
          textButton: TextButton(child: cancelText, onPressed: () => Navigator.pop(context))
          ).showCustomDialog(context);
      }
    }
  }
}

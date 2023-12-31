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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const NameLogo(),
            Container(
              height: 650,
              margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
              child: const _RegisterForm(),
            ),
          ],
        ),
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
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                fixedSize: MaterialStatePropertyAll(Size(300, 30))
            ),
            onPressed: () async {
              if (registerFormKey.currentState!.validate()) {
                await registerUser();
              }
            },
            child: const Text('Registrarse', style: TextStyle(color: Colors.white),)
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
    UserService().addUser(emailCtrl.text.trim(), passwordCtrl.text.trim(),nameCtrl.text.trim())
      .then((value) {
      if (value['message'] == "The password must be a string with at least 6 characters.") {
        return CustomAlertDialog(
          icon: alertIcon,
          text: weakPasswordText,
          color: alertColor,
          textButton: TextButton(child: cancelText, onPressed: () => Navigator.pop(context))
        ).showCustomDialog(context);
      } else if (value['message'] == "The email address is already in use by another account.") {
        return CustomAlertDialog(
          icon: alertIcon,
          text: isRegisterdText,
          color: alertColor,
          textButton: TextButton(child: cancelText, onPressed: () => Navigator.pop(context))
        ).showCustomDialog(context);
      } else if (value['success'] == true) {
        return CustomAlertDialog(
          icon: successIcon,
          text: succesTextRegister,
          color: succesColor,
          textButton: TextButton(child: aceptText,onPressed: () => Navigator.pushNamed(context, '/'))
        ).showCustomDialog(context);
      } else {
        return CustomAlertDialog(
          icon: alertIcon,
          text: alertTextRegister,
          color: alertColor,
          textButton: TextButton(child: cancelText, onPressed: () => Navigator.pop(context))
        ).showCustomDialog(context);
      }
    });
  }
}

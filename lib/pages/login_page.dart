// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const NameLogo(),
            Container(
              height: 650,
              margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
              child: const _LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  FirebaseAuth auth = FirebaseAuth.instance;

  GlobalKey<FormState> loginFormKey = GlobalKey();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          const ImageLogo(),
          const SizedBox(height: 20),
          CustomInputField(
            controller: emailCtrl,
            nombreCampo: 'Correo',
            icon: Icons.email,
            isObscureText: false,
            validator: validateEmail,
          ),
          const SizedBox(height: 40),
          CustomInputField(
            validator: validatePassword,
            controller: passwordCtrl,
            nombreCampo: 'Contraseña',
            icon: Icons.lock,
            isObscureText: true,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                fixedSize: MaterialStatePropertyAll(Size(300, 30))
            ),
            onPressed: () async {
              if (loginFormKey.currentState!.validate()) await loginUser();
            },
            child: const Text('Iniciar sesión')
          ),
          const SizedBox(height: 20),
          const NavigateToRegisterButton(),
          const SizedBox(height: 40),
          const Expanded(child: CustomFooter()),
        ],
      ),
    );
  }

  Future<void> loginUser() async {
    try {
      final authData = await auth.signInWithEmailAndPassword(email: emailCtrl.text.trim(), password: passwordCtrl.text.trim());
      IdTokenResult result = await authData.user!.getIdTokenResult();
      final isAdmin = result.claims!['admin'];

      if (isAdmin == true) {
        if(mounted){
        Navigator.pushReplacementNamed(context, "/admin");
        }
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          CustomAlertDialog(
            icon: alertIcon,
            text: invalidPasswordText,
            color: alertColor,
            textButton: TextButton(onPressed: () => Navigator.pop(context), child: cancelText),
          ).showCustomDialog(context);
        break;
        case "user-not-found":
          CustomAlertDialog(
            icon: alertIcon,
            text: invalidEmailText,
            color: alertColor,
            textButton: TextButton(onPressed: () => Navigator.pop(context), child: cancelText),
          ).showCustomDialog(context);
        break;
        case "too-many-requests":
          CustomAlertDialog(
            icon: alertIcon,
            text: userDiabledText,
            color: alertColor,
            textButton: TextButton(onPressed: () => Navigator.pop(context), child: cancelText),
          ).showCustomDialog(context);
        break;
        case "INVALID_LOGIN_CREDENTIALS":
          CustomAlertDialog(
            icon: alertIcon,
            text: invalidEmailText,
            color: alertColor,
            textButton: TextButton(onPressed: () => Navigator.pop(context), child: cancelText),
          ).showCustomDialog(context);
        break;
      }
    }
  }
}

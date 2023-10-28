import 'package:flutter/material.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';

import '../services/firebase_service.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            // decoration: BoxDecoration(
            //   border: Border.all(width: 3.0),
            //   borderRadius: const BorderRadius.all(Radius.circular(10)),
            // ),
            child: const _LoginForm(),
          ),
        ]),
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
              onPressed: () async {
                //pasar como admin
                if(emailCtrl.text.trim() == 'Administrador' && passwordCtrl.text == '123'){
                  Navigator.pushReplacementNamed(context, "/admin", arguments: {'usuario': emailCtrl.text});
                }
                if (loginFormKey.currentState!.validate()) {
                  final usuarios = await getUsers();
                  bool isRegistered = false;

                  for (var usuario in usuarios) {
                    if (usuario['email'] == emailCtrl.text && usuario['password'] == passwordCtrl.text) {
                      isRegistered = true;
                      break;
                    } else {
                      isRegistered = false;
                    }
                  }
                  if (isRegistered == true) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, "/home");
                  } else {
                    // ignore: use_build_context_synchronously
                    return showCustomDialog(
                      context,
                      Colors.redAccent.withOpacity(0.7),
                      Icon(Icons.warning_amber_rounded,color: Colors.redAccent.withOpacity(0.7)),
                      const Text("Los datos introducidos no concuerdan con niguna cuenta existente.",style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
                      TextButton(child: Text("Volver",style: TextStyle(color: Colors.redAccent.withOpacity(0.7)),),
                          onPressed: () {
                            Navigator.of(context).pop();
                      }));
                  }
                }
              },
            child: const Text('Iniciar sesión')
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/register");
            },
            style: const ButtonStyle(
              side: MaterialStatePropertyAll(BorderSide.none),
            ),
            child: const Text(
              '¿No tienes cuenta? Regístrate',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Expanded(
            child: CustomFooter(),
          ),
        ],
      ),
    );
  }

  Future<void> showCustomDialog(
      BuildContext context, color, icon, text, textButton) {
    return showDialog(
      context: context,
      builder: (_) => CustomAlertDialog(
        color: color,
        icon: icon,
        text: text,
        textButton: textButton,
      ),
    );
  }
}

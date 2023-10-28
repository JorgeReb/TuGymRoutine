import 'package:flutter/material.dart';
import 'package:tu_gym_routine/services/firebase_service.dart';
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
            // decoration: BoxDecoration(
            //   border: Border.all(width: 3.0),
            //   borderRadius: const BorderRadius.all(Radius.circular(10)),
            // ),
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
                  final usuarios = await getUsers();
                  bool isRegistered = false;
                  for (var usuario in usuarios) {
                    if (usuario['email'] == emailCtrl.text) {
                      isRegistered = true;
                      break;
                    } else {
                      isRegistered = false;
                    }
                  }
                  if (isRegistered == true) {
                    // ignore: use_build_context_synchronously
                    return showCustomDialog(
                      context,
                      Colors.redAccent.withOpacity(0.7),
                      Icon(Icons.warning_amber_rounded,color: Colors.redAccent.withOpacity(0.7)),
                      const Text("Este correo ya ha sido registrado anteriormente.",style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
                      TextButton(child: Text("Volver",style: TextStyle(color: Colors.redAccent.withOpacity(0.7))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    );
                  } else {
                    await addUser(
                            emailCtrl.text, nameCtrl.text, passwordCtrl.text)
                        .then((value) {
                      return showCustomDialog(
                          context,
                          Colors.blueAccent,
                          const Icon(Icons.check_circle_outline,color: Colors.blueAccent,),
                          const Text('Usted ha sido registrado correctamente en la aplicación',style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
                          TextButton(child: const Text("Aceptar",style: TextStyle(color: Colors.blueAccent),),
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                          })
                        );
                    });
                    setState(() {});
                  }
                }
              },
              child: const Text('Registrarse')),
          const SizedBox(height: 5),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/");
            },
            style: const ButtonStyle(
                side: MaterialStatePropertyAll(BorderSide.none)),
            child: const Text(
              '¿Ya tienes cuenta?',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Expanded(child: CustomFooter()),
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

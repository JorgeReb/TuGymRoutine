// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';
import 'package:tu_gym_routine/widgets/shared/custom_alert_dialog.dart';
import 'package:tu_gym_routine/widgets/shared/custom_input_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  GlobalKey<FormState> changePasswordKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final passwordCtrl = TextEditingController();
    final repeatPasswordCtrl = TextEditingController();
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: FadeInDown(
        child: SingleChildScrollView(
          child: Form(
            key: changePasswordKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      alignment: Alignment.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 50),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: theme.secondary,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    'Cambiar contraseña',
                    style: TextStyle(
                      color: theme.secondary,
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60, top: 40),
                  child: CustomInputField(
                    controller: passwordCtrl,
                    nombreCampo: 'Nueva contraseña',
                    icon: Icons.password,
                    isObscureText: true,
                    validator: validatePassword,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 60, right: 60, top: 40, bottom: 20),
                  child: CustomInputField(
                    controller: repeatPasswordCtrl,
                    nombreCampo: 'Repetir contraseña',
                    icon: Icons.password,
                    isObscureText: true,
                    validator: validatePassword,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        fixedSize: MaterialStatePropertyAll(Size(270, 30))),
                    onPressed: () async {
                      if (changePasswordKey.currentState!.validate()) await changePassword(passwordCtrl.text.trim(),repeatPasswordCtrl.text.trim());
                    },
                    child: const Text('Cambiar contraseña', style: TextStyle(color: Colors.white),))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changePassword(String password, String repeatPassword) async {
    if (password == repeatPassword) {
      try {
        final User? currentUser = FirebaseAuth.instance.currentUser;
        await currentUser!.updatePassword(password);
        CustomAlertDialog(
          icon: successIcon,
          text: successUpdatePasswordText,
          color: succesColor,
          textButton: TextButton(onPressed: () => Navigator.pop(context), child: aceptText)
        ).showCustomDialog(context);
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "requires-recent-login":
            CustomAlertDialog(
              icon: alertIcon,
              text: requireRecentLoginText,
              color: alertColor,
              textButton: TextButton(onPressed: () => Navigator.pop(context), child: cancelText),
            ).showCustomDialog(context);
          break;
          case "weak-password":
            CustomAlertDialog(
              icon: alertIcon,
              text: weakPasswordText,
              color: alertColor,
              textButton: TextButton(onPressed: () => Navigator.pop(context), child: cancelText),
            ).showCustomDialog(context);
            break;
        }
      }
    }else{
      CustomAlertDialog(
          icon: alertIcon,
          text: const Text('Las contraseñas deben coincidir', style: TextStyle(color: secondaryColor)),
          color: alertColor,
          textButton: TextButton(onPressed: () => Navigator.pop(context), child: cancelText),
        ).showCustomDialog(context);
    }
  } 
}

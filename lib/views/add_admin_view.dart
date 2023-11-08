import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/services/firestore_service.dart';
import 'package:tu_gym_routine/services/user_service.dart';
import 'package:tu_gym_routine/validations/fields_validations.dart';

import '../constants/constants.dart';

class AddAdminView extends StatelessWidget {
  const AddAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          const SizedBox(height: 20),
          Container(
            height: 650,
            margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
            child: const _AdminForm(),
          ),
        ]),
      ),
    );
  }
}

class _AdminForm extends StatefulWidget {
  const _AdminForm();

  @override
  State<_AdminForm> createState() => _AdminFormState();
}

class _AdminFormState extends State<_AdminForm> {
  FirebaseAuth auth = FirebaseAuth.instance;

  GlobalKey<FormState> adminFormKey = GlobalKey();
  TextEditingController uidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: adminFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: uidController,
            style: const TextStyle(
              color: primaryColor,
            ),
            decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.redAccent.withOpacity(0.6)),
                errorBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.redAccent.withOpacity(0.6))),
                border: const UnderlineInputBorder(),
                suffixIcon: const Icon(Icons.email, color: primaryColor),
                labelText: 'UID',
                labelStyle: const TextStyle(color: primaryColor),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                  width: 2,
                  color: primaryColor,
                ))),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () async {
                callAddAdminPrivileges(auth.currentUser!);
              },
              child: const Text('Dar permisos')),
        ],
      ),
    );
  }

  callAddAdminPrivileges(User user)  async{
    print(" TOKEN EN ADMINNNN ========== ${await user.getIdToken()}");
   UserService().addAdminPrivileges(user,uidController.text.trim());    
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/services/user_service.dart';

class IsAdminButton extends StatefulWidget {
  final Usuario user;

  const IsAdminButton({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _IsAdminButton createState() => _IsAdminButton();
}

class _IsAdminButton extends State<IsAdminButton> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _initializeState();
    
  }

  Future<void> _initializeState() async {
  await verifyAdminInFirestore(widget.user.email);
}

  Future<void> verifyAdminInFirestore(String correo) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: correo)
        .where('admin', isEqualTo: true)
        .get();

    setState(() => isAdmin = querySnapshot.docs.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isAdmin
            ? TextButton(
                onPressed: () async{
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await UserService().removeAdminPrivileges(auth.currentUser!, widget.user.id, widget.user.email, widget.user.name);
                  setState(() => isAdmin = false);
                },
                style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(135, 20)),backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 240, 180, 2))),
                child: const Text('Quitar privilegios',style: TextStyle(color: secondaryColor)))
            : TextButton(
                onPressed: () async{
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await UserService().addAdminPrivileges(auth.currentUser!, widget.user.id);
                  setState(() => isAdmin = true);
                },
                style: const ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(135, 20)),backgroundColor: MaterialStatePropertyAll(Colors.indigo)),
                child: const Text('Dar privilegios',style: TextStyle(color: secondaryColor))),
      ],
    );
  }
}

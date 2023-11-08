import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/services/user_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;
    String? email = "";

    if (usuario != null) {
      email = usuario.email;
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(email!),
            // FutureBuilder(
            //   future: UserService().getUsers(),
            //   builder: (context, snapshot) {             
            //     if (snapshot.hasData) {
            //       return ListView.builder(
            //         itemCount: snapshot.data?.length,
            //         itemBuilder: (context, index) {
            //           return Text(snapshot.data?[index]['name']);
            //         },
            //       );
            //     } else {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   },
            // ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text('salir'))
          ],
        ),
      ),
    );
  }
}

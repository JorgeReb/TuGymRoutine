import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAdminDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: primaryColor,
        elevation: 10,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text('${user!.email}',style: const TextStyle(fontSize: 15),textAlign: TextAlign.center,),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.account_circle_rounded,size: 30),
          )
        ],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, adminState) {
          getToken().then((dynamic result){
            String token = result.toString();
            adminState.token = token;
          });
          return adminState.view!;
        },
      ),
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
    );
  }

  Future<dynamic> getToken() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    IdTokenResult result = await auth.currentUser!.getIdTokenResult();
    final token = result.token;
    return token;
  }
}

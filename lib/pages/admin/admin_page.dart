import 'package:flutter/material.dart';
import 'package:tu_gym_routine/views/delete_user_view.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';

class AdminPage extends StatelessWidget {
  
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isApageView;
    Map? parameters = ModalRoute.of(context)?.settings.arguments as Map?;
    print('${parameters!['page']}');
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        elevation: 10,
        actions:  [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text('${parameters['usuario']}', style: const TextStyle(fontSize: 15), textAlign: TextAlign.center,),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Icon(Icons.account_circle_rounded, size: 30,),
          )
        ],
      ),
      body: 
       const DeleteUserView() ,
      // ? const CircularProgressIndicator()
      // :
      // Padding(
      //   padding: const EdgeInsets.all(30.0),
      //   child: Image.asset(
      //     'assets/foto_nombre.png',
      //     alignment: Alignment.center,
      //     height: double.infinity,
      //     width: double.infinity,
      //     fit: BoxFit.contain,
      //   ),
      // ),
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
    );
  }
}

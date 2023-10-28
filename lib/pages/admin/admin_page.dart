import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/views/delete_user_view.dart';
import 'package:tu_gym_routine/widgets/widgets.dart';

class AdminPage extends StatelessWidget {
  
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map? parameters = ModalRoute.of(context)?.settings.arguments as Map?;
    //print('${parameters!['page']}');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdminBloc()
        ),
      ],
      child: Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        elevation: 10,
        actions:  [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text('${parameters?['usuario']}', style: const TextStyle(fontSize: 15), textAlign: TextAlign.center,),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Icon(Icons.account_circle_rounded, size: 30,),
          )
        ],
      ),
      body: BlocBuilder<AdminBloc,AdminState>(
        builder: (context, state) {
          return state.page!;
        },
      ),
             
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      )
    );
  }
}

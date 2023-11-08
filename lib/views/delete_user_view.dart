// import 'package:flutter/material.dart';
// import 'package:tu_gym_routine/services/user_service.dart';

// class DeleteUserView extends StatelessWidget {
//   const DeleteUserView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: FutureBuilder(
//         future: UserService().getUsers(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data?.length,
//               itemBuilder: (context, index) {
//                 return Dismissible(
//                   direction: DismissDirection.startToEnd,
//                   confirmDismiss: (direction) async {
//                     bool result = false;
//                     result = await showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text(
//                               '¿Estás seguro de eliminar a ${snapshot.data?[index].name}'),
//                           actions: [
//                             TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 child: const Text('Cancelar',style: TextStyle(color: Colors.redAccent),)
//                               ),
//                             TextButton(
//                                 onPressed: () =>  Navigator.pop(context, true),
//                                 child: const Text('Aceptar')
//                               ),
//                           ],
//                         );
//                       },
//                     );
//                     return result;
//                   },
//                   onDismissed: (direction) async {
//                     final String uid = snapshot.data?[index].id;
//                     await UserService().deleteUser(uid);

//                     const snackBar =  SnackBar(content: Text('El usuario ha sido eliminado'));
//                     // ignore: use_build_context_synchronously
//                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                   },
//                   background: Container(
//                     color: Colors.redAccent,
//                     alignment: Alignment.centerLeft,
//                     padding: const EdgeInsets.only(left: 20),
//                     child: const Icon(Icons.delete,color: Colors.white,)
//                   ),
//                   key: UniqueKey(),
//                   child: ListTile(title: Text('${snapshot.data?[index].name}  |  ${snapshot.data?[index].email}', textAlign: TextAlign.left,)),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }

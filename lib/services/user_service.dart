import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tu_gym_routine/models/usuario.dart';

class UserService {
  final dio = Dio();

  CollectionReference collectionReferenceUser = FirebaseFirestore.instance
      .collection('users'); //selecionamos la tabla de la bbdd

 getUsers() async {
    List<Usuario> users = [];
    QuerySnapshot queryUser = await collectionReferenceUser.get(); //obtenemos los registros que hay en esa coleccion

    for (var document in queryUser.docs) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final Usuario user = Usuario.fromMap({'id': document.id, ...data});
      users.add(user);
    }
    return users;
  }

  deleteUser(String uid) async {
    final response = 
    await dio.post('https://deleteuser-ycxk3qq6za-uc.a.run.app', data: {"uid": uid});
    return response.data;
  }

  addAdminPrivileges(User user, String uid) async {
    

    final token = await user.getIdToken();  

    dio.options.headers["authorization"] = "token $token";
    final response = 
      await dio.post('https://addadminprivileges-ycxk3qq6za-uc.a.run.app', data: {"uid": uid} , options: Options(headers: {
        "authorization": "Bearer $token"
    }));
    return response.data;
  }

  addUser(String email, String password, String name) async {
    final response =
    await dio.post('https://adduser-ycxk3qq6za-uc.a.run.app', data: {
      "email": email,
      "password": password,
      "name": name,
    });
    return response.data;
  }
}

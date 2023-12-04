import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/models/workout.dart';

class UserService {
  final dio = Dio();

  CollectionReference collectionReferenceUser = FirebaseFirestore.instance.collection('users'); //selecionamos la tabla de la bbdd

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

  Future<Usuario> getUserById(String uid) async {
    
    DocumentSnapshot<Object?> queryUser = await collectionReferenceUser.doc(uid).get();
    Usuario user = Usuario.fromDocumentSnapshot(queryUser);

    return user;
  }

  addUser(String email, String password, String name) async {
    try {
      final response = await dio.post('https://adduser-ycxk3qq6za-uc.a.run.app', data: {
        "email": email,
        "password": password,
        "name": name,
      });
      return response.data;
    } catch (e) {
      return e;
    }
  }



  deleteUser(String uid) async {
    final response = await dio.post('https://deleteuser-ycxk3qq6za-uc.a.run.app', data: {"uid": uid});
    return response.data;
  }

  updateUser(String uid, String email, String name, double weight, double height) async {
    await collectionReferenceUser.doc(uid).update({"email": email, "name": name, "weight": weight, "height": height});

    final response = await dio.post('https://updateuser-ycxk3qq6za-uc.a.run.app',data: {
      "uid": uid, "email": email
    });

    return response.data;
  }


  addAdminPrivileges(User user, String uid) async {
    final token = await user.getIdToken();

    dio.options.headers["authorization"] = "token $token";
    final response = await dio.post('https://addadminprivileges-ycxk3qq6za-uc.a.run.app',
        data: {"uid": uid},
        options: Options(headers: {"authorization": "Bearer $token"}));

    return response.data;
  }

  removeAdminPrivileges(
    User user, String uid, String email, String name) async {
      final token = await user.getIdToken();

      dio.options.headers["authorization"] = "token $token";

      final response = await dio.post('https://removeadminprivileges-ycxk3qq6za-uc.a.run.app',
          data: {"uid": uid, "email": email, "name": name},
          options: Options(headers: {"authorization": "Bearer $token"}));

    return response.data;
  }
}

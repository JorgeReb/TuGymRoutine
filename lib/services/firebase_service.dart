import 'package:cloud_firestore/cloud_firestore.dart';


//Variables para acceder a ña base de datos
FirebaseFirestore db = FirebaseFirestore.instance;
CollectionReference collectionReferenceUser = db.collection('usuario');//selecionamos la tabla de la bbdd

//Recoger los usuarios de la bbdd
Future<List> getUsers() async {
  List user = []; 
  QuerySnapshot queryUser = await collectionReferenceUser.get(); //obtenemos los registros que hay en esa coleccion

  for (var documento in queryUser.docs) {
    user.add(documento.data());
   }
   
  return user;
}

//Guardar usuario en bbdd
Future<void> addUser(String email,String name, String password) async {
  await collectionReferenceUser.add({
    "email"    : email,
    "name"     : name,
    "password" : password
  });
}
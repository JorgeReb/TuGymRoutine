import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {

  Future<List> getCollection(String collection) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collection);
    QuerySnapshot query = await collectionReference.get();

    List data = [];

    for (var documento in query.docs) {
      data.add(documento.data());
    }
    return data;
  }

  Future<void> addToCollection(String collection, data) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collection);
    await collectionReference.add({data});
  }  

  Future<void> deleteDocument(String collection, String uid) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collection);
    await collectionReference.doc(uid).delete();
  }
}

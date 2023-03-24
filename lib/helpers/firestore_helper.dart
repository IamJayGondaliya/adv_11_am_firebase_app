import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._();
  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  CollectionReference? collectionReference;

  connectCollection() {
    collectionReference = fireStore.collection('Emp');
  }

  Future<void> addUser({
    required String name,
    required String email,
    required int contact,
  }) async {
    connectCollection();

    String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

    await collectionReference!
        .doc(uniqueId)
        .set({
          'id': uniqueId,
          'name': name,
          'contact': contact,
          'email': email,
        })
        .then(
          (value) => print("User added"),
        )
        .catchError(
          (error) => print("$error"),
        );
  }

  Stream<QuerySnapshot<Object?>> getUser() {
    connectCollection();

    return collectionReference!.snapshots();
  }

  editUser({required String id, required Map<Object, Object> data}) {
    connectCollection();

    collectionReference!
        .doc(id)
        .update(data)
        .then((value) => print("User edited..."))
        .catchError((error) => print(error));

    // collectionReference!.where('name');
    //
    // collectionReference
    //     .doc()
    //     .print("==========================================");
    // print(collectionReference!.id);
    // print("==========================================");
  }

  removeRecord({required String id}) {
    connectCollection();

    collectionReference!
        .doc(id)
        .delete()
        .then((value) => print("Record deleted..."))
        .catchError((error) => print(error));
  }
}

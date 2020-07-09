import 'package:Fixify/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// First Name
// Last Name 
// PhoneNumber
// UID

class UserServices{
  // The User Collection
  String collection = "users";
  // Call Firestore Instance
  Firestore _firestore = Firestore.instance;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    // UID => Document
    _firestore.collection(collection).document(id).setData(values);
  }

  void updateUserData(Map<String, dynamic> values){
    _firestore.collection(collection).document(values['id']).updateData(values);
  }

  Future<UserModel> getUserById(String id) => _firestore.collection(collection).document(id).get().then((doc){
    if(doc.data == null){
      return null;
    }
    return UserModel.fromSnapshot(doc);
  });
}
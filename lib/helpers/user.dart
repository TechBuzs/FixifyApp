import 'package:Fixify/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserService{

  String collection = "users";
  Firestore _firestore = Firestore.instance;

  void createUser(Map<String, dynamic> values){
    String id = values["id"];
    _firestore.collection(collection).document(id).setData(values);
  }
  void updateUserData(Map<String, dynamic> values){
        _firestore.collection(collection).document(values["id"]).setData(values);

  }
  Future<UserModel> getUserByID(String id) => _firestore.collection(collection).document(id).get().then((doc){
    if(doc.data == null){
      return null;
    }
    return UserModel.fromSnapshot(doc);
  });
}
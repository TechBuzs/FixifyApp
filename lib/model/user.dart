import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = "number";
  static const ID = "id";
  static const FIRSTNAME = "firstname";
  static const LASTNAME = "lastname";

  String _number;
  String _id;
  String _firstname;
  String _lastname;

//  getters
  String get number => _number;
  String get id => _id;
  String get firstname => _firstname;
  String get lastname => _lastname;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _number = snapshot.data[NUMBER];
    _lastname = snapshot.data[lastname];
    _id = snapshot.data[ID];
    _firstname = snapshot.data[firstname];

  }
}
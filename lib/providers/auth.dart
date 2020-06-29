import 'dart:async';

import 'package:Fixify/helpers/user.dart';
import 'package:Fixify/models/user.dart';
import 'package:Fixify/screens/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninit, Authenicated, Authenicating, UnAuthenicated }

class AuthProvider extends ChangeNotifier {
  static const SIGNEDIN = "loggedin";
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  Status _status = Status.Uninit;

  UserService _userService = UserService();
  UserModel _usermodel;
  TextEditingController phoneNo;
  String smsOTP;
  String verificationID;
  String errorMessage;
  bool isloggedin;
  bool isloading = false;

  //getter
  UserModel get usermodel => _usermodel;

  Status get status => _status;
  FirebaseUser get user => _user;
  AuthProvider.initialize() {
    readPrefs();
  }

  Future<void> readPrefs() async {
    await Future.delayed(Duration(seconds: 3)).then((v) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isloggedin = prefs.getBool(SIGNEDIN) ?? false;

      if (isloggedin) {
        _user = await _auth.currentUser();
        _usermodel = await _userService.getUserByID(_user.uid);
        _status = Status.Authenicated;
        notifyListeners();
      }
    });
  }

  Future<void> verifyPhoneNumber(BuildContext context, String number) async {
    final PhoneCodeSent smsOTP = (String verID, [int forceCodeResend]) {
      this.verificationID = verID;
      smsOTPDialog(context).then((value) {});
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: number.trim(),
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCred) {
            print(phoneAuthCred.toString());
          },
          verificationFailed: (AuthException phoneAuthCred) {
            print('${phoneAuthCred.toString()}');
          },
          codeSent: smsOTP,
          codeAutoRetrievalTimeout: (String verID) {
            this.verificationID = verID;
          });
    } catch (e) {}
  }

  void _createUser({String id, String number}) {
    _userService.createUser({"id": id, "number": number});
  }

  signIn(BuildContext context) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationID, smsCode: smsOTP);
      final AuthResult user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.user.uid == currentUser.uid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(SIGNEDIN, true);
      isloggedin = true;
      if (user != null) {
        _usermodel = await _userService.getUserByID(user.user.uid);
        if (_usermodel == null) {
          _createUser(id: user.user.uid, number: user.user.phoneNumber);
        }
        isloading = false;
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
        notifyListeners();
      }
    } catch (e) {
      print('${e.toString()}');
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter OTP code"),
            content: Container(
              height: 84,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                )
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () async {
                  isloading = true;
                  notifyListeners();
                  _auth.currentUser().then((user) async {
                    if (user != null) {
                      _usermodel = await _userService.getUserByID(user.uid);
                      if (_usermodel == null) {
                        _createUser(id: user.uid, number: user.phoneNumber);
                      }
                      isloading = false;
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    } else {
                      isloading = true;
                      notifyListeners();
                      Navigator.pop(context);
                      isloading = false;
                    }
                  });
                },
              )
            ],
          );
        });
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.UnAuthenicated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}

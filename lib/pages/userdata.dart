import 'package:Fixify/Service/cloud_firestore_service.dart';
import 'package:Fixify/pages/animations.dart';
import 'package:Fixify/pages/home.dart';
import 'package:Fixify/pages/valid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserData extends StatelessWidget {

// class UserData extends StatefulWidget {
  UserData({
    Key key,
     this.uid,
   @required this.phoneNumber,
  
  }) : super(key: key);
    final String phoneNumber, uid;

//   @override
//   _UserDataState createState() => _UserDataState();
// }

// class _UserDataState extends State<UserData> {
bool _autoValidate = false;

  bool _loadingVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserServices _userServicse = UserServices();

  final TextEditingController _firstName = new TextEditingController();

  final TextEditingController _lastName = new TextEditingController();

  //

  void _createUser({String id, String number}) async{
    // User = Current 
   
    final user = await FirebaseAuth.instance.currentUser();
     if(user != null){
      _userServicse.createUser({
      "id": user.uid,
      "number": user.phoneNumber,
      "firstname": _firstName.text,
      "lastname": _lastName.text,
    });
    }else{
    print('Error');
    }
  }
  Widget makeNameF({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          textCapitalization: TextCapitalization.words,
          controller: _firstName,
          validator: Validator.validateName,
          autofocus: false,
          obscureText: obscureText,
          // controller: _emailController,

          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget makeNameL({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          textCapitalization: TextCapitalization.words,
          controller: _lastName,
          validator: Validator.validateName,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          obscureText: obscureText,
          // controller: _emailController,

          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }


 void _emailSignUp(
      {String firstName,
      String lastName,
      String email,
      String password,
      BuildContext context}) async {
    // if (_formKey.currentState.validate()) {
    try {
      // SystemChannels.textInput.invokeMethod('TextInput.hide');
      // await _changeLoadingVisible();
      //need await so it has chance to go through error if found.
    
        // await Auth().si
         _createUser(id: uid, number: phoneNumber);
      
        
      
      
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      // _changeLoadingVisible();
      print("Sign Up Error: $e");
      // String exception = CloudF.getExceptionText(e);
      // Flushbar(
      //   title: "Sign Up Error",
      //   message: exception,
      //   duration: Duration(seconds: 5),
      // )..show(context);
    }
    // } else {
    //   setState(() => _autoValidate = true);
    // }
  }
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Continue',
          style: TextStyle(color: Colors.black),
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  // FadeAnimation(1, Text("Sign up", style: TextStyle(
                  //   fontSize: 30,
                  //   fontWeight: FontWeight.bold
                  // ),)),
                  // SizedBox(height: 20,),
                  FadeAnimation(
                      1.2,
                      Text(
                        "We need to Get Some Info",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )),
                  // showErrorMessage(),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeAnimation(1.2, makeNameF(label: "First Name")),
                  FadeAnimation(1.2, makeNameL(label: "Last Name")),
                 
                ],
              ),
              FadeAnimation(
                  1.5,
                  Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        _emailSignUp(
                            firstName: _firstName.text,
                            lastName: _lastName.text,
                            
                            context: context);
                      },

                      //       if (_formKey.currentState.validate()) {
                      //       _register();
                      //       Scaffold.of(context).showSnackBar(
                      //            SnackBar(
                      //         content: Container(
                      // alignment: Alignment.center,
                      // child: Text(_success == null
                      //     ? ''
                      //     : (_success
                      //         ? Navigator.push(context, MaterialPageRoute(builder: (context) => Home()))
                      //         : 'Registration failed')),
                      // ))
                      //       );
                      //     }

                      color: Colors.greenAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )),
             
            ],
          ),
        ),
      ),
    );
  

  


//   @override
//   void dispose() {
//     // Clean up the controller when the Widget is disposed
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Example code for registration.
//   void _register() async {
//     final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
//       email: _emailController.text,
//       password: _passwordController.text,
//     ))
//         .user;
//     if (user != null) {
//       setState(() {
//         _success = true;
//         _userEmail = user.email;
//       });
//     } else {
//       _success = false;
//     }
//   }
  // Widget _showCircularProgress() {
  //   if (_isLoading) {
  //     return Center(child: CircularProgressIndicator());
  //   }
  //   return Container(
  //     height: 0.0,
  //     width: 0.0,
  //   );

  // }
  //   Widget showErrorMessage() {
  //   if (_errorMessage.length > 0 && _errorMessage != null) {
  //     return new Text(
  //       _errorMessage,
  //       style: TextStyle(
  //           fontSize: 13.0,
  //           color: Colors.red,
  //           height: 1.0,
  //           fontWeight: FontWeight.w300),
  //     );
  //   } else {
  //     return new Container(
  //       height: 0.0,
  //     );
  //   }
  // }
//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
  

  // void _showVerifyEmailSentDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Verify your account"),
  //         content:
  //             new Text("Link to verify account has been sent to your email"),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text("Dismiss"),
  //             onPressed: () {
  //               //  toggleFormMode();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _changeLoadingVisible() async {
  //   setState(() {
  //     _loadingVisible = !_loadingVisible;
  //   });
  // }
}
}

import 'package:Fixify/Service/cloud_firestore_service.dart';
import 'package:Fixify/pages/animations.dart';
import 'package:Fixify/pages/home.dart';
import 'package:Fixify/pages/valid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class UserData extends StatefulWidget {
// class UserData extends StatefulWidget {
  UserData({
    Key key,
    this.uid,
    @required this.phoneNumber,
  }) : super(key: key);
  final String phoneNumber, uid;

  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  bool _autoValidate = false;

  bool _loadingVisible = false;

  String _currentSelectedValue;
  String country_name;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserServices _userServicse = UserServices();

  final TextEditingController _firstName = new TextEditingController();

  final TextEditingController _lastName = new TextEditingController();

  final TextEditingController _country = new TextEditingController();

  final TextEditingController _gender = new TextEditingController();

  var _currencies = ["Male", "Female"];

  void _createUser({String id, String number}) async {
    // User = Current

    final user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      _userServicse.checkUserExist(user.uid).then((value) {
        if (value) {
          print('yes');
          _userServicse.createUser({
            "id": user.uid,
            "number": user.phoneNumber,
            "firstname": _firstName.text,
            "lastname": _lastName.text,
            "gender": _currentSelectedValue,
            "country": _country
          });
        } else {
          print('no');
          _userServicse.createUser({
            "id": user.uid,
            "number": user.phoneNumber,
            "firstname": _firstName.text,
            "lastname": _lastName.text,
            "gender": _currentSelectedValue,
            "country": _country
          });
        }
        print(value);
      });
    } else {
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

  Future<String> getCountryName() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    country_name = first.addressLine;
    print(country_name);
    _country.text = country_name;
    return first.countryName;

    // this will return country name
  }

  Widget country({label, obscureText = false}) {
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
          controller: _country.text.isEmpty ? _country : _country,
          // validator: (String value) {
          //   if (value != _password.text) {
          //     return 'Password Dont Match';
          //   }
          //   return null;
          //   // return Flushbar();
          // },
          obscureText: false,

          // initialValue: country_name ?? '',
          // initialValue: 1 == 1 ? country_name : '_country.text,',
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
      _createUser(id: widget.uid, number: widget.phoneNumber);

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
                  FadeAnimation(
                      1.2,
                      Text(
                        "We need to Get Some Info",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeAnimation(1.2, makeNameF(label: "First Name")),
                  FadeAnimation(1.2, makeNameL(label: "Last Name")),
                  FadeAnimation(1.2, country(label: "Country")),
                  CupertinoButton(
                    color: Colors.accents[5],
                    child: Text('Automatically Get Location'),
                    onPressed: () => getCountryName(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            // labelStyle: ,
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Please select expense',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        isEmpty: _currentSelectedValue == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currentSelectedValue,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _currentSelectedValue = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _currencies.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  )
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
  }
}

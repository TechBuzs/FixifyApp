import 'package:Fixify/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: auth.isloading ? CircularProgressIndicator() : Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/op.png',
                height: 150,)
              ],
            ),
            SizedBox(height: 30,),
            Text('Welcome To Fixify',
            style: TextStyle(
              fontSize: 32,

            ),),
            Text('Get started By Entering your Phone Number'),
            SizedBox(height: 12,),
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '+234 100 0000000'
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            FlatButton(
              child: Text('Verify'),
              onPressed: () => auth.verifyPhoneNumber(context, number.text),
            )

          ],)
        )
      ),
    );
  }
}
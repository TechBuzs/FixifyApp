import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:phone_auth_plugin/phone_auth_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _phoneNumber;
  String _smsCode;
  String _verificationID;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PhoneAuthPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              new Row(
                children: <Widget>[Text('Running on: $_platformVersion\n')],
              ),
              TextField(
                onChanged: (value) {
                  this._phoneNumber = value;
                },
              ),
              RaisedButton(
                onPressed: () async {
                  PhoneAuthPlugin.getOtpForNumber(_phoneNumber);
                },
                child: new Text("Send Code"),
              ),
              TextField(
                onChanged: (value) {
                  this._smsCode = value;
                },
              ),
              RaisedButton(
                onPressed: () async {
                  PhoneAuthPlugin.verifyCode(_smsCode);
                },// e,
                child: new Text("VerifyCode"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
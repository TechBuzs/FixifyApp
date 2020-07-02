import 'package:Fixify/pages/home.dart';
import 'package:Fixify/pages/login.dart';
import 'package:Fixify/pages/onboarding.dart';
import 'package:Fixify/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5),(){
       Provider.of<LoginStore>(context, listen: false).isAlreadyAuthenticated().then((result) {
      if (result) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomePage()), (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) =>  OnBoardingPage()), (Route<dynamic> route) => false);
      }
    });
    });
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffc2e3cd),
      body: Center(
        child: Image.asset('assets/images/icon.png',
        height: 300,),
      ),
    );
  }
}

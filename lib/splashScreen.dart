import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weatherapp/screens/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), ()=>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return Home();
      }))
    );
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(

        child: Center(
          child: Image.asset('assets/splashScreen.png',fit: BoxFit.fill,
            height: size.height,
            width: size.width,),
        ),
      ),
    );
  }
}

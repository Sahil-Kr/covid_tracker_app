import 'dart:async';
import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
           Center(
             child: Container(
                  height: 150,
                  width:  150,
                  child: Image.asset('assets/images/logo.png'),
                ),
           ),
           Text('Corona Tracker', style: fontStyle(null, 25, false),textAlign: TextAlign.center,),

        ],
      ),
    );
  }
}

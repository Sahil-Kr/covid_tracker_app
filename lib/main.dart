import 'package:covid_tracker_app/screens/HomeScreen.dart';
import 'package:covid_tracker_app/screens/SplashScreen.dart';
import 'package:covid_tracker_app/screens/SymptomsPreventionScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Corona Tracker',
      theme: ThemeData(
          primaryColor: Color.fromARGB(255, 249, 125, 161 ),
          //fontFamily: GoogleFonts.spicyRice(fontWeight: FontWeight.bold).toString(),
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new HomeScreen(),
        '/SymptomsPrevention': (BuildContext context) => new SymptomsPreventionScreen(),
      },

      //HomeScreen(),
    );

  }

}


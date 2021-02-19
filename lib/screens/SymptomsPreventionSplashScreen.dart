import 'dart:async';
import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SymptomsPreventionSplashScreen extends StatefulWidget {
  @override
  _SymptomsPreventionSplashScreenState createState() =>
      _SymptomsPreventionSplashScreenState();
}

class _SymptomsPreventionSplashScreenState
    extends State<SymptomsPreventionSplashScreen> {
  var _duration;

  startTime() async {
    _duration = new Duration(seconds: 10);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/SymptomsPrevention');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/gifs/handGif.gif'),
                ),
                Text(
                  'DO THE FIVE',
                  style: fontStyle(null, 40, true)
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(30),
                    //margin: EdgeInsets.only(left:  MediaQuery.of(context).size.width*0.20, right:  MediaQuery.of(context).size.width*0.20),
                    child: Column(

                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'HAND ',
                              style: fontStyle(null, 22, true)
                            ),
                            Text(
                              'Wash them often',
                              style: fontStyle(Colors.black, 22, false),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'ELBOW ',
                              style: fontStyle(null, 22, true)
                            ),
                            Text(
                              'Cough in it',
                              style: fontStyle(null, 22, false),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'FACE ',
                              style: fontStyle(null, 22, true)
                            ),
                            Text(
                              'Dont touch it',
                              style: fontStyle(null, 22, false)
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'SPACE ',
                              style: fontStyle(null, 22, true)
                            ),
                            Text(
                              'Keep safe distance',
                              style: fontStyle(null, 22, false)
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'HOME ',
                              style: fontStyle(null, 22, true)
                            ),
                            Text(
                              'Stay if you can',
                              style: fontStyle(null, 22, false)
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: RaisedButton(
            padding: EdgeInsets.only(top: 5, bottom: 6, left: 16, right: 16),
            color: Color.fromARGB(255, 225, 46, 98),
            child: Text('Skip',
              style: fontStyle(Colors.white, null, false)),
            onPressed: navigationPage,
          ),
        )
      ),
    );
  }
}

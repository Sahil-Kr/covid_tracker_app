import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:flutter/material.dart';

Future startupDialog(BuildContext context, VoidCallback onPressed) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Disclaimer',
          style: fontStyle(null, null, true),
        ),
        content: Text(
            'The data presented in the application may or may not be accurate. '
            'The data used in the application is collected from various sources and the data may subject to copyright. This application collect '
            'data just for informative purposes.\n'
            'The data get updated everyday in between 10:30am - 12:30pm. ',
            style: fontStyle(null, null, false)),
        actions: <Widget>[
          FlatButton(
            child: Text("OK", style: fontStyle(null, null, false)),
            onPressed: onPressed,
            //color: Colors.black12,
            //textColor: Colors.black54,
          )
        ],
      );
    },
  );
}

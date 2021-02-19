import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:flutter/material.dart';


Future showRefreshDialog(BuildContext context, VoidCallback onPressed) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
            'Please check your internet connectivity!',
            style: fontStyle(null, null, false)),
        actions: <Widget>[
          FlatButton(
            child:
            Text("Retry", style: fontStyle(null, null, false)),
            onPressed: onPressed,
            //color: Colors.black12,
            //textColor: Colors.black54,
          )
        ],
      );
    },
  );
}
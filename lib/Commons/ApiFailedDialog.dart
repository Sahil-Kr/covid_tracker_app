import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:flutter/material.dart';


Future showFailedDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 3),(){
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        content: Text(
            'Something wrong occured!\nRetrying...',
            style: fontStyle(null, null, false)),
      );
    },
  );
}
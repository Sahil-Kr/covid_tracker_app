import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:covid_tracker_app/Values/HelpLineNo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class HelplineScreen extends StatelessWidget {
  List<Map<String, String>> helpline = new List();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromARGB(255, 249, 125, 161),
          title: Text('Helpline Number List',
              style: fontStyle(null, null, true)),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
        body: Container(
          //color: Color.fromARGB(255, 26, 26, 29),
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FractionColumnWidth(0.5),
                1: FractionColumnWidth(0.3),
                2: FractionColumnWidth(0.2),
              },
              children: _getHelplineData(),
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _getHelplineData() {
    helpline = HelpLineNo().numbers;
    return(
        helpline.map((data) {
          return TableRow(children: [
            Padding(
              padding: EdgeInsets.only(top: 15, left: 10, bottom: 15),
              child: Text(
                data['State'],
                style: fontStyle(null, 15, true),
              ),
            ),
            Padding(
              padding:EdgeInsets.only(top: 15, left: 10),
              child: Text(
                data['Phone'],
                style: fontStyle(null, 15, false),
              ),
            ),
            IconButton(
              icon: Icon(Icons.phone),
              color: Colors.blue,
              onPressed: () => launch("tel://${data['Phone']}"),
            ),
          ]);
        }).toList()
    );
  }
}

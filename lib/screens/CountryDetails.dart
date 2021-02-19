import 'dart:io';

import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:covid_tracker_app/Commons/TopCard.dart';
import 'package:covid_tracker_app/models/CoronaAreaModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountryDetails extends StatefulWidget {
  final CoronaAreaModel coronaAreaData;
  CountryDetails(this.coronaAreaData);
  @override
  _CountryDetailsState createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
  //CoronaAreaModel areaData = widget.coronaAreaData;
  bool isConnectedToInternet = false;
  final formatter = new NumberFormat("#,##,###", "en_US");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromARGB(255,249, 125, 161 ),
          title: Text('COVID-19 DATA', style: fontStyle(null, null, true)),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
        body: Container(
          color: Color.fromARGB(255,26, 26, 29),

          child: Stack(
            children: <Widget>[
              Center(
                child: isConnectedToInternet?Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _getTopCard(),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(left:10.0, right: 10),
                        children: _getExpandableList(),
                      ),
                    )
                  ],
                ):AlertDialog(
                  content: Text('Please check your internet connectivity!', style: fontStyle(null, null, false)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Retry", style:fontStyle(null,null, true)),
                      onPressed: _checkInternet,
                      color: Colors.black12,
                      textColor: Colors.black54,
                    )
                  ],

                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  List<Widget> _getExpandableList(){
    List<dynamic> states= widget.coronaAreaData.areas;
    double screenWidth = MediaQuery.of(context).size.width*0.816;
    return states.length > 0?
    (states
        .map((data) {
          int activeCases = _getActiveCases(data);
          return Card(
      child: ExpansionTile(
          title: Text(data['displayName'], style: fontStyle(Colors.black87, null, true)),
          subtitle: Text('Total Cases: '+formatter.format(data['totalConfirmed']??0), style: fontStyle(Colors.black54, null, false)),
          trailing: Icon(Icons.keyboard_arrow_down),
          backgroundColor: Color.fromARGB(255, 251, 211, 223),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Active Cases',
                    style: fontStyle(Colors.black54, 15, true)
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        formatter.format(activeCases),
                        style: fontStyle(Colors.black, 15, true)
                      ),
                      Text(_activeDelta(data),
                          style: fontStyle(Colors.black54, 15, false)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Recovered Cases',
                    style: fontStyle(Colors.black54, 15, true)
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${formatter.format(data['totalRecovered']??0)}',
                        style: fontStyle(Colors.black, 15, true)
                      ),
                      Text(' +'
                          '${formatter.format((data['totalRecoveredDelta']??0))}',
                          style: fontStyle(Colors.black54, 15, false)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Fatal Cases',
                    style: fontStyle(Colors.black54, 15, true)
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${formatter.format(data['totalDeaths']??0)}',
                        style: fontStyle(Colors.black, 15, true)
                      ),
                      Text(' +'
                          '${formatter.format(data['totalDeathsDelta']??0)}',
                          style: fontStyle(Colors.black54, 15, false)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Container(
                      height: 6,
                      width: screenWidth*(activeCases/data['totalConfirmed']),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Container(
                      height: 6,
                      width: screenWidth*((data['totalRecovered']??0)/data['totalConfirmed']),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Container(
                      height: 6,
                      width: screenWidth*((data['totalDeaths']??0)/data['totalConfirmed']),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],

         ),
    );})
        .toList())
        : [Card(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Text('Statewise data not available!',style: fontStyle(null, null, false),textAlign: TextAlign.center,),
            ),

    )];
  }

  String _activeDelta(var data){
    int activeDelta = (data['totalConfirmedDelta']??0)-(data['totalRecoveredDelta']??0);
    if (activeDelta<0)
      return ' +0';
    else
      return ' +'+formatter.format(activeDelta);
  }

  int _getActiveCases( var data){
    if(data['totalConfirmed'] == null)
      return 0;
    else {
      if (data['totalRecovered'] == null && data['totalDeaths'] != null)
        return (data['totalConfirmed'] - data['totalDeaths']);
      if (data['totalRecovered'] != null && data['totalDeaths'] == null)
        return (data['totalConfirmed'] - data['totalRecovered']);

      if(data['totalRecovered'] == null && data['totalDeaths'] == null)
        return data['totalConfirmed'];

      if(data['totalRecovered'] != null && data['totalDeaths'] != null)
        return (data['totalConfirmed'] - data['totalRecovered'] - data['totalDeaths']);
    }
    return 0;
  }

  Widget _getTopCard() {
    int _index;
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 0),
      child: SizedBox(
        height: 190, // card height
        child: PageView.builder(
          itemCount: 1,
          controller: PageController(viewportFraction: 0.95),
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
                scale: i == _index ? 1 : 1,
                child: TopCard().card(widget.coronaAreaData,context));
          },
        ),
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    _checkInternet();
  }

  void _checkInternet() async{
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnectedToInternet = true;
        });
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        isConnectedToInternet = false;
      });
    }
  }

}

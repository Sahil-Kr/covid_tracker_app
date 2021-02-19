import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:covid_tracker_app/models/CoronaAreaModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopCard {
  CoronaAreaModel areaData1 = new CoronaAreaModel();
  final formatter = new NumberFormat("#,##,###", "en_US");

  Widget card(CoronaAreaModel areaData, BuildContext context) {
    areaData1 = areaData;
    int activeCases = _getActiveCases();
    double screenWidth = MediaQuery.of(context).size.width*0.81;
    return Stack(
      children: <Widget>[

        Card(
          color: Color.fromARGB(255, 251, 211, 223),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          //margin: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              //width: MediaQuery.of(context).size.width*0.91,
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    '${areaData.displayName.toUpperCase()}',
                    style: fontStyle(Colors.black, 20, true),
                  ),
                  Text(
                    'Total Cases: ${formatter.format(areaData.totalConfirmed ?? 0)}',
                    style: fontStyle(Colors.black45, 12, true),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '⬤ ',
                                  style:
                                      TextStyle(color: Colors.amber),
                                ),
                                Text(
                                  'Active Cases',
                                  style: fontStyle(Colors.black54, 15, true),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  formatter.format(activeCases),
                                  style: fontStyle(Colors.black, 15, true),
                                ),
                                Text(_activeDelta(areaData),
                                  style: fontStyle(Colors.black45, 15, false),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '⬤ ',
                                  style:
                                  TextStyle(color: Colors.green),
                                ),
                                Text(
                                  'Recovered Cases',
                                  style: fontStyle(Colors.black54, 15, true),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '${formatter.format(areaData.totalRecovered ?? 0)}',
                                  style: fontStyle(Colors.black, 15, true),
                                ),
                                Text(' +'
                                  '${formatter.format(areaData.recoveredDelta ?? 0)}',
                                  style: fontStyle(Colors.black45, 15, false),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '⬤ ',
                                  style:
                                  TextStyle(color: Colors.redAccent),
                                ),
                                Text(
                                  'Fatal Cases',
                                  style: fontStyle(Colors.black54, 15, true),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '${formatter.format(areaData.totalDeaths ?? 0)}',
                                  style: fontStyle(Colors.black, 15, true),
                                ),
                                Text(' +'
                                  '${formatter.format(areaData.deathDelta ?? 0)}',
                                  style: fontStyle(Colors.black45, 15, false),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Container(
                              height: 8,
                              width: screenWidth*(activeCases/areaData1.totalConfirmed),
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
                              height: 8,
                              width: screenWidth*((areaData1.totalRecovered??0)/areaData1.totalConfirmed),
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
                              height: 8,
                              width: screenWidth*((areaData1.totalDeaths??0)/areaData1.totalConfirmed),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

  int _getActiveCases() {
    if (areaData1.totalConfirmed == null)
      return 0;
    else {
      if (areaData1.totalRecovered == null && areaData1.totalDeaths != null)
        return (areaData1.totalConfirmed - areaData1.totalDeaths);
      if (areaData1.totalRecovered != null && areaData1.totalDeaths == null)
        return (areaData1.totalConfirmed - areaData1.totalRecovered);

      if (areaData1.totalRecovered == null && areaData1.totalDeaths == null)
        return areaData1.totalConfirmed;

      if (areaData1.totalRecovered != null && areaData1.totalDeaths != null)
        return (areaData1.totalConfirmed -
            areaData1.totalRecovered -
            areaData1.totalDeaths);
    }
    return 0;
  }

  String _activeDelta(CoronaAreaModel areaData){
    int activeDelta = (areaData.confirmedDelta??0)-(areaData.recoveredDelta??0);
    if (activeDelta<0)
      return ' +0';
    else
      return ' +'+formatter.format(activeDelta);
  }
}

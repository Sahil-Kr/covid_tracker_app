import 'dart:convert';

import 'package:covid_tracker_app/models/CoronaDataListModel.dart';
import 'package:covid_tracker_app/models/CoronaDataModel.dart';

class CoronaDataMapper{
  CoronaDataListModel dataMapper(String jsonString){
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    print(jsonMap);
    CoronaDataListModel dataModel = new CoronaDataListModel();
    CoronaDataModel model = new CoronaDataModel();
    model.id = jsonMap['id'];
    model.displayName = jsonMap['displayName'];
    model.totalConfirmed = jsonMap['totalConfirmed'];
    model.totalRecovered = jsonMap['totalRecovered'];
    model.totalDeaths = jsonMap['totalDeaths'];
    model.areas = jsonMap['areas'];
    model.confirmedDelta = jsonMap['totalConfirmedDelta'];
    model.recoveredDelta = jsonMap['totalRecoveredDelta'];
    model.deathDelta = jsonMap['totalDeathsDelta'];
    model.dateTime = jsonMap['lastUpdated'];
    dataModel.dataList.add(model);
    return dataModel;
  }
}
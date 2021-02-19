import 'dart:convert';

import 'package:covid_tracker_app/models/LineChartDataModel.dart';
import 'package:covid_tracker_app/models/LineChartModel.dart';

class LineChartDataMapper{
  Map dataMapper(String jsonString){
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    print(jsonMap);
    Map<String, dynamic> model = new Map();
    model = jsonMap;
    return model;
  }
}
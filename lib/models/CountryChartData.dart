import 'package:covid_tracker_app/models/LineChartModel.dart';

class CountryChartData{
  String _id ='';
  String _displayName ='';
  List _chartData = new List();

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get displayName => _displayName;

  set displayName(String value) {
    _displayName = value;
  }

  List get chartData => _chartData;

  set chartData(List value) {
    _chartData = value;
  }
}
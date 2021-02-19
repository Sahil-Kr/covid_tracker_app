import 'package:covid_tracker_app/models/LineChartModel.dart';

class LineChartDataModel{
  List<LineChartModel> _dataList = new List();
// ignore: unnecessary_getters_setters
  List<LineChartModel> get dataList => _dataList;
// ignore: unnecessary_getters_setters
  set dataList(List<LineChartModel> value) {
    _dataList = value;
  }
}
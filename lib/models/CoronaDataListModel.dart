import 'package:covid_tracker_app/models/CoronaDataModel.dart';

class CoronaDataListModel{
  List<CoronaDataModel> _dataList = new List();
// ignore: unnecessary_getters_setters
  List<CoronaDataModel> get dataList => _dataList;
// ignore: unnecessary_getters_setters
  set dataList(List<CoronaDataModel> value) {
    _dataList = value;
  }
}
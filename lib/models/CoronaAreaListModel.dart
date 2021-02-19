import 'package:covid_tracker_app/models/CoronaAreaModel.dart';

class CoronaAreaListModel{
  List<CoronaAreaModel> _areaList = new List();

  // ignore: unnecessary_getters_setters
  List<CoronaAreaModel> get areaList => _areaList;

  // ignore: unnecessary_getters_setters
  set areaList(List<CoronaAreaModel> value) {
    _areaList = value;
  }
}
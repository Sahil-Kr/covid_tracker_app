

class CoronaDataModel{
  String _id='';
  String _displayName = '';
  // ignore: unnecessary_getters_setters
  String get id => _id;
// ignore: unnecessary_getters_setters
  set id(String value) {
    _id = value;
  }



  List<dynamic> _areas = new List() ;
  int _totalConfirmed=0;
  int _totalDeaths=0;
  int _totalRecovered=0;
  int _confirmedDelta=0;
  int _recoveredDelta=0;
  int _deathDelta=0;
  String _dateTime = '';

  String get dateTime => _dateTime;

  set dateTime(String value) {
    _dateTime = value;
  }

  int get confirmedDelta => _confirmedDelta;

  set confirmedDelta(int value) {
    _confirmedDelta = value;
  } // ignore: unnecessary_getters_setters
  String get displayName => _displayName;
// ignore: unnecessary_getters_setters
  set displayName(String value) {
    _displayName = value;
  }
// ignore: unnecessary_getters_setters
  List<dynamic> get areas => _areas;
// ignore: unnecessary_getters_setters
  set areas(List<dynamic> value) {
    _areas = value;
  }
// ignore: unnecessary_getters_setters
  int get totalConfirmed => _totalConfirmed;
// ignore: unnecessary_getters_setters
  set totalConfirmed(int value) {
    _totalConfirmed = value;
  }

// ignore: unnecessary_getters_setters
  int get totalDeaths => _totalDeaths;
// ignore: unnecessary_getters_setters
  set totalDeaths(int value) {
    _totalDeaths = value;
  }
// ignore: unnecessary_getters_setters
  int get totalRecovered => _totalRecovered;
// ignore: unnecessary_getters_setters
  set totalRecovered(int value) {
    _totalRecovered = value;
  }

  int get recoveredDelta => _recoveredDelta;

  set recoveredDelta(int value) {
    _recoveredDelta = value;
  }

  int get deathDelta => _deathDelta;

  set deathDelta(int value) {
    _deathDelta = value;
  }


}
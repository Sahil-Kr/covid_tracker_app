class LineChartModel{
  String _confirmed= '';
  String _date='';
  String _recovered='';
  String _fatal='';

  String get confirmed => _confirmed;

  set confirmed(String value) {
    _confirmed = value;
  }

  String get date => _date;

  String get fatal => _fatal;

  set fatal(String value) {
    _fatal = value;
  }

  String get recovered => _recovered;

  set recovered(String value) {
    _recovered = value;
  }

  set date(String value) {
    _date = value;
  }
}
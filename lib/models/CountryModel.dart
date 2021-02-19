class CountryModel{
  String _id = '';
  String _displayName= '';

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get displayName => _displayName;

  set displayName(String value) {
    _displayName = value;
  }
}
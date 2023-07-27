class LocalizationSelectionModel {
  String _languagename = "";
  String get languagename => _languagename;
  set languagename(String value) {
    _languagename = value;
  }

  String _locale = "";
  String get locale => _locale;
  set locale(String value) {
    _locale = value;
  }

  String _description = "";
  String get description => _description;
  set description(String value) {
    _description = value;
  }

  bool _status = false;
  bool get status => _status;
  set status(bool value) {
    _status = value;
  }

  int _id = 0;
  int get id => _id;
  set id(int value) {
    _id = value;
  }

  String _countryflag = "";
  String get countryflag => _countryflag;
  set countryflag(String value) {
    _countryflag = value;
  }

  String _jsonfile = "";
  String get jsonfile => _jsonfile;
  set jsonfile(String value) {
    _jsonfile = value;
  }
}

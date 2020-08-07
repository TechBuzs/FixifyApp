class Destination {
  String _number;
  String _street;
  String _city;
  String _local;
  String _zip;
  double _latitude;
  double _longitude;
  Destination();
  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  String get cep => _zip;

  set cep(String value) {
    _zip = value;
  }

  String get bairro => _local;

  set bairro(String value) {
    _local = value;
  }

  String get cidade => _city;

  set cidade(String value) {
    _city = value;
  }

  String get numero => _number;

  set numero(String value) {
    _number = value;
  }

  String get rua => _street;

  set rua(String value) {
    _street = value;
  }
}

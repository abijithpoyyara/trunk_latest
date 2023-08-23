class Connections {
  static final Connections _instance = Connections._creator();

  Connections._creator();

  factory Connections() => _instance;


  String _applicationName = "RedstarMobileDev";
  String _serverIp = "139.99.123.222";

   String generateUri() {
    return generateWebUrl() + "rest/controller/";
  }

  String generateWebUrl() {
    return "http://" + _serverIp + "/" + _applicationName + "/";
  }

  get applicationName => _applicationName;
}

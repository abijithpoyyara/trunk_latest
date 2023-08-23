class Settings {
  Settings._();

  static String _versionName = "1.1.43";

  static void setVersion(String version) => _versionName = version;

  static String getVersion() => _versionName;

  static initVersion() {}
}

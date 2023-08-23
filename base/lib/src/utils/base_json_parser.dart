class BaseJsonParser {
  static dynamic goodValue(Map<String, dynamic> json, String key) {
    try {
      return json.containsKey(key) && json[key] != null ? json[key] : null;
    } catch (e) {
      print("error in parser $key : ${e.toString()}");
    }
    return null;
  }

  static double goodDouble(Map<String, dynamic> json, String key) {
    try {
      return json.containsKey(key) && json[key] != null
          ? double.parse(json[key].toString())
          : null;
    } catch (e) {
      print("error in parser $key : ${e.toString()}");
    }
    return null;
  }

  static int goodInt(Map<String, dynamic> json, String key) {
    try {
      return json.containsKey(key) && json[key] != null
          ? int.parse(json[key].toString())
          : null;
    } catch (e) {
      print("error in parser $key : ${e.toString()}");
    }
    return null;
  }

  static int goodHexInt(Map<String, dynamic> json, String key) {
    try {
      return json.containsKey(key) && json[key] != null
          ? int.parse(json[key].toString().replaceAll('#', '0x'))
          : null;
    } catch (e) {
      print("error in parser $key : ${e.toString()}");
    }
    return null;
  }

  static int goodHex(String value) {
    try {
      return int.parse(value.replaceAll('#', '0x'));
    } catch (e) {
      print("error in parser : ${e.toString()}");
    }
    return null;
  }

  static String goodString(Map<String, dynamic> json, String key) {
    try {
      return json.containsKey(key) && json[key] != null
          ? json[key].toString()
          : null;
    } catch (e) {
      print("error in parser $key : ${e.toString()}");
    }
    return null;
  }

  static bool goodBoolean(Map<String, dynamic> json, String key) {
    try {
      return json.containsKey(key) && json[key] != null
          ? json[key] as bool
          : false;
    } on TypeError {
      return json[key] is int
          ? json[key] > 0
          : json[key] == "true" || json[key] == "Y" || json[key] == "y";
    } catch (e) {
      print("error in parser $key : ${e.toString()}");
      return false;
    }
  }

  static List goodList(Map<String, dynamic> json, String key) {
    try {
      return json.containsKey(key) && json[key] != null
          ? json[key] as List
          : [];
    } catch (e) {
      print("error in parser $key : ${e.toString()}");
    }
    return [];
  }
}

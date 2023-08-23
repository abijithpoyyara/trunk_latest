import 'package:flutter/cupertino.dart';

// Utility class helps in generating xml for passing along with http requests.
class XMLBuilder {
  String tag;
  List<XMLElement> elements;

  XMLBuilder({@required this.tag, elements}) : this.elements = elements ?? [];

  /// add one more [XMLElement] to existing xml.
  XMLBuilder addElement({@required String key, @required String value}) {
    elements.add(XMLElement(value: value, key: key));
    return this;
  }

  /// return generated xml as [String]
  String buildElement({bool appendFlag = true}) {
    String _flag = "RequestFrom";
    String _flagVal = "Mobile";
    String _appType = "apptype";
    String _appTypeValue = "USERAPP";

    String xml = "";
    xml = "<" + tag + "";
    elements.forEach(
        (element) => xml += " " + element.key + " = \"" + element.value + "\"");
    if ((tag == "Report") || (tag == "List")) if (appendFlag)
      xml += " " + _flag + " = \"" + _flagVal + "\"";
    if (appendFlag) xml += " " + _appType + " = \"" + _appTypeValue + "\"";
    xml += "> </" + tag + ">";
    return xml;
  }
}

class XMLElement {
  final String value;
  final String key;

  XMLElement({@required this.value, @required this.key});
}

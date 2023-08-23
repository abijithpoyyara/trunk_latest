import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class CustomerLookupModel extends LookupModel {
  CustomerLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<Customer>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new Customer.fromJson(mod));
      });
    } else {
      lookupItems = List<Customer>();
    }
  }
}

class Customer extends LookupItems {
  String code;
  String name;
  String address1;
  String address2;
  String address3;
  String mobile;
  String phone;
  String customertype;
  String customeraddress;
  String analysiscodetypeid;
  String gstno;
  int analysisaccountid;
  int analysiscodeid;
  int id;

  Customer.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    name = BaseJsonParser.goodString(json, "name");
    customertype = BaseJsonParser.goodString(json, "customertype");
    customeraddress = BaseJsonParser.goodString(json, "customeraddress");
    analysiscodetypeid = BaseJsonParser.goodString(json, "analysiscodetypeid");
    gstno = BaseJsonParser.goodString(json, "gstno");
    address1 = BaseJsonParser.goodString(json, "address1");
    address2 = BaseJsonParser.goodString(json, "address2");
    address3 = BaseJsonParser.goodString(json, "address3");
    mobile = BaseJsonParser.goodString(json, "mobile");
    phone = BaseJsonParser.goodString(json, "phone");
    id = BaseJsonParser.goodInt(json, "id");
    analysisaccountid = BaseJsonParser.goodInt(json, "analysisaccountid");
    analysiscodeid = BaseJsonParser.goodInt(json, "analysiscodeid");
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code &&
          name == other.name &&
          customeraddress == other.customeraddress;

  @override
  int get hashCode =>
      code.hashCode ^ name.hashCode ^ customeraddress.hashCode ^ id.hashCode;
}

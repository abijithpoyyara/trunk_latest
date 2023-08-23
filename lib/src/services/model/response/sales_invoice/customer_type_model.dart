import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class CustomerTypeModel extends BaseResponseModel {
  List<CustomerTypes> customerType;

  CustomerTypeModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    customerType = BaseJsonParser.goodList(json, "CustomerTypeList")
        .map((e) => CustomerTypes.fromJson(e))
        .toList();
  }
}

class CustomerTypes {
  String code;
  String description;
  String extra;
  String fieldcodename;
  String tablecode;
  int id;

  CustomerTypes.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    tablecode = BaseJsonParser.goodString(json, "tablecode");
    description = BaseJsonParser.goodString(json, "description");
    extra = BaseJsonParser.goodString(json, "extra");
    fieldcodename = BaseJsonParser.goodString(json, "fieldcodename");
    id = BaseJsonParser.goodInt(json, "id");
  }
}

class CustomerModel extends BaseResponseModel {
  List<CustomerList> customerList;

  CustomerModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    customerList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => CustomerList.fromJson(e))
        .toList();
  }
}

class CustomerList {
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

  CustomerList.fromJson(Map<String, dynamic> json) {
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
      other is CustomerList &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code &&
          name == other.name &&
          customeraddress == other.customeraddress;

  @override
  int get hashCode =>
      code.hashCode ^ name.hashCode ^ customeraddress.hashCode ^ id.hashCode;
}

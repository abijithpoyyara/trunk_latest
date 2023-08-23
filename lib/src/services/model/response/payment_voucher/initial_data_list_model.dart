import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class PaymentVoucherConfigModel extends BaseResponseModel {
  List<BCCModel> paymentFlowTypes;
  List<BCCModel> voucherTypes;
  List<BCCModel> voucherTypesRender;
  List<BCCModel> instrumentTypes;
  List<BSCModel> editableYnObj;
  List<BCCModel> paymentEntryProcessFromObj;
  List<BCCModel> paymentTypes;
  List<BCCModel> paidToTypes;
  List<BSCModel> analysisCodeObj;
  List<BSCModel> analysisCodeTypeObj;
  List<BCCModel> paidToTypeBccId;
  List<BCCModel> settlementTypes;
  List<BCCModel> numberTypes;
  List<BCCModel> sortingTypes;

  PaymentVoucherConfigModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    paymentFlowTypes = BaseJsonParser.goodList(parsedJson, "paymentFlowTypes")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    paidToTypes = BaseJsonParser.goodList(parsedJson, "paidToTypeObj")
        .map((e) => BCCModel.fromJson(e))
        .toList();

    voucherTypes = BaseJsonParser.goodList(parsedJson, "voucherTypes")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    voucherTypesRender =
        BaseJsonParser.goodList(parsedJson, "voucherTypesrender")
            .map((e) => BCCModel.fromJson(e))
            .toList();
    instrumentTypes = BaseJsonParser.goodList(parsedJson, "instrumnetTypes")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    analysisCodeObj = BaseJsonParser.goodList(parsedJson, "analysisCodeObj")
        .map((e) => BSCModel.fromJson(e))
        .toList();
    analysisCodeTypeObj =
        BaseJsonParser.goodList(parsedJson, "analysisCodeTypeObj")
            .map((e) => BSCModel.fromJson(e))
            .toList();
    editableYnObj = BaseJsonParser.goodList(parsedJson, "editableYnObj")
        .map((e) => BSCModel.fromJson(e))
        .toList();
    paidToTypeBccId = BaseJsonParser.goodList(parsedJson, "paidtotypebccid")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    paymentEntryProcessFromObj =
        BaseJsonParser.goodList(parsedJson, "paymentEntryProcessFromObj")
            .map((e) => BCCModel.fromJson(e))
            .toList();
    paymentTypes = BaseJsonParser.goodList(parsedJson, "paymentTypes")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    settlementTypes = BaseJsonParser.goodList(parsedJson, "reqTypeObj")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    numberTypes = BaseJsonParser.goodList(parsedJson, "resultObject")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    sortingTypes = BaseJsonParser.goodList(parsedJson, "resultObject")
        .map((e) => BCCModel.fromJson(e))
        .toList();
  }
}

class CurrencyListModel extends BaseResponseModel {
  List<CurrencyList> currencyList;

  CurrencyListModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    currencyList = BaseJsonParser.goodList(json, "currencyList")
        .map((e) => CurrencyList.fromJson(e))
        .toList();
  }
}

class CurrencyList {
  int id;
  String code;
  String name;

  CurrencyList.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    id = BaseJsonParser.goodInt(json, "id");
    name = BaseJsonParser.goodString(json, "name");
  }
}

class VoucherTypeModel extends BaseResponseModel {
  List<VoucherTypes> voucherTypeList;

  VoucherTypeModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    voucherTypeList = BaseJsonParser.goodList(json, "voucherTypes")
        .map((e) => VoucherTypes.fromJson(e))
        .toList();
  }
}

class VoucherTypes {
  int bankaccountid;
  int bookaccountid;
  int currencyid;
  int rightsbccid;
  int typebccid;
  String bookaccountname;
  String currencycode;
  String description;
  String code;
  String effectonbookaccount;
  String effetonbookac;
  String typebcccode;

  VoucherTypes.fromJson(Map<String, dynamic> json) {
    bankaccountid = BaseJsonParser.goodInt(json, "bankaccountid");
    bookaccountid = BaseJsonParser.goodInt(json, "bookaccountid");
    currencyid = BaseJsonParser.goodInt(json, "currencyid");
    rightsbccid = BaseJsonParser.goodInt(json, "rightsbccid");
    typebccid = BaseJsonParser.goodInt(json, "typebccid");
    code = BaseJsonParser.goodString(json, "code");
    bookaccountname = BaseJsonParser.goodString(json, "bookaccountname");
    currencycode = BaseJsonParser.goodString(json, "currencycode");
    effectonbookaccount =
        BaseJsonParser.goodString(json, "effectonbookaccount");
    effetonbookac = BaseJsonParser.goodString(json, "effetonbookac");
    description = BaseJsonParser.goodString(json, "description");
    typebcccode = BaseJsonParser.goodString(json, "typebcccode");
  }
}

class VoucherTypesRenderModel extends BaseResponseModel {
  List<VoucherTypesRender> voucherTypeRenderList;

  VoucherTypesRenderModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    voucherTypeRenderList = BaseJsonParser.goodList(json, "voucherTypesrender")
        .map((e) => VoucherTypesRender.fromJson(e))
        .toList();
  }
}

class VoucherTypesRender {
  int bankaccountid;
  int bookaccountid;
  int currencyid;
  int rightsbccid;
  int typebccid;
  int vouchercodeid;
  String bookaccountname;
  String currencycode;
  String description;
  String code;
  String effectonbookaccount;
  String effetonbookac;
  String typebcccode;

  VoucherTypesRender.fromJson(Map<String, dynamic> json) {
    vouchercodeid = BaseJsonParser.goodInt(json, "vouchercodeid");
    bookaccountid = BaseJsonParser.goodInt(json, "bookaccountid");
    currencyid = BaseJsonParser.goodInt(json, "currencyid");
    rightsbccid = BaseJsonParser.goodInt(json, "rightsbccid");
    rightsbccid = BaseJsonParser.goodInt(json, "rightsbccid");
    typebccid = BaseJsonParser.goodInt(json, "typebccid");
    code = BaseJsonParser.goodString(json, "code");
    bookaccountname = BaseJsonParser.goodString(json, "bookaccountname");
    currencycode = BaseJsonParser.goodString(json, "currencycode");
    effectonbookaccount =
        BaseJsonParser.goodString(json, "effectonbookaccount");
    effetonbookac = BaseJsonParser.goodString(json, "effetonbookac");
    description = BaseJsonParser.goodString(json, "description");
    typebcccode = BaseJsonParser.goodString(json, "typebcccode");
  }
}

// class InstrumentTypes {
//   int id;
//   String code;
//   String name;
//   String reftype;
//
//   InstrumentTypes.fromJson(Map<String, dynamic> json) {
//     code = BaseJsonParser.goodString(json, "code");
//     id = BaseJsonParser.goodInt(json, "id");
//     name = BaseJsonParser.goodString(json, "name");
//     reftype = BaseJsonParser.goodString(json, "reftype");
//   }
// }

class VoucherCodeModel extends BaseResponseModel {
  List<VoucherCode> voucherCodeList;

  VoucherCodeModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    voucherCodeList = BaseJsonParser.goodList(json, "vchCodeList")
        .map((e) => VoucherCode.fromJson(e))
        .toList();
  }
}

class VoucherCode {
  int bankaccountid;
  int bookaccountid;
  int currencyid;
  int rightsbccid;
  int typebccid;
  int vouchercodeid;
  int branchid;
  int companyid;
  String bookaccountname;
  String currencycode;
  String description;
  String code;
  String effectonbookaccount;
  String effetonbookac;
  String typebcccode;

  VoucherCode.fromJson(Map<String, dynamic> json) {
    vouchercodeid = BaseJsonParser.goodInt(json, "vouchercodeid");
    bookaccountid = BaseJsonParser.goodInt(json, "bookaccountid");
    branchid = BaseJsonParser.goodInt(json, "branchid");
    companyid = BaseJsonParser.goodInt(json, "companyid");
    currencyid = BaseJsonParser.goodInt(json, "currencyid");
    rightsbccid = BaseJsonParser.goodInt(json, "rightsbccid");
    rightsbccid = BaseJsonParser.goodInt(json, "rightsbccid");
    typebccid = BaseJsonParser.goodInt(json, "typebccid");
    code = BaseJsonParser.goodString(json, "code");
    bookaccountname = BaseJsonParser.goodString(json, "bookaccountname");
    currencycode = BaseJsonParser.goodString(json, "currencycode");
    effectonbookaccount =
        BaseJsonParser.goodString(json, "effectonbookaccount");
    effetonbookac = BaseJsonParser.goodString(json, "effetonbookac");
    description = BaseJsonParser.goodString(json, "description");
    typebcccode = BaseJsonParser.goodString(json, "typebcccode");
  }
}

class PaidToTypeModel extends BaseResponseModel {
  List<PaidToTypes> paidToTypeList;

  PaidToTypeModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    paidToTypeList = BaseJsonParser.goodList(json, "paidToTypeObj")
        .map((e) => PaidToTypes.fromJson(e))
        .toList();
  }
}

class PaidToTypes {
  int id;
  int accountid;
  int tableid;
  String code;
  String description;
  String accountcode;
  String accountname;

  PaidToTypes.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    id = BaseJsonParser.goodInt(json, "id");
    accountid = BaseJsonParser.goodInt(json, "accountid");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    description = BaseJsonParser.goodString(json, "description");
    accountcode = BaseJsonParser.goodString(json, "accountcode");
    accountname = BaseJsonParser.goodString(json, "accountname");
  }
}

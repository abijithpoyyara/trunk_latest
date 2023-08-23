import 'package:redstars/src/services/model/response/lookups/customer_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/bact_items.dart';
import 'package:redstars/src/services/model/response/sales_invoice/customer_type_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/item_cost_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';

import '../../../../../utility.dart';

class SalesInvoiceModel {
  String fsno;
  String remarks;
  String refInvoiceNo;
  Customer customer;
  CustomersList customersList;
  BatchList batchList;

  DateTime refDate;
  CustomerTypes customerTypes;
  SalesmanObjects salesmanObjects;
  StockLocation despatchFrom;
  CostOverviewModel costOverviewModel;
  SaleOrderTaxList taxList;
  SaleOrderRateList rateList;
  SaleOrderDiscountList discountList;
  MrpDetails mrpDetails;
  ProductModel productModel;
  String value;

  factory SalesInvoiceModel() {
    return SalesInvoiceModel._();
  }

  SalesInvoiceModel._();

  SalesInvoiceModel.fromJson(Map<String, dynamic> json) {
    print(json);
    fsno = BaseJsonParser.goodString(json, "fsno");
    remarks = BaseJsonParser.goodString(json, "remarks");
    refInvoiceNo = BaseJsonParser.goodString(json, "refInvoiceNo");
    value = BaseJsonParser.goodString(json, "value");
    refDate = json["refDate"];
    customerTypes = json["customerTypes"];
    salesmanObjects = json["salesmanObjects"];
    despatchFrom = json["despatchFrom"];
    customer = json["customer"];
    costOverviewModel = json["costOverviewModel"];
    mrpDetails = json["mrpDetails"];
    rateList = json["rateList"];
    taxList = json["taxList"];
    discountList = json["discountList"];
    productModel = json["productModel"];
    customersList = json["customersList"];
    batchList = json["batchList"];

    // fsno = json["fsno"];
    // remarks = json["remarks"];
    // refDate = json["refDate"];
    // refInvoiceNo = json["refInvoiceNo"];
    // customerTypes = json["customerTypes"];
    // salesmanObjects = json["salesmanObjects"];
    // despatchFrom = json["despatchFrom"];
    // customer = json["customer"];
    // costOverviewModel = json["costOverviewModel"];
    // mrpDetails = json["mrpDetails"];
    // rateList = json["rateList"];
    // taxList = json["taxList"];
    // discountList = json["discountList"];
    // productModel = json["productModel"];
    // customersList = json["customersList"];
  }

  Map<String, dynamic> asMap() {
    Map<String, dynamic> kMap = Map();
    kMap['fsno'] = fsno;
    kMap['remarks'] = remarks;
    kMap['refDate'] = refDate;
    kMap['refInvoiceNo'] = refInvoiceNo;
    kMap['customerTypes'] = customerTypes;
    kMap['salesmanObjects'] = salesmanObjects;
    kMap['despatchFrom'] = despatchFrom;
    kMap['customer'] = customer;
    kMap['costOverviewModel'] = costOverviewModel;
    kMap['mrpDetails'] = mrpDetails;
    kMap['rateList'] = rateList;
    kMap['value'] = value;
    kMap['taxList'] = taxList;
    kMap['discountList'] = discountList;
    kMap['productModel'] = productModel;
    kMap['customersList'] = customersList;
    kMap['batchList'] = batchList;
    return kMap;
  }
}

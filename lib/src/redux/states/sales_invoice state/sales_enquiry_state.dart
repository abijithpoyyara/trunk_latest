import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/customer_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/bact_items.dart';
import 'package:redstars/src/services/model/response/sales_invoice/cart_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/customer_type_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/item_cost_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/model/currecny_exchange_model.dart';

@immutable
class SaleInvoiceState extends BaseState {
  final List<LocationModel> branches;
  final List<CartItemModel> cartItems;
  final LocationModel selectedBranch;
  final List<BCCModel> statuses;
  final bool enquirySaved;
  final BSCModel isQtyUpdatable;
  final String salesmanName;

  final Customer cusLookUp;
  final CustomersList customers;
  final List<CurrencyExchange> currencyEx;
  //final List<BatchList> batchItem;
  // final BatchList selectedBatch;
  final List<CostItem> costItem;
  final CartItemModel cartItem;

  final List<CustomerTypes> customerTypes;
  final List<SalesmanObjects> salesman;
  final List<StockLocation> despatchFrom;
  final CostOverviewModel costDetails;
  final List<CustomerList> customer;

  final BSCModel analysisCode;
  final BSCModel analysisTableCode;
  final List<CustomersList> customersList;
  final CustomerTypes selectedTypes;

  SaleInvoiceState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    String filePath,
    this.salesmanName,
    this.despatchFrom,
    this.cartItem,
    this.customers,
    this.selectedTypes,
    this.customerTypes,
    this.customersList,
    this.costDetails,
    this.costItem,
    this.customer,
    this.analysisTableCode,
    this.analysisCode,
    this.currencyEx,
    this.salesman,
    // this.batchItem,
    //  this.selectedBatch,
    this.cusLookUp,
    this.selectedBranch,
    this.branches,
    this.cartItems,
    this.statuses,
    this.enquirySaved,
    this.isQtyUpdatable,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
          filePath: filePath,
        );

  SaleInvoiceState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    String filePath,
    List<LocationModel> branches,
    List<CartItemModel> cartItems,
    LocationModel selectedBranch,
    List<BCCModel> statuses,
    bool enquirySaved,
    BSCModel isQtyUpdatable,
    CartItemModel cartItem,
    Customer cusLookUp,
    CustomersList customers,
    List<CurrencyExchange> currencyEx,
    // List<BatchList> batchItem,
    // BatchList selectedBatch,
    List<CostItem> costItem,
    List<CustomerTypes> customerTypes,
    List<SalesmanObjects> salesman,
    List<StockLocation> despatchFrom,
    CostOverviewModel costDetails,
    List<CustomerList> customer,
    BSCModel analysisCode,
    BSCModel analysisTableCode,
    List<CustomersList> customersList,
    CustomerTypes selectedTypes,
    String salesmanName,
  }) {
    return SaleInvoiceState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      filePath: filePath ?? this.filePath,
      branches: branches ?? this.branches,
      cartItems: cartItems ?? this.cartItems,
      salesmanName: salesmanName ?? this.salesmanName,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      statuses: statuses ?? this.statuses,
      enquirySaved: enquirySaved ?? this.enquirySaved,
      isQtyUpdatable: isQtyUpdatable ?? this.isQtyUpdatable,
      // batchItem: batchItem ?? this.batchItem,
      costItem: costItem ?? this.costItem,
      cartItem: cartItem ?? this.cartItem,
      currencyEx: currencyEx ?? this.currencyEx,
      analysisCode: analysisCode ?? this.analysisCode,
      analysisTableCode: analysisTableCode ?? this.analysisTableCode,
      customerTypes: customerTypes ?? this.customerTypes,
      costDetails: costDetails ?? this.costDetails,
      salesman: salesman ?? this.salesman,
      despatchFrom: despatchFrom ?? this.despatchFrom,
      customers: customers ?? this.customers,
      customer: customer ?? this.customer,
      customersList: customersList ?? this.customersList,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      //  selectedBatch: selectedBatch ?? this.selectedBatch,
      cusLookUp: cusLookUp ?? this.cusLookUp,
    );
  }

  factory SaleInvoiceState.initial() {
    return SaleInvoiceState(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      filePath: "",
      isQtyUpdatable: null,
      branches: [],
      cartItems: [],
      selectedBranch: null,
      cartItem: null,
      statuses: [],
      enquirySaved: false,
      costDetails: null,
      customerTypes: List(),
      despatchFrom: List(),
      salesman: List(),
      customersList: List(),
      selectedTypes: null,
      cusLookUp: null,
      customers: null,
      customer: List(),
      analysisTableCode: null,
      analysisCode: null,
      costItem: List(),
      // selectedBatch: null,
      // batchItem: List(),
      currencyEx: List(),
    );
  }
}

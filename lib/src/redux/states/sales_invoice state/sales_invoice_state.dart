import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
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
class SIState extends BaseState {
  final List<LocationModel> branches;
  final List<CartItemModel> cartItems;
  final LocationModel selectedBranch;
  final List<BCCModel> statuses;
  final bool enquirySaved;
  final BSCModel isQtyUpdatable;

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
  SIState(
      {LoadingStatus loadingStatus,
      String loadingError,
      String loadingMessage,
      String filePath,
      this.cartItems,
      this.cartItem,
      this.selectedTypes,
      this.analysisTableCode,
      this.customer,
      this.costDetails,
      this.costItem,
      this.cusLookUp,
      this.customers,
      this.branches,
      this.salesman,
      this.currencyEx,
      this.analysisCode,
      this.customersList,
      this.customerTypes,
      this.despatchFrom,
      this.selectedBranch,
      this.statuses,
      this.enquirySaved,
      this.isQtyUpdatable})
      : super(
          loadingStatus: loadingStatus,
          loadingError: loadingError,
          loadingMessage: loadingMessage,
          filePath: filePath,
        );

  SIState copyWith({
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
  }) {
    return SIState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingError: loadingError ?? this.loadingError,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      salesman: salesman ?? this.salesman,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      statuses: statuses ?? this.statuses,
      cartItems: cartItems ?? this.cartItems,
      customersList: customersList ?? this.customersList,
      cusLookUp: cusLookUp ?? this.cusLookUp,
      customerTypes: customerTypes ?? this.customerTypes,
      customer: customer ?? this.customer,
      branches: branches ?? this.branches,
      costDetails: costDetails ?? this.costDetails,
      costItem: costItem ?? this.costItem,
      analysisCode: analysisCode ?? this.analysisCode,
      analysisTableCode: analysisTableCode ?? this.analysisTableCode,
      despatchFrom: despatchFrom ?? this.despatchFrom,
      enquirySaved: enquirySaved ?? this.enquirySaved,
      currencyEx: currencyEx ?? this.currencyEx,
      isQtyUpdatable: isQtyUpdatable ?? this.isQtyUpdatable,
      filePath: filePath ?? this.filePath,
    );
  }

  factory SIState.initial() {
    return SIState(
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

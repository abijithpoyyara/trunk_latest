import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/customer_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/bact_items.dart';
import 'package:redstars/src/services/model/response/sales_invoice/cart_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/customer_type_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/item_cost_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_invoice_detail_list.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_invoice_view_list_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/model/currecny_exchange_model.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/model/sales_invoice_model.dart';

@immutable
class SalesInvoiceState extends BaseState {
  final List<ProductModel> enquiryItems;
  final int eorId;
  final int sorId;
  final int totalRecords;
  final int start;

  final String searchText;
  final String salesmanName;

  final double scrollPosition;
  final List<StockLocation> despacthFrom;
  final List<CustomerTypes> customerTypes;
  final List<SalesmanObjects> salesman;
  final SalesInvoiceModel model;
  final List<CustomersList> customersList;
  final CustomerTypes selectedTypes;
  final List<UomTypes> uomsList;

  final List<LocationModel> branches;
  final List<CartItemModel> cartItems;
  final LocationModel selectedBranch;
  final List<BCCModel> statuses;
  final bool enquirySaved;
  final BSCModel isQtyUpdatable;

  final Customer cusLookUp;
  final CustomersList customers;
  final List<CurrencyExchange> currencyEx;
  final UomTypes uom;

  //final List<BatchList> batchItem;
  // final BatchList selectedBatch;
  final CartItemModel cartItem;
  final List<CostItem> costItem;

  final List<StockLocation> despatchFrom;
  final CostOverviewModel costDetails;
  final List<CustomerList> customer;

  final BSCModel analysisCode;
  final BSCModel analysisTableCode;
  final PVFilterModel salesFilter;
  final List<SalesInvoiceSavedViewList> salesInvoicelist;
  final SalesInvoiceViewListModel salesModel;
  final List<SalesInvoiceDetailList> salesInvoiceDtlList;
  final List<BCCModel> currency;
//  final List<BCCModel>

  SalesInvoiceState(
      {LoadingStatus loadingStatus,
      String loadingError,
      String loadingMessage,
      String filePath,
      this.uomsList,
      this.uom,
      this.salesmanName,
      this.salesModel,
      this.salesFilter,
      this.salesInvoicelist,
      this.cartItem,
      this.enquiryItems,
      this.eorId,
      this.sorId,
      this.totalRecords,
      this.start,
      this.searchText,
      this.scrollPosition,
      this.customerTypes,
      this.despacthFrom,
      this.salesman,
      // this.batchList,
      this.currency,
      this.model,
      this.customersList,
      this.selectedTypes,
      this.cartItems,
      // this.cartItem,
      // this.selectedTypes,
      this.analysisTableCode,
      this.customer,
      this.costDetails,
      this.costItem,
      this.cusLookUp,
      this.customers,
      this.branches,
      //this.salesman,
      this.currencyEx,
      this.analysisCode,
      // this.customersList,
      // this.customerTypes,
      this.despatchFrom,
      this.selectedBranch,
      this.statuses,
      this.enquirySaved,
      this.salesInvoiceDtlList,
      this.isQtyUpdatable})
      : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
          filePath: filePath,
        );

  SalesInvoiceState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    String filePath,
    List<ProductModel> enquiryItems,
    int eorId,
    int sorId,
    int totalRecords,
    int start,
    String searchText,
    double scrollPosition,
    bool onSearch = false,
    List<CustomerTypes> customerTypes,
    List<SalesmanObjects> salesman,
    CartItemModel cartItem,
    //  List<BatchList> batchList,
    List<StockLocation> despacthFrom,
    SalesInvoiceModel model,
    PVFilterModel salesFilter,
    List<CustomersList> customersList,
    CustomerTypes selectedTypes,
    List<LocationModel> branches,
    List<CartItemModel> cartItems,
    LocationModel selectedBranch,
    List<BCCModel> statuses,
    bool enquirySaved,
    String salesmanName,
    BSCModel isQtyUpdatable,
    Customer cusLookUp,
    CustomersList customers,
    List<CurrencyExchange> currencyEx,
    // List<BatchList> batchItem,
    // BatchList selectedBatch,
    List<CostItem> costItem,
    List<StockLocation> despatchFrom,
    CostOverviewModel costDetails,
    List<CustomerList> customer,
    BSCModel analysisCode,
    BSCModel analysisTableCode,
    List<SalesInvoiceSavedViewList> salesInvoicelist,
    SalesInvoiceViewListModel salesModel,
    List<SalesInvoiceDetailList> salesInvoiceDtlList,
    UomTypes uom,
    List<BCCModel> currency,
    List<UomTypes> uomsList,
  }) {
    return SalesInvoiceState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        loadingError: loadingError ?? this.loadingError,
        enquiryItems: enquiryItems ?? this.enquiryItems,
        filePath: filePath ?? this.filePath,
        eorId: onSearch ? eorId : eorId ?? this.eorId,
        sorId: onSearch ? sorId : sorId ?? this.sorId,
        salesmanName: salesmanName ?? this.salesmanName,
        uom: uom ?? this.uom,
        totalRecords:
            onSearch ? totalRecords : totalRecords ?? this.totalRecords,
        start: onSearch ? 0 : start ?? this.start,
        searchText: searchText ?? this.searchText,
        customerTypes: customerTypes ?? this.customerTypes,
        salesman: salesman ?? this.salesman,
        salesFilter: salesFilter ?? this.salesFilter,
        despacthFrom: despacthFrom ?? this.despacthFrom,
        // batchList: batchList ?? this.batchList,
        model: model ?? this.model,
        uomsList: uomsList ?? this.uomsList,
        currency: currency ?? this.currency,
        salesInvoicelist: salesInvoicelist ?? this.salesInvoicelist,
        selectedTypes: selectedTypes ?? this.selectedTypes,
        customersList: customersList ?? this.customersList,
        scrollPosition: scrollPosition ?? this.scrollPosition,
        // selectedTypes: selectedTypes ?? this.selectedTypes,
        // salesman: salesman ?? this.salesman,
        selectedBranch: selectedBranch ?? this.selectedBranch,
        statuses: statuses ?? this.statuses,
        cartItems: cartItems ?? this.cartItems,
        // customersList: customersList ?? this.customersList,
        cusLookUp: cusLookUp ?? this.cusLookUp,
        salesModel: salesModel ?? this.salesModel,
        // customerTypes: customerTypes ?? this.customerTypes,
        customer: customer ?? this.customer,
        branches: branches ?? this.branches,
        cartItem: cartItem ?? this.cartItem,
        costDetails: costDetails ?? this.costDetails,
        costItem: costItem ?? this.costItem,
        analysisCode: analysisCode ?? this.analysisCode,
        analysisTableCode: analysisTableCode ?? this.analysisTableCode,
        despatchFrom: despatchFrom ?? this.despatchFrom,
        enquirySaved: enquirySaved ?? this.enquirySaved,
        currencyEx: currencyEx ?? this.currencyEx,
        isQtyUpdatable: isQtyUpdatable ?? this.isQtyUpdatable,
        salesInvoiceDtlList: salesInvoiceDtlList ?? this.salesInvoiceDtlList);
  }

  factory SalesInvoiceState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);

    return SalesInvoiceState(
      loadingStatus: LoadingStatus.success,
      loadingError: "",
      loadingMessage: "",
      filePath: "",
      enquiryItems: [],
      eorId: null,
      sorId: null,
      totalRecords: null,
      start: 0,
      salesModel: null,
      uomsList: [],
      salesFilter: PVFilterModel(
          salesinvoiceFromDate: startDate,
          salesinvoiceToDate: currentDate,
          salesinvoiceTransno: ""),
      searchText: "",
      scrollPosition: 0,
      salesman: List(),
      customerTypes: List(),
      // batchList: List(),
      despacthFrom: List(),
      customersList: List(),
      model: null,
      currency: List(),
      selectedTypes: null,
      salesInvoiceDtlList: List(),
      uom: null,

      isQtyUpdatable: null,
      branches: [],
      cartItems: [],
      selectedBranch: null,

      statuses: [],
      enquirySaved: false,
      costDetails: null,
      salesmanName: "",
      salesInvoicelist: List(),

      despatchFrom: List(),
      cartItem: null,
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

import 'package:base/redux.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/cart_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/customer_type_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/model/sales_invoice_model.dart';

@immutable
class ProductState {
  final ProductListState listState;
  final ProductDetailState detailState;

  ProductState({
    @required this.listState,
    @required this.detailState,
  });

  ProductState copyWith({
    ProductListState listState,
    ProductDetailState detailState,
  }) {
    return ProductState(
      listState: listState ?? this.listState,
      detailState: detailState ?? this.detailState,
    );
  }

  factory ProductState.initial() {
    return ProductState(
      listState: ProductListState.initial(),
      detailState: ProductDetailState.initial(),
    );
  }
}

@immutable
class ProductListState extends BaseState {
  final List<ProductModel> enquiryItems;
  final int eorId;
  final int sorId;
  final int totalRecords;
  final int start;

  final String searchText;

  final double scrollPosition;
  final List<StockLocation> despacthFrom;
  final List<CustomerTypes> customerTypes;
  final List<SalesmanObjects> salesman;
  //final List<BatchList> batchList;
  final SalesInvoiceModel model;
  final List<CustomersList> customersList;
  final CustomerTypes selectedTypes;

  ProductListState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    String filePath,
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
    this.model,
    this.customersList,
    this.selectedTypes,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
          filePath: filePath,
        );

  ProductListState copyWith({
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
    //  List<BatchList> batchList,
    List<StockLocation> despacthFrom,
    SalesInvoiceModel model,
    List<CustomersList> customersList,
    CustomerTypes selectedTypes,
  }) {
    return ProductListState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        loadingError: loadingError ?? this.loadingError,
        enquiryItems: enquiryItems ?? this.enquiryItems,
        filePath: filePath ?? this.filePath,
        eorId: onSearch ? eorId : eorId ?? this.eorId,
        sorId: onSearch ? sorId : sorId ?? this.sorId,
        totalRecords:
            onSearch ? totalRecords : totalRecords ?? this.totalRecords,
        start: onSearch ? 0 : start ?? this.start,
        searchText: searchText ?? this.searchText,
        customerTypes: customerTypes ?? this.customerTypes,
        salesman: salesman ?? this.salesman,
        despacthFrom: despacthFrom ?? this.despacthFrom,
        // batchList: batchList ?? this.batchList,
        model: model ?? this.model,
        selectedTypes: selectedTypes ?? this.selectedTypes,
        customersList: customersList ?? this.customersList,
        scrollPosition: scrollPosition ?? this.scrollPosition);
  }

  factory ProductListState.initial() {
    return ProductListState(
      loadingStatus: LoadingStatus.success,
      loadingError: "",
      loadingMessage: "",
      filePath: "",
      enquiryItems: [],
      eorId: null,
      sorId: null,
      totalRecords: null,
      start: 0,
      searchText: "",
      scrollPosition: 0,
      salesman: List(),
      customerTypes: List(),
      //batchList: List(),
      despacthFrom: List(),
      customersList: List(),
      model: null,
      selectedTypes: null,
    );
  }
}

@immutable
class ProductDetailState extends BaseState {
  final ProductDetailModel productDetails;
  final List<CartItemModel> cartItems;

  ProductDetailState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    String filePath,
    this.productDetails,
    this.cartItems,
  }) : super(
            filePath: filePath,
            loadingMessage: loadingMessage,
            loadingError: loadingError,
            loadingStatus: loadingStatus);

  ProductDetailState copyWith({
    String loadingError,
    String loadingMessage,
    LoadingStatus loadingStatus,
    String filePath,
    ProductDetailModel productDetail,
    List<CartItemModel> cartItems,
  }) {
    return ProductDetailState(
      filePath: filePath ?? this.filePath,
      productDetails: productDetail ?? this.productDetails,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      cartItems: cartItems ?? this.cartItems,
    );
  }

  factory ProductDetailState.initial() {
    return ProductDetailState(
        loadingStatus: LoadingStatus.success,
        cartItems: List(),
        loadingError: "",
        loadingMessage: "");
  }
}

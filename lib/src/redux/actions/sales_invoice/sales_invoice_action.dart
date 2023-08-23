import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/customer_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/cart_details.dart';
import 'package:redstars/src/services/model/response/sales_invoice/customer_type_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_invoice_detail_list.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_invoice_view_list_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/services/repository/sales_invoice/product_details_repository.dart';
import 'package:redstars/src/services/repository/sales_invoice/sale_enquiry_repository.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/model/currecny_exchange_model.dart';
import 'package:redstars/src/widgets/screens/sales_invoice/model/sales_invoice_model.dart';

//enum ProductsPages { ProductDetail, ProductList }

class ProductsFetchedAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<ProductModel> products;
  String searchQuery;
  double scrollPosition;

  ProductsFetchedAction(
    this.products, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class OnProductDetailFetch {
  ProductDetailModel detail;

  OnProductDetailFetch(this.detail);
}

class ClearListAction {
  ClearListAction();
}

// class BatchFetchAction {
//   List<BatchList> bacth;
//   BatchFetchAction(this.bacth);
// }

class SalesFilterSaveAction {
  PVFilterModel salesFilter;
  SalesFilterSaveAction(this.salesFilter);
}

class ViewListSalesFetchAction {
  SalesInvoiceViewListModel salesInvoicelist;
  ViewListSalesFetchAction(this.salesInvoicelist);
}

class DespatchFromFetchAction {
  List<StockLocation> despatchFrom;
  DespatchFromFetchAction(this.despatchFrom);
}

class SalesmanFetchAction {
  List<SalesmanObjects> salesman;
  SalesmanFetchAction(this.salesman);
}

class CustomersListFetchAction {
  List<CustomersList> customersList;
  CustomersListFetchAction(this.customersList);
}

class CustomerTypeFetchAction {
  List<CustomerTypes> customerTypes;
  CustomerTypeFetchAction(this.customerTypes);
}

class OnCompleteDetailsAction {
  SalesInvoiceModel salesModel;

  OnCompleteDetailsAction(this.salesModel);
}

class ProductSaveAction {}

class SaleInvoiceClearAction {
  SaleInvoiceClearAction();
}

class SaleEnquiryInitialFetchAction {
  List<LocationModel> branchList;
  List<BCCModel> status;
  BSCModel isQtyUpdatable;

  SaleEnquiryInitialFetchAction(
    this.branchList,
    this.status,
    this.isQtyUpdatable,
  );
}

class SalesEnquiryBranchFetchSuccessAction {
  List<LocationModel> branchList;

  SalesEnquiryBranchFetchSuccessAction(this.branchList);
}

class CartProductsListAction {
  List<CartItemModel> products;

  CartProductsListAction(this.products);
}

class LocationChangeAction {
  LocationModel loc;

  LocationChangeAction(this.loc);
}

class EnquirySaveSuccessAction {
  EnquirySaveSuccessAction();
}

class SaleClearAction {
  SaleClearAction();
}

class SaleEnquiryClearAction {
  SaleEnquiryClearAction();
}

class DetailedListOfSalesInvoiceFetchAction {
  List<SalesInvoiceDetailList> salesInvoiceDtlList;
  DetailedListOfSalesInvoiceFetchAction(this.salesInvoiceDtlList);
}

class UomFetchData {
  List<UomTypes> uoms;
  UomFetchData(this.uoms);
}

// class DespatchFromFetchAction {
//   List<StockLocation> despatchFrom;
//   DespatchFromFetchAction(this.despatchFrom);
// }
//
// class SalesmanFetchAction {
//   List<SalesmanObjects> salesman;
//   SalesmanFetchAction(this.salesman);
// }
//
// class CustomersListFetchAction {
//   List<CustomersList> customersList;
//   CustomersListFetchAction(this.customersList);
// }

// class CustomerTypeFetchAction {
//   List<CustomerTypes> customerTypes;
//   CustomerTypeFetchAction(this.customerTypes);
// }

ThunkAction fetchDespatchFrom() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading, message: "Getting List"));
      SaleInvoiceRepository().getLocationObjects(
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(new DespatchFromFetchAction(response)));
    });
  };
}

ThunkAction fetchSalesInvoiceListView(
    {int start,
    PVFilterModel filterModel,
    int sor_id,
    int eor_id,
    int totalrecords,
    int optionId,
    // PurchaseViewListModel model,
    List<SalesInvoiceSavedViewList> listData}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      SaleInvoiceRepository().getSalesInvoiceView(
        start: start ?? 0,
        filterModel: filterModel,
        sor_Id: sor_id,
        eor_Id: eor_id,
        optionId: optionId,
        totalRecords: totalrecords,
        onRequestSuccess: (status) {
          sor_id = status.SOR_Id;
          eor_id = status.EOR_Id;
          totalrecords = status.totalRecords;
          listData.addAll(status.salesInvoicelist);
          store.dispatch(new ViewListSalesFetchAction(status));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchDetailedSalesInvoice({
  int start,
  PVFilterModel filterModel,
  int sor_id,
  int eor_id,
  int totalrecords,
  int optionId,
  SalesInvoiceSavedViewList salesviewlist,
  // PurchaseViewListModel model,
  // List<PurchaseViewList> listData
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      SaleInvoiceRepository().getDetailListOfSalesInvoice(
        start: start ?? 0,
        filterModel: filterModel,
        sor_Id: sor_id,
        eor_Id: eor_id,
        optionId: optionId,
        totalRecords: totalrecords,
        salesInvoicelist: salesviewlist,
        onRequestSuccess: (status) {
          // listData.addAll(status.purchaseViewList);
          store.dispatch(new DetailedListOfSalesInvoiceFetchAction(status));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchCustomersList(
    //{int typeBccId}
    ) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading, message: "Getting List"));
      SaleInvoiceRepository().getCustomer(
          //   typeBccId: typeBccId,
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(new CustomersListFetchAction(response)));
    });
  };
}

ThunkAction fetchCustomerTypes() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading, message: "Getting List"));
      SaleInvoiceRepository().getCustomerTypes(
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(new CustomerTypeFetchAction(response)));
    });
  };
}

ThunkAction fetchSalesman() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading, message: "Getting List"));
      SaleInvoiceRepository().getSalesmanObj(
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(new SalesmanFetchAction(response)));
    });
  };
}

ThunkAction fetchUomData() {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading",
        // type: "SALEINVOICE"
      ));

      SaleInvoiceRepository().getInitialConfig(
          onRequestSuccess: (uom) => store.dispatch(UomFetchData(uom)),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                // type: "SALEINVOICE"
              )));
    });
  };
}

ThunkAction fetchInvoiceConfig() {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading",
        // type: "SALEINVOICE"
      ));

      SaleInvoiceRepository().getConfigs(
          onRequestSuccess: (anlysisCode, currencyList, anlysisTableCode) =>
              store.dispatch(InvoiceCofigFetchAction(
                  anlysisCode, currencyList, anlysisTableCode)),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                // type: "SALEINVOICE"
              )));
    });
  };
}

ThunkAction fetchCurrencyExchangeList() {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Data",
        // type: "SALEINVOICE"
      ));

      SaleInvoiceRepository().getCurrencyExchange(
          onRequestSuccess: (response) =>
              store.dispatch(CurrencyExchangeFetchAction(response)),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                // type: "SALEINVOICE"
              )));
    });
  };
}

ThunkAction saveInvoiceAction({
  int optionId,
  List<CartItemModel> products,
  CartItemModel cartItemModel,
  double totalValues,
  // BatchList batchList,
  BCCModel status,
  CustomerTypes customerTypes,
  Customer customer,
  CustomersList customersList,
  List<CustomerTypes> types,
  List<CustomersList> custList,
  // List<BatchList> bach,
  List<SalesmanObjects> saleman,
  List<StockLocation> despatch,
  List<CurrencyExchange> currencyEx,
  BSCModel analysisCode,
  BSCModel analysisTableCode,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Placing Invoice",
        //type: "SALEINVOICE"
      ));

      SaleInvoiceRepository().saveInvoice(
          optionId: optionId,
          products: products,
          status: status,
          totalValues: totalValues,
          //  batch: bach,
          //  batchList: batchList,
          custList: custList,
          types: types,
          analysisCode: analysisCode,
          analysisType: analysisTableCode,
          cartItemModel: cartItemModel,
          customerTypes: customerTypes,
          customer: customer,
          customersList: customersList,
          saleman: saleman,
          currencyEx: currencyEx,
          despatchFrom: despatch,
          // onRequestSuccess: () {},
          onRequestSuccess: () {
            store.dispatch(EnquirySaveSuccessAction());
          },
          onRequestFailure: (error) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),

                // action: isMissingDocs ? "Update" : "",
                // onAction: isMissingDocs
                //     ? () {
                //         store.dispatch(CustomerOptionSelectedAction());
                //         Keys.navKey.currentState.push<void>(
                //             BasePageRoute.slideIn(ProfilePictureView()
                //                 // ItemAttachmentView<AppState, ScanViewModel>(),
                //                 ));
                //       }
                //     : null,
                //type: "SALEmmENQUIRY"
              )));
    });
  };
}

class InvoiceCofigFetchAction {
  BSCModel anlysisCodeObj;
  BSCModel anlysysTableCode;
  List<BCCModel> currencyList;
  InvoiceCofigFetchAction(
      this.anlysisCodeObj, this.currencyList, this.anlysysTableCode);
}

class CurrencyExchangeFetchAction {
  List<CurrencyExchange> currencyEx;

  CurrencyExchangeFetchAction(this.currencyEx);
}

ThunkAction addToCartAction(ProductModel product) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Adding an Item ",
        // type: ProductsPages.ProductDetail
      ));
      SaleInvoiceRepository().addToCart(
          product: product,
          onRequestSuccess: () {
            store.dispatch(ProductSaveAction());
            store.dispatch(fetchCartProductsList());
            //Keys.navKey.currentState.popAndPushNamed(AppRoutes.cart);
          },
          onRequestFailure: (error) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
                //type: ProductsPages.ProductDetail
              )));
    });
  };
}

ThunkAction fetchInitialList() {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading",
        // type: "SALEENQUIRY"
      ));

      SaleInvoiceRepository().getCartConfigs(
          onRequestSuccess: (branchList, status, isQtyUpdatable) =>
              store.dispatch(SaleEnquiryInitialFetchAction(
                  branchList, status, isQtyUpdatable)),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                // type: "SALEENQUIRY"
              )));

      SaleInvoiceRepository().getCartDetails(
          onRequestSuccess: (products) => {
                store.dispatch(CartProductsListAction(products)),
              },
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                // type: "SALEENQUIRY"
              )));
    });
  };
}
//
// ThunkAction fetchBranchesList() {
//   return (Store store) async {
//     Future(() async {
//       store.dispatch(LoadingAction(
//         status: LoadingStatus.loading,
//         message: "Getting Branches",
//         // type: "SALEENQUIRY"
//       ));
//
//       SaleInvoiceRepository().getBranchList(
//           onRequestSuccess: (branchList) =>
//               store.dispatch(SalesEnquiryBranchFetchSuccessAction(branchList)),
//           onRequestFailure: (exception) => store.dispatch(LoadingAction(
//                 status: LoadingStatus.error,
//                 message: exception.toString(),
//                 //  type: "SALEENQUIRY"
//               )));
//     });
//   };
// }

ThunkAction updateCartItem(CartItemModel item, int qty) {
  return (Store store) async {
    Future(() async {
      // store.dispatch(LoadingAction(
      //   //  status: LoadingStatus.loading,
      //   message: "Updating  ${item.itemName} .",
      //   // type: "SALEENQUIRY"
      // ));

      SaleInvoiceRepository().updateQty(
          item: item,
          qty: qty,
          onRequestSuccess: () => store.dispatch(fetchCartProductsList()),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                // type: "SALEENQUIRY"
              )));
    });
  };
}

ThunkAction removeListItemFromCart(List<CartItemModel> item) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Removing ",
        // type: "SALEENQUIRY"
      ));

      SaleInvoiceRepository().removeListCartItem(
          item: item,
          onRequestSuccess: () => store.dispatch(fetchCartProductsList()),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                //type: "SALEENQUIRY"
              )));
    });
  };
}

ThunkAction removeItemFromCart(CartItemModel item) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Removing ${item.itemName} ",
        // type: "SALEENQUIRY"
      ));

      SaleInvoiceRepository().removeCartItem(
          item: item,
          onRequestSuccess: () => store.dispatch(fetchCartProductsList()),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                //type: "SALEENQUIRY"
              )));
    });
  };
}

ThunkAction fetchCartProductsList() {
  return (Store store) async {
    Future(() async {
      // store.dispatch(LoadingAction(
      //   status: LoadingStatus.loading,
      //   message: "Updating cart items",
      //   // type: "SALEENQUIRY"
      // ));

      SaleInvoiceRepository().getCartDetails(
          onRequestSuccess: (products) => {
                store.dispatch(CartProductsListAction(products)),
              },
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                // type: "SALEENQUIRY"
              )));
    });
  };
}

ThunkAction fetchConstants() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Requisition ",
        //type: ProductsPages.ProductList
      ));

      // ProductsRepository().getProductList(
      //     // onRequestSuccess: (products) {
      //     //   store.dispatch(ProductsFetchedAction(products));
      //     // },
      //     onRequestFailure: (error) => store.dispatch(new LoadingAction(
      //         status: LoadingStatus.error,
      //         message: error.toString(),
      //         type: ProductsPages.ProductList)));
    });
  };
}

ThunkAction onSearchIemAction(String itemName) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;
      store.dispatch(ClearListAction());
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
        //type: ProductsPages.ProductList
      ));

      ProductsRepository().getProductList(
          optionId: optionId,
          name: itemName,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ProductsFetchedAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              searchQuery: itemName,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
                // type: ProductsPages.ProductList
              )));
    });
  };
}

ThunkAction fetchProducts(
    {String code,
    String name,
    int start,
    int eorId,
    int sorId,
    int totalRecords,
    double scrollPosition}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Products ",
        // type: ProductsPages.ProductList
      ));

      SaleInvoiceRepository().getProductList(
          optionId: optionId,
          start: start,
          code: code,
          name: name,
          sor_Id: sorId,
          eor_Id: eorId,
          totalRecords: totalRecords,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ProductsFetchedAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              scrollPosition: scrollPosition,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
                // type: ProductsPages.ProductList
              )));
    });
  };
}

ThunkAction fetchProductDetail(ProductModel product) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ${product.itemdescription} details ",
        // type: ProductsPages.ProductDetail
      ));

      ProductsRepository().getProductDetails(product.itemid,
          onRequestSuccess: (detail) {
            store.dispatch(OnProductDetailFetch(detail));
          },
          onRequestFailure: (error) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
                //  type: ProductsPages.ProductDetail
              )));
    });
  };
}

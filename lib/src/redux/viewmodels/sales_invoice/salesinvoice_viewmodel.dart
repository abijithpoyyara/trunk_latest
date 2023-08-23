import 'dart:ui';

import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/redux/actions/sales_invoice/sales_invoice_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
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

class SalesInvoiceViewModel extends BaseViewModel {
  final Function(ProductModel) onProductDetail;
  final List<ProductModel> enquiryItems;
  final String searchText;
  final double scrollPosition;
  final int totalRecords;
  final Function(ProductModel) onAddToCart;

  final VoidCallback onClearSearch;
  final String salesmanName;
  final Function(String) onSearch;
  final VoidCallback onRefresh;
  final Function(double) loadMoreItems;
  final List<CustomerTypes> customerTypes;
  final List<SalesmanObjects> salesman;
  final List<StockLocation> despatchFrom;
  final SalesInvoiceModel model;
  final CustomerTypes selectedTypes;
  final List<CustomersList> customersList;

  final Function(SalesInvoiceModel) salesInvoiceDetails;

  final List<LocationModel> branches;
  final List<CartItemModel> cartItems;
  final int optionId;
  final LocationModel selectedBranch;
  final bool isQtyUpdatable;

  final Customer cusLookUp;
  final CustomersList customers;
  final List<CurrencyExchange> currencyEx;
  final List<UomTypes> uomsList;
  // final List<BatchList> batchItem;
  // final BatchList selectedBatch;
  final List<CostItem> costItem;

  final CostOverviewModel costDetails;
  final List<CustomerList> customer;

  final BSCModel analysisCode;
  final BSCModel analysisTableCode;

  final double totalRate;
  final double totalTax;
  final double withHoldingTaxAmount;

  final double grossTotal;
  final PVFilterModel salesFilter;

  final Function(LocationModel) onLocationChange;
  final bool enquirySaved;
  final Function(CartItemModel) onItemRemove;
  final Function(List<CartItemModel>) onCartItemRemove;

  final Function(CartItemModel, int) onItemUpdate;
  final VoidCallback refreshCart;
  final VoidCallback refreshBranches;
  final Function() placeEnquiry;
  final Function(PVFilterModel salesFilter) onSalesFilterSave;

  // final VoidCallback onClear;
  // final VoidCallback onCleared;
  final List<SalesInvoiceDetailList> salesInvoiceDtlList;
  final VoidCallback saleInvoiceClear;
  final List<SalesInvoiceSavedViewList> salesInvoicelist;
  final SalesInvoiceViewListModel salesViewListModel;
  final Function(PVFilterModel filter, int start, double position,
      List<SalesInvoiceSavedViewList> list) onEnterFilter;
  final Function(SalesInvoiceSavedViewList) onTapViewList;
  final List<BCCModel> currency;
  final Function(PVFilterModel filter) onSubmit;

  SalesInvoiceViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    String filePath,
    this.onSubmit,
    this.onTapViewList,
    this.uomsList,
    this.salesmanName,
    this.currency,
    this.salesInvoiceDtlList,
    this.salesViewListModel,
    this.salesFilter,
    this.onSalesFilterSave,
    this.salesInvoicelist,
    this.onAddToCart,
    this.enquiryItems,
    this.onRefresh,
    this.totalRecords,
    this.searchText,
    this.scrollPosition,
    this.onClearSearch,
    this.onSearch,
    this.loadMoreItems,
    this.model,
    this.onProductDetail,
    this.despatchFrom,
    this.selectedTypes,
    this.customerTypes,
    this.salesman,
    this.salesInvoiceDetails,
    this.customersList,
    this.customers,
    this.costDetails,
    this.costItem,
    this.customer,
    this.analysisTableCode,
    this.analysisCode,
    this.currencyEx,

    // this.batchItem,
    // this.selectedBatch,
    this.cusLookUp,
    this.branches,
    this.cartItems,
    this.optionId,
    this.totalRate,
    this.totalTax,
    this.selectedBranch,
    this.withHoldingTaxAmount,
    this.grossTotal,
    this.enquirySaved,
    this.onItemRemove,
    this.onItemUpdate,
    this.refreshCart,
    this.onLocationChange,
    this.placeEnquiry,
    this.onCartItemRemove,
    //this.onClear,
    //  this.onCleared,
    this.isQtyUpdatable,
    this.saleInvoiceClear,
    this.refreshBranches,
    this.onEnterFilter,
  }) : super(
          loadingStatus: loadingStatus,
          loadingError: errorMessage,
          loadingMessage: loadingMessage,
          filePath: filePath,
        );

  static SalesInvoiceViewModel fromStore(Store<AppState> store) {
    final state = store.state.salesInvoiceState;
    // final optionId = store.state.homeState.selectedOption.optionId;
    double totalRate = 0;
    double netTotal = 0;
    double totalTax = 0;
    double withHoldingTaxAmount = 0;

    state.cartItems.forEach((element) {
      totalRate += element.rateDtl.mrpDtl.rateInclTax * element?.qty ?? 0;
      totalTax += element.rateDtl.taxes
          .fold(0, (previousValue, tax) => previousValue + tax.taxAmt);
      withHoldingTaxAmount += element.rateDtl.taxes
          .fold(0, (previousValue, tax) => previousValue + tax.deductedTax);
    });
    netTotal = totalRate - withHoldingTaxAmount + totalTax;
    var optionId = store.state.homeState.selectedOption.optionId;
    return SalesInvoiceViewModel(
        loadingStatus: state.loadingStatus,
        loadingMessage: state.loadingMessage,
        errorMessage: state.loadingError,
        filePath: state.filePath,
        enquiryItems: state.enquiryItems,
        scrollPosition: state.scrollPosition,
        salesViewListModel: state.salesModel,
        searchText: state.searchText,
        totalRecords: state.totalRecords,
        salesmanName: state.salesmanName,
        uomsList: state.uomsList,
        customerTypes: state.customerTypes,
        salesFilter: state.salesFilter,
        salesman: state.salesman,
        currency: state.currency,
        model: state.model,
        salesInvoicelist: state.salesInvoicelist,
        selectedTypes: state.selectedTypes,
        customersList: state.customersList,
        despatchFrom: state.despacthFrom,
        onSubmit: (filter) {
          store.dispatch(fetchSalesInvoiceListView(
            listData: [],
            optionId: optionId,
            filterModel: PVFilterModel(
                salesinvoiceFromDate: filter.salesinvoiceFromDate,
                salesinvoiceToDate: filter.salesinvoiceToDate,
                salesinvoiceTransno: filter.salesinvoiceTransno),
            start: 0,
            // sor_Id: state?.salesModel?.SOR_Id,
            // eor_Id: state?.salesModel?.EOR_Id,
            // totalRecords: state?.salesModel?.totalRecords
          ));
        },
        onEnterFilter: (model, start, position, saleslist) {
          store.dispatch(fetchSalesInvoiceListView(
            optionId: optionId,
            listData: saleslist,
            filterModel: PVFilterModel(
                salesinvoiceFromDate: model.salesinvoiceFromDate,
                salesinvoiceToDate: model.salesinvoiceToDate,
                salesinvoiceTransno: model.salesinvoiceTransno),
            start: start,
            // sor_Id: state?.salesModel?.SOR_Id,
            // eor_Id: state?.salesModel?.EOR_Id,
            // totalRecords: state?.salesModel?.totalRecords
          ));
        },
        onTapViewList: (detlList) {
          store.dispatch(fetchDetailedSalesInvoice(
              optionId: optionId,
              start: 0,
              totalrecords: detlList.totalrecords,
              sor_id: detlList.start,
              eor_id: detlList.limit,
              salesviewlist: detlList,
              filterModel: state.salesFilter));
        },
        onClearSearch: () {
          store.dispatch(onSearchIemAction(""));
        },
        onSearch: (query) {
          store.dispatch(onSearchIemAction(query));
        },
        onRefresh: () {
          store.dispatch(onSearchIemAction(""));
        },
        onSalesFilterSave: (filtermodel) {
          store.dispatch(SalesFilterSaveAction(filtermodel));
        },
        // salesInvoiceDetails: (salesModel) =>
        //     store.dispatch(OnCompleteDetailsAction(salesModel)),
        loadMoreItems: (position) {
          store.dispatch(fetchProducts(
            start: state.start,
            eorId: state.eorId,
            sorId: state.eorId,
            totalRecords: state.totalRecords,
            name: state.searchText,
            scrollPosition: position,
          ));
        },
        onProductDetail: (item) {},
        onAddToCart: (product) => store.dispatch(addToCartAction(product)),

        // loadingStatus: state.loadingStatus,
        // loadingMessage: state.loadingMessage,
        // errorMessage: state.loadingError,
        optionId: optionId,
        //optionId,
        branches: state.branches,
        cartItems: state.cartItems,
        salesInvoiceDtlList: state.salesInvoiceDtlList,
        isQtyUpdatable:
            "Y".contains(state.isQtyUpdatable?.constantValue ?? "N"),
        totalRate: totalRate,
        totalTax: totalTax,
        grossTotal: netTotal,
        withHoldingTaxAmount: withHoldingTaxAmount,
        selectedBranch: state.selectedBranch,
        enquirySaved: state.enquirySaved,
        // filePath: state.filePath,
        currencyEx: state.currencyEx,
        // customersList: state.customersList,
        saleInvoiceClear: () => store.dispatch(SaleInvoiceClearAction()),
        // customerTypes: state.customerTypes,
        // salesman: state.salesman,
        // despatchFrom: state.despatchFrom,
        costDetails: state.costDetails,
        customers: state.customers,
        cusLookUp: state.cusLookUp,
        costItem: state.costItem,
        customer: state.customer,
        // onCleared: () => store.dispatch(OnClearAction()),
        analysisTableCode: state.analysisTableCode,
        analysisCode: state.analysisTableCode,
        //  selectedBatch: state.selectedBatch,
        //   selectedTypes: state.selectedTypes,
        //  batchItem: state.batchItem,
        onLocationChange: (loc) => store.dispatch(LocationChangeAction(loc)),
        refreshCart: () => store.dispatch(fetchCartProductsList()),
        // refreshBranches: () => store.dispatch(fetchBranchesList()),
        onItemRemove: (item) => store.dispatch(removeItemFromCart(item)),
        onCartItemRemove: (cartItemList) =>
            store.dispatch(removeListItemFromCart(cartItemList)),
        onItemUpdate: (item, qty) => store.dispatch(updateCartItem(item, qty)),
        placeEnquiry: () {
          store.dispatch(saveInvoiceAction(
              // model: state.smodel,
              cartItemModel: state.cartItem,
              optionId: 59,
              totalValues: netTotal,
              // batchList: state.selectedBatch,
              // bach: state.batchItem,
              saleman: state.salesman,
              currencyEx: state.currencyEx,
              analysisCode: state.analysisCode,
              analysisTableCode: state.analysisTableCode,
              // optionId,

              // branch: state.selectedBranch,
              despatch: state.despatchFrom,
              products: state.cartItems,
              status: state.statuses.first,
              customerTypes: state.selectedTypes,
              customersList: state.customers,
              types: state.customerTypes,
              custList: state.customersList));
        });
  }

  bool isLastItem() {
    return totalRecords != null && totalRecords == enquiryItems?.length;
  }

  String validateItems() {
    String message = "";
    bool valid = true;
    cartItems?.forEach((element) {
      var item = element.itemName;
      if (valid) {
        if (!(element.qty > 0)) {
          message = "Quantity of $item cannot be zero";
          valid = false;
        } else if (element.batchDtl?.nlc == null) {
          message = "$item has no nlc";
          valid = false;
        } else if (!(element?.rateDtl?.mrpDtl?.rateInclTax > 0)) {
          message = "Rate of $item cannot be zero";
          valid = false;
        } else if ((element.rateDtl == null)) {
          message = "MrpDtl called null";
          valid = false;
        }
      }
    });
    return message;
  }
}

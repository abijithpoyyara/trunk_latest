import 'package:base/redux.dart';
import 'package:expression_language/expression_language.dart';
import 'package:redstars/src/redux/actions/sales_invoice/sales_invoice_action.dart';
import 'package:redstars/src/redux/states/sales_invoice%20state/si_state.dart';
import 'package:redstars/src/services/model/response/sales_invoice/cart_details.dart';

final salesInvoiceReducer = combineReducers<SalesInvoiceState>([
  TypedReducer<SalesInvoiceState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<SalesInvoiceState, SetFilePathAction>(_setFilePathAction),
  TypedReducer<SalesInvoiceState, ClearListAction>(_clearListAction),
  TypedReducer<SalesInvoiceState, ProductsFetchedAction>(_productsFetchAction),

//  TypedReducer<SalesInvoiceState, LoadingAction>(_changeLoadingStatusAction),
  // TypedReducer<SalesInvoiceState, SaleEnquiryClearAction>(_clearAction),
  TypedReducer<SalesInvoiceState, SetFilePathAction>(_setFilePathAction),
  TypedReducer<SalesInvoiceState, SaleEnquiryInitialFetchAction>(
      _initialListFetchAction),
  // TypedReducer<SalesInvoiceState, CartItemSelectAction>(_cartItemSelectAction),
  TypedReducer<SalesInvoiceState, SalesEnquiryBranchFetchSuccessAction>(
      _branchesFetchAction),
  TypedReducer<SalesInvoiceState, LocationChangeAction>(_branchChangeAction),
  TypedReducer<SalesInvoiceState, CartProductsListAction>(_cartListFetchAction),
  TypedReducer<SalesInvoiceState, EnquirySaveSuccessAction>(_saveAction),
  TypedReducer<SalesInvoiceState, CustomerTypeFetchAction>(
      _customerTypesFetchAction),
  TypedReducer<SalesInvoiceState, SalesmanFetchAction>(_salesmanFetchAction),
  TypedReducer<SalesInvoiceState, DespatchFromFetchAction>(
      _despatchFetchAction),
  // TypedReducer<SalesInvoiceState, BatchFetchAction>(_batchFecthAction),
  TypedReducer<SalesInvoiceState, CurrencyExchangeFetchAction>(
      _currencyExchange),
  // TypedReducer<SalesInvoiceState, CustomersListFetchAction>(
  //     _customerListFetchAction),
  TypedReducer<SalesInvoiceState, InvoiceCofigFetchAction>(
      _invoiceConfigAction),
  // TypedReducer<SalesInvoiceState, OnClearAction>(_saleClearAction),
  TypedReducer<SalesInvoiceState, SaleInvoiceClearAction>(_invoiceClearAction),
  // TypedReducer<SalesInvoiceState, CustomerTypeFetchAction>(
  //     _customerTypesFetchAction),
  // TypedReducer<SalesInvoiceState, SalesmanFetchAction>(_salesmanFetchAction),
  // TypedReducer<SalesInvoiceState, DespatchFromFetchAction>(_despatchFetchAction),
  TypedReducer<SalesInvoiceState, CustomersListFetchAction>(
      _customerListFetchAction),
  // TypedReducer<SalesInvoiceState, OnCompleteDetailsAction>(
  //     _onCompleteFetchAction),
  TypedReducer<SalesInvoiceState, SalesFilterSaveAction>(_filterSave),
  TypedReducer<SalesInvoiceState, ViewListSalesFetchAction>(_invoiceViewList),
  TypedReducer<SalesInvoiceState, DetailedListOfSalesInvoiceFetchAction>(
      _detailedList),
  TypedReducer<SalesInvoiceState, UomFetchData>(_uomFetchAction),
]);

SalesInvoiceState _invoiceClearAction(
    SalesInvoiceState state, SaleInvoiceClearAction action) {
  return SalesInvoiceState.initial();
}

SalesInvoiceState _changeLoadingStatusAction(
    SalesInvoiceState state, LoadingAction action) {
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message);
}

// SalesInvoiceState _changeLoadingStatusAction(
//     SalesInvoiceState state, LoadingAction action) {
//   return action.type == ProductsPages.ProductList
//       ? state.copyWith(
//           loadingStatus: action.status,
//           loadingMessage: "",
//           loadingError: "",
//         )
//       : state;
// }

SalesInvoiceState _uomFetchAction(
    SalesInvoiceState state, UomFetchData action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    uomsList: action.uoms,
  );
}

SalesInvoiceState _detailedList(
    SalesInvoiceState state, DetailedListOfSalesInvoiceFetchAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    salesInvoiceDtlList: action.salesInvoiceDtlList,
  );
}

// SalesInvoiceState _onCompleteFetchAction(
//     SalesInvoiceState state, OnCompleteDetailsAction action) {
//   print("model ====${action.salesModel}");
//   return state.copyWith(
//     loadingStatus: LoadingStatus.success,
//     model: action.salesModel,
//   );
// }
//
SalesInvoiceState _customerListFetchAction(
    SalesInvoiceState state, CustomersListFetchAction action) {
  print("${action.customersList}");
  state.copyWith(
      loadingStatus: LoadingStatus.success,
      customersList: action.customersList);
}
//
// SalesInvoiceState _despatchFetchAction(
//         SalesInvoiceState state, DespatchFromFetchAction action) =>
//     state.copyWith(
//         loadingStatus: LoadingStatus.success,
//         despacthFrom: action.despatchFrom);
//
// SalesInvoiceState _salesmanFetchAction(
//         SalesInvoiceState state, SalesmanFetchAction action) =>
//     state.copyWith(
//         loadingStatus: LoadingStatus.success, salesman: action.salesman);

SalesInvoiceState _productsFetchAction(
    SalesInvoiceState state, ProductsFetchedAction action) {
  var enquiryItems = state.enquiryItems;
  enquiryItems.addAll(action.products);
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    enquiryItems: enquiryItems,
    searchText: action.searchQuery,
    eorId: action.sorId,
    sorId: action.eorId,
    totalRecords: action.totalRecords,
    start: state.start + action.limit,
    scrollPosition: action.scrollPosition,
  );
}

SalesInvoiceState _setFilePathAction(
    SalesInvoiceState state, SetFilePathAction action) {
  return state.copyWith(filePath: action.filePath);
}

SalesInvoiceState _clearListAction(
    SalesInvoiceState state, ClearListAction action) {
  return state.copyWith(scrollPosition: 0, enquiryItems: [], onSearch: true);
}

SalesInvoiceState _saleClearAction(
    SalesInvoiceState state, OnClearAction action) {
  print("clear");
  print(state.cartItems);
  return SalesInvoiceState.initial();
}

SalesInvoiceState _currencyExchange(
    SalesInvoiceState state, CurrencyExchangeFetchAction action) {
  print("exchange======${action.currencyEx}");
  return
      //action.type == ProductsPages.ProductDetail
      state.copyWith(
    currencyEx: action.currencyEx,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
  // : state;
}

// SalesInvoiceState _invoiceViewList(
//     SalesInvoiceState state, ViewListSalesFetchAction action) {
//   print("SalesInvoiceList----${action.salesInvoicelist.salesInvoicelist}");
//   state.copyWith(
//       loadingStatus: LoadingStatus.success,
//       loadingMessage: "",
//       loadingError: "",
//       salesModel: action.salesInvoicelist);
// }

SalesInvoiceState _invoiceViewList(
    SalesInvoiceState state, ViewListSalesFetchAction action) {
  print("SalesInvoiceList----${action.salesInvoicelist.salesInvoicelist}");
  return
      //action.type == ProductsPages.ProductDetail
      state.copyWith(
    salesModel: action.salesInvoicelist,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
  // : state;
}

SalesInvoiceState _despatchFetchAction(
        SalesInvoiceState state, DespatchFromFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        despatchFrom: action.despatchFrom);

SalesInvoiceState _filterSave(
        SalesInvoiceState state, SalesFilterSaveAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        salesFilter: action.salesFilter);

SalesInvoiceState _salesmanFetchAction(
        SalesInvoiceState state, SalesmanFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        salesman: action.salesman);

// SalesInvoiceState _customerListFetchAction(
//     SalesInvoiceState state, CustomersListFetchAction action) {
//   print("neenfhghfu ====>${action.customersList}");
//   return state.copyWith(
//       loadingStatus: LoadingStatus.success,
//       loadingMessage: "",
//       loadingError: "",
//       customers: action.customersList.first,
//       customersList: action.customersList);
// }

// SalesInvoiceState _batchFecthAction(
//     SalesInvoiceState state, BatchFetchAction action) {
//   print("althf=====${action.bacth}");
//   state.copyWith(loadingStatus: LoadingStatus.success, batchItem: action.bacth);
// }

SalesInvoiceState _customerTypesFetchAction(
        SalesInvoiceState state, CustomerTypeFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        customerTypes: action.customerTypes,
        selectedTypes: action.customerTypes.first);
// SalesInvoiceState _changeLoadingStatusAction(
//     SalesInvoiceState state, LoadingAction action) {
//   return state.copyWith(
//       loadingStatus: action.status,
//       loadingMessage: action.message,
//       loadingError: action.message);
// }

SalesInvoiceState _initialListFetchAction(
    SalesInvoiceState state, SaleEnquiryInitialFetchAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    branches: action.branchList,
    statuses: action.status,
    isQtyUpdatable: action.isQtyUpdatable,
  );
}

// SalesInvoiceState _clearAction(
//     SalesInvoiceState state, SaleEnquiryClearAction action) {
//   print("cleared");
//   return SalesInvoiceState.initial().copyWith(cartItems: []);
// }

SalesInvoiceState _cartListFetchAction(
    SalesInvoiceState state, CartProductsListAction action) {
  try {
    var calculatedCartItem = action.products.map((prod) {
      var itemRate = (prod.rateDtl.mrpDtl.rateInclTax ?? 0) * prod.qty;
      prod.rateDtl.taxes = taxCalcByStructure(prod.rateDtl.taxes, itemRate);
      return prod;
    }).toList();

    return state.copyWith(
      cartItems: calculatedCartItem,
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      //loadingMessage:
    );
  } catch (e) {
    print(e);

    return state.copyWith(loadingError: e.toString());
  }
}
// SalesInvoiceState _cartItemSelectAction(
//     SalesInvoiceState state, CartItemSelectAction action) {
//   print("cartItem======${action.item}");
//   for(int i=0;i<action.)
//   return
//       //action.type == ProductsPages.ProductDetail
//       state.copyWith(cartItem: action.item);
//   // : state;
// }

List<CartTaxDtlModel> taxCalcByStructure(
    List<CartTaxDtlModel> taxList, double subTotal) {
  var arithmeticExp = RegExp("(?<=[-+*/])|(?=[-+*/])");
  var scale = 0.00;
  var TOT_VAL = subTotal;
  print("tax size : ${taxList.length}");

  taxList.sort((a, b) => a.sortOrder < b.sortOrder ? -1 : 1);
  Map<String, double> winObj = Map();
  winObj["TOT_VAL"] = TOT_VAL;
  taxList.map((rec) {
    print("attachmentDesc  ${rec.attachmentDesc}");
    var taxCode = rec.attachmentCode;
    winObj[taxCode] = 0;
    List<String> result = rec.calculateOn.split(arithmeticExp);
    var calcExpression = result.fold<String>("", (previousValue, element) {
      return previousValue +
          ((arithmeticExp.hasMatch(element))
              ? element
              : winObj[element]?.toString() ?? '0');
    });
    print("calcExpression $calcExpression");

    var expressionGrammarDefinition = ExpressionGrammarParser({});
    var parser = expressionGrammarDefinition.build();
    var calcResult = parser.parse(calcExpression);
    var expression = calcResult.value as Expression;
    double value = double.parse(expression.evaluate().toString());
    print(value);

    var taxAppAmt = value;
    // print(" $taxAppAmt ${rec.taxPerc} ");
    print(" $taxAppAmt ${rec.taxPerc} ${taxAppAmt * (rec.taxPerc / 100)}");
    // winObj[taxCode] = 0.00;
    winObj[taxCode] = taxAppAmt * (rec.taxPerc / 100);

    rec.taxAppAmt = taxAppAmt;
    rec.taxAmt = rec.effectOnParty == 1 ? winObj[taxCode] : 0;
    rec.deductedTax = rec.effectOnParty == 0 ? winObj[taxCode] : 0;
    return rec;
  }).toList();

  return taxList;
}

SalesInvoiceState _branchChangeAction(
    SalesInvoiceState state, LocationChangeAction action) {
  return state.copyWith(selectedBranch: action.loc);
}

SalesInvoiceState _saveAction(
    SalesInvoiceState state, EnquirySaveSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    enquirySaved: true,
  );
}

SalesInvoiceState _invoiceConfigAction(
    SalesInvoiceState state, InvoiceCofigFetchAction action) {
  print("analysisCode===${action.anlysisCodeObj}");
  print("analysisTableCode===${action.anlysysTableCode}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      analysisCode: action.anlysisCodeObj,
      currency: action.currencyList,
      analysisTableCode: action.anlysysTableCode);
}

// SalesInvoiceState _setFilePathAction(
//     SalesInvoiceState state, SetFilePathAction action) {
//   return state.copyWith(filePath: action.filePath);
// }

SalesInvoiceState _branchesFetchAction(
    SalesInvoiceState state, SalesEnquiryBranchFetchSuccessAction action) {
  return state.copyWith(
    branches: action.branchList,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

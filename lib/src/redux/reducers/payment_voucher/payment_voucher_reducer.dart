import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/payment_voucher/payment_voucher_action.dart';
import 'package:redstars/src/redux/states/payment_voucher/payment_voucher_state.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/payment_voucher_model.dart';

final paymentVoucherReducer = combineReducers<PaymentVoucherState>([
  TypedReducer<PaymentVoucherState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<PaymentVoucherState, OnClearAction>(_clearAction),
  TypedReducer<PaymentVoucherState, AddPaymentVoucherAction>(_newItemAction),
  TypedReducer<PaymentVoucherState, RemovePaymentVoucherAction>(
      _removeItemAction),
  TypedReducer<PaymentVoucherState, PaymentVoucherConfigFetchAction>(
      _transStatusAction),
  TypedReducer<PaymentVoucherState, VoucherSaveAction>(_saveAction),
  TypedReducer<PaymentVoucherState, POProcessFromFillAction>(_fillAction),
  TypedReducer<PaymentVoucherState, VoucherPurchaseOrderListAction>(
      _fillDtlAction),
  TypedReducer<PaymentVoucherState, ClearActionOnChange>(_clearChangeAction),
  TypedReducer<PaymentVoucherState, CurrencyExchangeFetchAction>(
      _currencyExchange),
  TypedReducer<PaymentVoucherState, SavingModelVarAction>(
      _savingModelVarAction),
  TypedReducer<PaymentVoucherState, ChangePaymentModeAction>(
      _paymentModeChangeAction),
  // TypedReducer<PaymentVoucherState, ChangeHeaderFieldAction>(_changeHdrAction),
  TypedReducer<PaymentVoucherState, OnEntrySave>(_voucherModelSaveAction),
  TypedReducer<PaymentVoucherState, OnAccountBalance>(_accountBalanceAction),
  TypedReducer<PaymentVoucherState, CashAcctBalance>(_cashAcctBalanceAction),
  TypedReducer<PaymentVoucherState, OnCashierBalance>(_cashierBalanceAction),
  TypedReducer<PaymentVoucherState, ServiceListAction>(_serviceAction),
  TypedReducer<PaymentVoucherState, BudgetDetails>(_budgetAction),
]);

PaymentVoucherState _clearChangeAction(
    PaymentVoucherState state, ClearActionOnChange action) {
  print("changeClearAction======${state.paymentMode}");
  return PaymentVoucherState.initial().copyWith(
      paymentMode: state.paymentMode,
      voucherPurchaseOrderList: state.voucherPurchaseOrderList,
      poProcessList: state.poProcessList,
      currencyExchange: state.currencyExchange,
      serviceList: state.serviceList,
      acctDetails: state.acctDetails,
      paymentTypes: state.paymentTypes,
      instrumentTypes: state.instrumentTypes,
      voucherTypes: state.voucherTypes,
      requesters: state.requesters);
}

PaymentVoucherState _paymentModeChangeAction(
    PaymentVoucherState state, ChangePaymentModeAction action) {
  print("exchange======${action.changedPaymentMode}");
  return state.copyWith(
    paymentMode: action.changedPaymentMode,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

PaymentVoucherState _currencyExchange(
    PaymentVoucherState state, CurrencyExchangeFetchAction action) {
  print("exchange======${action.currencyEx}");
  return state.copyWith(
    currencyExchange: action.currencyEx,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

PaymentVoucherState _changeLoadingStatusAction(
    PaymentVoucherState state, LoadingAction action) {
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message);
}

PaymentVoucherState _budgetAction(
    PaymentVoucherState state, BudgetDetails action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    budgetDtl: action.budgetDtl,
  );
}

BudgetDtlModel processdata;
PaymentVoucherState _newItemAction(
    PaymentVoucherState state, AddPaymentVoucherAction action) {
  action.item.budgetList =
      state.budgetDtl.isNotEmpty ? state.budgetDtl?.first : null;
  if (state.budgetDtl.isNotEmpty)
    print("State${state.budgetDtl?.first?.budgeted}");
  List<PaymentVoucherDtlModel> items = state.acctDetails;
  if (items.contains(action.item)) {
    int index = items.indexOf(action.item);
    var updatingItem = items[index];
    double revisedAmount = action.item?.amount;

    //  processdata = state.poProcessList.first.dtljson.budgetdtljson;
    // data = state.budgetDtl.first;
    // action.item.budgetList = data;
    var updatedItem = updatingItem?.copyWith(
      amount: revisedAmount,
    );

    //  data = state.poProcessList.first.dtljson.budgetdtljson;
    items[index] = updatedItem;
    return state.copyWith(acctDetails: items);
  } else
    return state.copyWith(
      acctDetails: [action.item, ...items],
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
    );
}

PaymentVoucherState _transStatusAction(
    PaymentVoucherState state, PaymentVoucherConfigFetchAction action) {
  print(action.analysisCodeObj);
  print(action.analysisCodeTypeObj);
  print(action.paidToTypeBccId);
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      analysisCodeTypeObj: action.analysisCodeTypeObj,
      analysisCodeObj: action.analysisCodeObj,
      requesters: action.paidToTypes,
      paymentTypes: action.paymentTypes,
      paymentEntryProcessFromObj: action.paymentEntryProcessFromObj,
      voucherTypes: action.voucherTypes,
      instrumentTypes: action.instrumentTypes,
      voucherTypesRender: action.voucherTypesRender,
      editableYnObj: action.editableYnObj,
      paidToTypeBccId: action.paidToTypeBccId,
      paymentFlowTypes: action.paymentFlowTypes,
      settlementTypes: action.settlementTypes);
}

PaymentVoucherState _saveAction(
    PaymentVoucherState state, VoucherSaveAction action) {
  return state.copyWith(
    saved: true,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

PaymentVoucherState _clearAction(
    PaymentVoucherState state, OnClearAction action) {
  return PaymentVoucherState.initial();
  //     .copyWith(
  //   paymentTypes: state.paymentTypes,
  //   settlements: state.settlements,
  //   requestProcessType: state.requestProcessType,
  //   requesters: state.requesters,
  //   requestTransactionTypes: state.requestTransactionTypes,
  //   analysisCode: state.analysisCode,
  //   analysisType: state.analysisType,
  //   taxConfigs: state.taxConfigs,
  // );
}

PaymentVoucherState _savingModelVarAction(
        PaymentVoucherState state, SavingModelVarAction action) =>
    state.copyWith(filterModel: action.filterModel);

PaymentVoucherState _removeItemAction(
    PaymentVoucherState state, RemovePaymentVoucherAction action) {
  List<PaymentVoucherDtlModel> items = state.acctDetails;

  if (items.contains(action.item)) {
    items.remove(action.item);
    return state.copyWith(
      acctDetails: items,
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
    );
  }
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

PaymentVoucherState _serviceAction(
    PaymentVoucherState state, ServiceListAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      serviceList: action.serviceList);
}

PaymentVoucherState _voucherModelSaveAction(
    PaymentVoucherState state, OnEntrySave action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      selectedInstrumentType: action.voucherHdrModel.instrumentTypes,
      selectedPaidFrom: action.voucherHdrModel.voucherTypes,
      selectedBankInstrumentType: action.voucherHdrModel.instrumentBankTypes,
      selectedBankPaidFrom: action.voucherHdrModel.voucherBankTypes,
      cashier: action.voucherHdrModel.requestFromName,
      remarks: action.voucherHdrModel.remarks,
      tillDate: action.voucherHdrModel.tillDate,
      settlewithin: action.voucherHdrModel.settleWithinDays,
      selectedSettlementType: action.voucherHdrModel.settlementTypes,
      //  paymentMode: action.voucherHdrModel.paymentMode,
      model: action.voucherHdrModel);
}

PaymentVoucherState _cashAcctBalanceAction(
    PaymentVoucherState state, CashAcctBalance action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      cashAcctBalanceList: action.cashAcctBalanceList);
}

PaymentVoucherState _accountBalanceAction(
    PaymentVoucherState state, OnAccountBalance action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      accountBalanceList: action.accountBalanceList);
}

PaymentVoucherState _cashierBalanceAction(
    PaymentVoucherState state, OnCashierBalance action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      cashierBalanceList: action.cashierBalanceList);
}

PaymentVoucherState _fillAction(
    PaymentVoucherState state, POProcessFromFillAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      poProcessList: action.poFillResult);
}

// PaymentVoucherState _changeHdrAction(
//     PaymentVoucherState state, ChangeHeaderFieldAction action) {
//   return state.copyWith(
//     paymentHdr: action.hdrModel,
//     paymentItems: [],
//     loadingError: "",
//     loadingMessage: "",
//     loadingStatus: LoadingStatus.success,
//   );
// }

PaymentVoucherState _fillDtlAction(
    PaymentVoucherState state, VoucherPurchaseOrderListAction action) {
  return state.copyWith(
    voucherPurchaseOrderList: action.voucherPurchaseList,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

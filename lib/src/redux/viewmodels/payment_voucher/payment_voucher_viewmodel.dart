import 'package:base/constants.dart';
import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/payment_voucher/payment_voucher_action.dart';
import 'package:redstars/src/redux/actions/requisition/payment_requisition/payment_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/payment_voucher/payment_voucher_state.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/currency_exchange_rate_model.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/account_balance_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/payment_voucher/voucher_purchase_order_model.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_initial_model.dart';
import 'package:redstars/src/services/model/response/requisition/transaction_status_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/payment_voucher_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/service_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';

import '../../../../utility.dart';

class PaymentVoucherViewModel extends BaseViewModel {
  final List<BCCModel> voucherTypes;
  final List<BSCModel> editableYnObj;
  final List<BSCModel> analysisCodeObj;
  final List<BSCModel> analysisCodeTypeObj;
  final List<BCCModel> voucherTypesRender;
  final List<BCCModel> instrumentTypes;
  final List<BCCModel> paymentEntryProcessFromObj;
  final List<BCCModel> paymentTypes;
  final List<BCCModel> requesters;
  final List<BCCModel> paymentFlowTypes;
  final List<BCCModel> paidToTypeBccid;
  final List<BCCModel> settlementTypes;
  final int acctid;
  final int analysyscodetypeid;

  final List<PaymentVoucherDtlModel> acctDetails;
  final Function(PVFilterModel result) saveModelVar;
  final Function(String paymentModeData) onPaymentModeChange;
  final PaymentVoucherDtlModel dtlModel;
  final List<VoucherPurchaseOder> voucherPurchaseOrderList;
  final PurchaseOderProcessFillModel processFillModel;
  final Function(PaymentVoucherHdrModel model) onEntrySave;
  final Function(ServiceList service) getBudgetDtl;
  final List<CurrencyExchange> currencyExchange;
  final Function(PVFilterModel) onFilter;
  final BCCModel selectedInstrumentType;
  final BCCModel selectedPaidFrom;
  final BCCModel selectedBankInstrumentType;
  final BCCModel selectedBankPaidFrom;
  final BCCModel selectedCashier;
  final BCCModel selectedSettlementType;
  final DateTime tillDate;
  final int settlewithin;
  final String remarks;
  final String instNo;
  final String paymentMode;

  final Function(PaymentVoucherDtlModel) onAdd;
  final Function() onSave;
  final List<PaymentRequisitionDtlModel> requisitionItems;
  final List<PurchaseOrderProcessFill> poProcessList;
  final Future<void> Function() onRefresh;
  final List<TransactionStatusItem> status;
  final VoidCallback onClear;
  final int optionId;
  final ValueSetter<PaymentVoucherDtlModel> onRemoveItem;
  final ValueSetter<TransTypeLookupItem> getTransactionDetails;
  final PaymentVoucherHdrModel paymentHdr;
  final Function(PaymentVoucherHdrModel) setField;
  final List<TaxConfigModel> taxConfigs;
  final bool isSaved;
  final Function(VoucherPurchaseOder) getProcessFillPoList;
  final List<ServiceList> serviceList;
  final ServiceLookupItem cashier;
  final List<BudgetDtlModel> budgetDtl;

  final double totalBooking;
  final double totalRequestedAmount;
  final double vatAmount;
  final double withHoldingTaxAmount;
  final BudgetDtlModel selectedBudget;
  final ServiceList selectedService;

  final bool isTransactionSelected;

  final Function() changeLoadingAction;
  final List<AccountBalance> accountBalanceList;
  final List<AccountBalance> cashAcctBalanceList;
  final List<CashierBalance> cashierBalanceList;
  final Function(BCCModel) onGetBalance;
  final Function(BCCModel) onGetCashBalance;
  final Function(ServiceLookupItem) onCashierBalance;
  final DateTime fromDate;
  final DateTime toDate;
  final VoidCallback onModeClear;

  PaymentVoucherViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.settlementTypes,
    this.tillDate,
    this.settlewithin,
    this.selectedSettlementType,
    this.budgetDtl,
    this.cashier,
    this.cashierBalanceList,
    this.cashAcctBalanceList,
    this.onCashierBalance,
    this.onGetCashBalance,
    this.onModeClear,
    this.selectedService,
    this.selectedBudget,
    this.onPaymentModeChange,
    this.paidToTypeBccid,
    this.selectedBankInstrumentType,
    this.selectedBankPaidFrom,
    this.paymentMode,
    this.instNo,
    this.remarks,
    this.analysyscodetypeid,
    this.acctid,
    this.selectedPaidFrom,
    this.selectedInstrumentType,
    this.selectedCashier,
    this.onFilter,
    this.saveModelVar,
    this.dtlModel,
    this.acctDetails,
    this.getBudgetDtl,
    this.currencyExchange,
    this.serviceList,
    this.onGetBalance,
    this.accountBalanceList,
    this.onEntrySave,
    this.analysisCodeObj,
    this.analysisCodeTypeObj,
    this.onRefresh,
    this.requesters,
    this.getProcessFillPoList,
    this.changeLoadingAction,
    this.isTransactionSelected,
    this.onAdd,
    this.isSaved,
    this.poProcessList,
    this.fromDate,
    this.toDate,
    this.onSave,
    this.requisitionItems,
    this.status,
    this.optionId,
    this.onRemoveItem,
    this.onClear,
    this.paymentTypes,
    this.paymentFlowTypes,
    this.editableYnObj,
    this.voucherTypesRender,
    this.instrumentTypes,
    this.voucherTypes,
    this.paymentEntryProcessFromObj,
    this.voucherPurchaseOrderList,
    this.processFillModel,
    this.getTransactionDetails,
    this.paymentHdr,
    this.setField,
    this.taxConfigs,
    this.totalBooking,
    this.totalRequestedAmount,
    this.vatAmount,
    this.withHoldingTaxAmount,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory PaymentVoucherViewModel.fromStore(Store<AppState> store) {
    PaymentVoucherState state = store.state.paymentVoucherState;
    var optionId = store.state.homeState.selectedOption.optionId;
    int accountId;
    int analysisCodeTypeId;

    state.requesters.forEach((element) {
      if (element.code == 'CASHIER') {
        print(element.id);
        return analysisCodeTypeId = element.id;
      }
      return analysisCodeTypeId;
    });

    state.requesters.forEach((element) {
      if (element.code == 'CASHIER') {
        print(element.accountid);
        return accountId = element.accountid;
      }
      return accountId;
    });
    double totalBooking = 0;
    double vatAmount = 0;
    double totalRequestedAmount = 0;
    double withHoldingTaxAmount = 0;
    state.paymentItems.forEach((element) {
      totalBooking += element.amount;
      element.taxes?.forEach((dtlTax) {
        if (dtlTax.tax.effectonparty > 0)
          vatAmount += dtlTax.taxedAmount;
        else
          withHoldingTaxAmount += dtlTax.taxedAmount;
      });
    });
    totalRequestedAmount = totalBooking + vatAmount - withHoldingTaxAmount;

    return PaymentVoucherViewModel(
        loadingStatus: state.loadingStatus,
        errorMessage: state.loadingError,
        loadingMessage: state.loadingMessage,
        paymentTypes: state.paymentTypes,
        paymentFlowTypes: state.paymentFlowTypes,
        requisitionItems: state.paymentItems,
        poProcessList: state.poProcessList,
        paymentMode: state.paymentMode,
        cashierBalanceList: state.cashierBalanceList,
        paidToTypeBccid: state.paidToTypeBccId,
        budgetDtl: state.budgetDtl,
        selectedBudget: state.selectedBudget,
        selectedService: state.selectedService,
        instNo: state.instNo,
        settlewithin: state.settlewithin,
        tillDate: state.tillDate,
        settlementTypes: state.settlementTypes,
        selectedSettlementType: state.selectedSettlementType,
        acctid: accountId,
        analysyscodetypeid: analysisCodeTypeId,
        remarks: state.remarks,
        cashier: state.cashier,
        cashAcctBalanceList: state.cashAcctBalanceList,
        selectedInstrumentType: state.selectedInstrumentType,
        selectedCashier: state.selectedCashier,
        selectedPaidFrom: state.selectedPaidFrom,
        dtlModel: state.dtlModel,
        getBudgetDtl: (service) {
          return store.dispatch(
              fetchBudgetDtl(optionId: optionId, accountId: service.accountid));
        },
        acctDetails: state.acctDetails,
        accountBalanceList: state.accountBalanceList,
        serviceList: state.serviceList,
        currencyExchange: state.currencyExchange,
        optionId: optionId,
        analysisCodeObj: state.analysisCodeObj,
        analysisCodeTypeObj: state.analysisCodeTypeObj,
        isSaved: state.saved,
        requesters: state.requesters,
        paymentHdr: state.model,
        paymentEntryProcessFromObj: state.paymentEntryProcessFromObj,
        processFillModel: state.processFillModel,
        instrumentTypes: state.instrumentTypes,
        voucherTypes: state.voucherTypes,
        voucherPurchaseOrderList: state.voucherPurchaseOrderList,
        voucherTypesRender: state.voucherTypesRender,
        totalBooking: totalBooking,
        totalRequestedAmount: totalRequestedAmount,
        vatAmount: vatAmount,
        selectedBankInstrumentType: state.selectedBankInstrumentType,
        selectedBankPaidFrom: state.selectedBankPaidFrom,
        onModeClear: () {
          store.dispatch(ClearActionOnChange());
        },
        onEntrySave: (model) {
          store.dispatch(OnEntrySave(model));
        },
        onCashierBalance: (data) {
          return store.dispatch(fetchCashierBalanceList(
              accountId: accountId,
              analysisCodeTypeId: analysisCodeTypeId,
              analysisCodeId: data.id));
        },

        onRefresh: () {
          return store.dispatch(fetchVoucherPurchaseList(
              filterRange:
                  PVFilterModel(fromDate: state.fromDate, toDate: state.toDate),
              transNo: ""));
        },
        withHoldingTaxAmount: withHoldingTaxAmount,
        changeLoadingAction: () {
          store.dispatch(LoadingAction(
              status: LoadingStatus.success, message: "", type: ""));
        },
        saveModelVar: (result) => store.dispatch(SavingModelVarAction(
            filterModel: PVFilterModel(
                dateRange: DateTimeRange(
                    start: result?.fromDate, end: result?.toDate)))),
        onGetBalance: (bccmodel) {
          store.dispatch(
              fetchAccountBalanceList(accountId: bccmodel?.bookaccountid));
        },
        onGetCashBalance: (bccmodel) {
          store.dispatch(
              fetchCashAccountBalanceList(accountId: bccmodel?.bookaccountid));
        },
        onFilter: (filterModel) {
          store.dispatch(fetchVoucherPurchaseList(
              filterRange: filterModel, transNo: filterModel?.transNo ?? ""));
        },
        onSave: () {
          store.dispatch(saveVoucherAction(
              optionId: optionId,
              requesters: state.requesters,
              analysisCode: state.analysisCodeObj,
              analysisCodeType: state.analysisCodeTypeObj,
              paymentFlowTypes: state.paymentFlowTypes,
              paymentVchModel: state.model,
              paymentModeType: state.paymentMode,
              poList: state.poProcessList,
              currencyEx: state.currencyExchange,
              voucherTypes: state.voucherTypes,
              paymentTypes: state.paymentTypes,
              paidTotypeBccid: state.paidToTypeBccId,
              acctDetails: state.acctDetails));
        },
        getProcessFillPoList: (model) {
          store.dispatch(fetchVoucherPOFillDetails(id: model?.dtlid));
        },
        onPaymentModeChange: (changedValue) {
          store.dispatch(ChangePaymentModeAction(changedValue));
        },
        fromDate: state.filterModel?.dateRange?.start,
        toDate: state.filterModel?.dateRange?.end,
        taxConfigs: state.taxConfigs,
        onClear: () => store.dispatch(OnClearAction()),
        getTransactionDetails: (transaction) =>
            store.dispatch(fetchTransactionFillDetails(transaction)),
        setField: (hdrModel) => store.dispatch(OnEntrySave(hdrModel)),
        onRemoveItem: (item) =>
            store.dispatch(RemovePaymentVoucherAction(item)),
        onAdd: (model) => store.dispatch(AddPaymentVoucherAction(model)));
  }
  int departId;
  Future<int> depat() async {
    departId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    print(departId);
    return departId;
  }

  String validateItems() {
    var id = depat();
    String message = "";
    bool valid = true;
    acctDetails?.forEach((element) {
      var item = element.serviceList.accountname;
      if (valid) {
        if (!(element.amount > 0)) {
          message = "Amount cannot be zero.";
          valid = false;
        } else if (element.amount == null) {
          message = "Please enter amount.";
          valid = false;
        } else if (element.serviceList.accountname.isEmpty) {
          message = "Please add service.";
          valid = false;
        } else if (id == null) {
          message = "User has no department.";
          valid = false;
        }
      }
    });
    return message;
  }

  // void saveRequisition({
  //   String remarks,
  // }) {
  //   paymentHdr.requestAmount = totalRequestedAmount;
  //   paymentHdr.remarks = remarks;
  //
  //   onSave(optionId, paymentHdr, requisitionItems, defaultAnalysisCode.first,
  //       defaultAnalysisType.first);
  // }
}

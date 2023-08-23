import 'package:base/redux.dart';
import 'package:base/src/services/model/response/bcc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/currency_exchange_rate_model.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/account_balance_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/budget_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/payment_voucher/voucher_purchase_order_model.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_initial_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/payment_voucher_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/service_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';

@immutable
class PaymentVoucherState extends BaseState {
  final DateTime fromDate;
  final DateTime toDate;
  final BCCModel selectedInstrumentType;
  final BCCModel selectedPaidFrom;
  final BCCModel selectedCashier;
  final BCCModel selectedBankInstrumentType;
  final BCCModel selectedBankPaidFrom;
  final ServiceLookupItem cashier;
  final BudgetDtlModel selectedBudget;
  final ServiceList selectedService;
  final String remarks;
  final String instNo;
  final String paymentMode;
  final PVFilterModel filterModel;
  final PaymentVoucherDtlModel dtlModel;
  final List<BudgetDtlModel> budgetDtl;
  final List<BCCModel> voucherTypes;
  final List<BSCModel> editableYnObj;
  final List<BCCModel> voucherTypesRender;
  final List<BCCModel> instrumentTypes;
  final List<BCCModel> paymentEntryProcessFromObj;
  final List<BCCModel> paymentTypes;
  final List<BCCModel> paidToTypeBccId;
  final List<BCCModel> paymentFlowTypes;
  final List<BCCModel> requesters;
  final List<BCCModel> settlementTypes;
  final List<PurchaseOrderProcessFill> poProcessList;
  final List<VoucherPurchaseOder> voucherPurchaseOrderList;
  final PurchaseOderProcessFillModel processFillModel;
  final PaymentVoucherHdrModel model;
  final List<BSCModel> analysisCodeObj;
  final List<BSCModel> analysisCodeTypeObj;
  final List<AccountBalance> accountBalanceList;
  final List<AccountBalance> cashAcctBalanceList;
  final List<CashierBalance> cashierBalanceList;
  final List<ServiceList> serviceList;
  final List<CurrencyExchange> currencyExchange;

  final List<PaymentRequisitionDtlModel> paymentItems;
  final bool saved;
  final List<TaxConfigModel> taxConfigs;
  final List<PaymentVoucherDtlModel> acctDetails;
  final BCCModel selectedSettlementType;
  final DateTime tillDate;
  final int settlewithin;

  PaymentVoucherState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.settlewithin,
    this.tillDate,
    this.selectedSettlementType,
    this.settlementTypes,
    this.selectedBudget,
    this.selectedService,
    this.budgetDtl,
    this.cashier,
    this.cashierBalanceList,
    this.cashAcctBalanceList,
    this.paidToTypeBccId,
    this.selectedBankPaidFrom,
    this.selectedBankInstrumentType,
    this.selectedCashier,
    this.selectedInstrumentType,
    this.selectedPaidFrom,
    this.instNo,
    this.paymentMode,
    this.filterModel,
    this.remarks,
    this.dtlModel,
    this.acctDetails,
    this.currencyExchange,
    this.serviceList,
    this.analysisCodeTypeObj,
    this.analysisCodeObj,
    this.poProcessList,
    this.model,
    this.requesters,
    this.toDate,
    this.fromDate,
    this.voucherPurchaseOrderList,
    this.voucherTypesRender,
    this.voucherTypes,
    this.instrumentTypes,
    this.paymentEntryProcessFromObj,
    this.editableYnObj,
    this.processFillModel,
    this.paymentItems,
    this.saved,
    this.paymentTypes,
    this.taxConfigs,
    // this.analysisCode,
    // this.analysisType,
    this.paymentFlowTypes,
    this.accountBalanceList,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  PaymentVoucherState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    List<BCCModel> requesters,
    List<PaymentRequisitionDtlModel> paymentItems,
    bool saved,
    List<BCCModel> voucherTypes,
    List<BSCModel> editableYnObj,
    List<BCCModel> voucherTypesRender,
    List<BCCModel> instrumentTypes,
    List<BCCModel> paymentEntryProcessFromObj,
    List<BCCModel> paymentTypes,
    List<BCCModel> settlementTypes,
    List<VoucherPurchaseOder> voucherPurchaseOrderList,
    PurchaseOderProcessFillModel processFillModel,
    List<BCCModel> paymentFlowTypes,
    DateTime fromDate,
    DateTime toDate,
    PaymentVoucherHdrModel model,
    List<PurchaseOrderProcessFill> poProcessList,
    List<BSCModel> analysisCodeObj,
    List<BSCModel> analysisCodeTypeObj,
    List<AccountBalance> accountBalanceList,
    List<ServiceList> serviceList,
    List<CurrencyExchange> currencyExchange,
    List<PaymentVoucherDtlModel> acctDetails,
    PaymentVoucherDtlModel dtlModel,
    BCCModel selectedInstrumentType,
    BCCModel selectedPaidFrom,
    BCCModel selectedCashier,
    String remarks,
    String instNo,
    String paymentMode,
    PVFilterModel filterModel,
    BCCModel selectedBankInstrumentType,
    BCCModel selectedBankPaidFrom,
    List<BCCModel> paidToTypeBccId,
    List<AccountBalance> cashAcctBalanceList,
    List<CashierBalance> cashierBalanceList,
    ServiceLookupItem cashier,
    List<BudgetDtlModel> budgetDtl,
    BudgetList selectedBudget,
    ServiceList selectedService,
    BCCModel selectedSettlementType,
    DateTime tillDate,
    int settlewithin,
  }) {
    return PaymentVoucherState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingError: loadingError ?? this.loadingError,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        paymentItems: paymentItems ?? this.paymentItems,
        saved: saved ?? this.saved,
        model: model ?? this.model,
        dtlModel: dtlModel ?? this.dtlModel,
        cashier: cashier ?? this.cashier,
        budgetDtl: budgetDtl ?? this.budgetDtl,
        cashAcctBalanceList: cashAcctBalanceList ?? this.cashAcctBalanceList,
        serviceList: serviceList ?? this.serviceList,
        acctDetails: acctDetails ?? this.acctDetails,
        paidToTypeBccId: paidToTypeBccId ?? this.paidToTypeBccId,
        cashierBalanceList: cashierBalanceList ?? this.cashierBalanceList,
        selectedBudget: selectedBudget ?? this.selectedBudget,
        selectedService: selectedService ?? this.selectedService,
        settlewithin: settlewithin ?? this.settlewithin,
        tillDate: tillDate ?? this.tillDate,
        selectedSettlementType:
            selectedSettlementType ?? this.selectedSettlementType,
        selectedBankInstrumentType:
            selectedBankInstrumentType ?? this.selectedBankInstrumentType,
        selectedBankPaidFrom: selectedBankPaidFrom ?? this.selectedBankPaidFrom,
        accountBalanceList: accountBalanceList ?? this.accountBalanceList,
        analysisCodeTypeObj: analysisCodeTypeObj ?? this.analysisCodeTypeObj,
        analysisCodeObj: analysisCodeObj ?? this.analysisCodeObj,
        poProcessList: poProcessList ?? this.poProcessList,
        paymentTypes: paymentTypes ?? this.paymentTypes,
        currencyExchange: currencyExchange ?? this.currencyExchange,
        settlementTypes: settlementTypes ?? this.settlementTypes,
        paymentEntryProcessFromObj:
            paymentEntryProcessFromObj ?? this.paymentEntryProcessFromObj,
        // analysisCode: analysisCode ?? this.analysisCode,
        processFillModel: processFillModel ?? this.processFillModel,
        voucherPurchaseOrderList:
            voucherPurchaseOrderList ?? this.voucherPurchaseOrderList,
        instrumentTypes: instrumentTypes ?? this.instrumentTypes,
        editableYnObj: editableYnObj ?? this.editableYnObj,
        voucherTypes: voucherTypes ?? this.voucherTypes,
        voucherTypesRender: voucherTypesRender ?? this.voucherTypesRender,
        selectedCashier: selectedCashier ?? this.selectedCashier,
        selectedInstrumentType:
            selectedInstrumentType ?? this.selectedInstrumentType,
        selectedPaidFrom: selectedPaidFrom ?? this.selectedPaidFrom,
        remarks: remarks ?? this.remarks,
        instNo: instNo ?? this.instNo,
        paymentMode: paymentMode ?? this.paymentMode,

        // analysisType: analysisType ?? this.analysisType,
        paymentFlowTypes: paymentFlowTypes ?? this.paymentFlowTypes,
        fromDate: fromDate ?? this.fromDate,
        filterModel: filterModel ?? this.filterModel,
        requesters: requesters ?? this.requesters,
        toDate: toDate ?? this.toDate);
  }

  factory PaymentVoucherState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    return PaymentVoucherState(
      loadingStatus: LoadingStatus.success,
      loadingError: "",
      loadingMessage: "",
      fromDate: DateTime(currentDate.year, currentDate.month, 1),
      toDate: DateTime.now(),
      accountBalanceList: List(),
      currencyExchange: List(),
      serviceList: List(),
      paymentItems: [],
      settlementTypes: [],
      paymentTypes: [],
      paidToTypeBccId: List(),
      selectedBankPaidFrom: null,
      settlewithin: 0,
      tillDate: DateTime.now(),
      selectedBankInstrumentType: null,
      budgetDtl: List(),
      processFillModel: null,
      selectedService: null,
      selectedBudget: null,
      cashier: null,
      requesters: List(),
      filterModel: PVFilterModel(
          dateRange: DateTimeRange(
        start: startDate,
        end: currentDate,
      )),
      voucherTypesRender: List(),
      poProcessList: List(),
      voucherTypes: List(),
      acctDetails: List(),
      paymentEntryProcessFromObj: List(),
      voucherPurchaseOrderList: List(),
      instrumentTypes: List(),
      selectedSettlementType: null,
      editableYnObj: List(),
      paymentFlowTypes: List(),
      analysisCodeObj: List(),
      analysisCodeTypeObj: List(),
      selectedPaidFrom: null,
      selectedCashier: null,
      cashAcctBalanceList: [],
      cashierBalanceList: [],
      selectedInstrumentType: null,
      paymentMode: 'cash',
      instNo: "",
      remarks: "",

      // analysisCode: [],
      // analysisType: [],
      taxConfigs: [],
      saved: false,
    );
  }
}

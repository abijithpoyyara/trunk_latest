import 'package:base/redux.dart';
import 'package:base/src/services/model/response/bcc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_reqst_detail.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_initial_model.dart';
import 'package:redstars/src/services/model/response/requisition/payment_requisition/payment_requisition_view_list_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';

@immutable
class PaymentRequisitionState extends BaseState {
  final List<BCCModel> paymentTypes;
  final List<BSCModel> settlements;
  final List<BCCModel> requestProcessType;
  final List<BCCModel> requesters;
  final List<BCCModel> requestTransactionTypes;
  final PaymentRequisitionHdrModel paymentHdr;

  final List<PaymentRequisitionDtlModel> paymentItems;
  final bool saved;
  final List<TaxConfigModel> taxConfigs;
  final DateTime fromDate;
  final DateTime toDate;
  final List<BSCModel> analysisCode;
  final List<BSCModel> analysisType;
  final List<BudgetDtlModel> paymentBudgetDtl;
  final PaymentListModel paymentReqModel;
  final PVFilterModel model;
  final double scrollPosition;
  final int stockId;
  final List<PaymentDetailViewList> paymentDtlJson;
  final String requisitionDtlRemarks;
  final List<PaymentRequisitionDtlModel> paymentRequsitionItems;

  PaymentRequisitionState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.paymentRequsitionItems,
    this.requisitionDtlRemarks,
    this.paymentDtlJson,
    this.scrollPosition,
    this.paymentReqModel,
    this.paymentHdr,
    this.paymentItems,
    this.saved,
    this.paymentTypes,
    this.settlements,
    this.requestProcessType,
    this.requesters,
    this.requestTransactionTypes,
    this.taxConfigs,
    this.analysisCode,
    this.analysisType,
    this.paymentBudgetDtl,
    this.toDate,
    this.fromDate,
    this.model,
    this.stockId,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  PaymentRequisitionState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    List<PaymentRequisitionDtlModel> paymentItems,
    bool saved,
    List<BCCModel> paymentTypes,
    List<BSCModel> settlements,
    List<BCCModel> requestProcessType,
    List<BCCModel> requesters,
    List<BCCModel> requestTransactionTypes,
    PaymentRequisitionHdrModel paymentHdr,
    List<TaxConfigModel> taxConfigs,
    List<BSCModel> analysisCode,
    List<BSCModel> analysisType,
    List<BudgetDtlModel> paymentBudgetDtl,
    List<PaymentRequisitionDtlModel> paymentRequsitionItems,
    PaymentListModel paymentReqModel,
    PVFilterModel model,
    double scrollPosition,
    int stockId,
    List<PaymentDetailViewList> paymentDtlJson,
    String requisitionDtlRemarks,
  }) {
    return PaymentRequisitionState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingError: loadingError ?? this.loadingError,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      paymentItems: paymentItems ?? this.paymentItems,
      saved: saved ?? this.saved,
      paymentTypes: paymentTypes ?? this.paymentTypes,
      settlements: settlements ?? this.settlements,
      requestProcessType: requestProcessType ?? this.requestProcessType,
      requesters: requesters ?? this.requesters,
      paymentDtlJson: paymentDtlJson ?? this.paymentDtlJson,
      taxConfigs: taxConfigs ?? this.taxConfigs,
      paymentRequsitionItems:
          paymentRequsitionItems ?? this.paymentRequsitionItems,
      requestTransactionTypes:
          requestTransactionTypes ?? this.requestTransactionTypes,
      paymentHdr: paymentHdr ?? this.paymentHdr,
      analysisCode: analysisCode ?? this.analysisCode,
      analysisType: analysisType ?? this.analysisType,
      paymentBudgetDtl: paymentBudgetDtl ?? this.paymentBudgetDtl,
      paymentReqModel: paymentReqModel ?? this.paymentReqModel,
      model: model ?? this.model,
      stockId: stockId ?? this.stockId,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      requisitionDtlRemarks:
          requisitionDtlRemarks ?? this.requisitionDtlRemarks,
    );
  }

  factory PaymentRequisitionState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    return PaymentRequisitionState(
        loadingStatus: LoadingStatus.success,
        loadingError: "",
        loadingMessage: "",
        paymentRequsitionItems: List(),
        paymentItems: [],
        paymentTypes: [],
        settlements: [],
        paymentReqModel: null,
        requestProcessType: [],
        requesters: [],
        requestTransactionTypes: [],
        analysisCode: [],
        analysisType: [],
        paymentHdr: PaymentRequisitionHdrModel(),
        taxConfigs: [],
        scrollPosition: 0.0,
        paymentDtlJson: List(),
        stockId: 0,
        requisitionDtlRemarks: "",
        model: PVFilterModel(
            dateRange: DateTimeRange(
              start: startDate,
              end: currentDate,
            ),
            fromDate: startDate,
            toDate: currentDate),
        saved: false,
        paymentBudgetDtl: List());
  }
}

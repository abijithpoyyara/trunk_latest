import 'package:base/redux.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/gin/gin_state.dart';
import 'package:redstars/src/redux/states/job_progress/job_progress_state.dart';
import 'package:redstars/src/redux/states/notification_statistics_report/notification_statistics_state.dart';
import 'package:redstars/src/redux/states/notifications/notictions_state.dart';
import 'package:redstars/src/redux/states/payment_voucher/payment_voucher_state.dart';
import 'package:redstars/src/redux/states/po_acknowledge/po_acknowledge_state.dart';
import 'package:redstars/src/redux/states/po_khat/po_khat_state.dart';
import 'package:redstars/src/redux/states/pricing/pricing_state.dart';
import 'package:redstars/src/redux/states/sale_enquiry_mis/se_mis_state.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_state.dart';
import 'package:redstars/src/redux/states/sales_invoice%20state/si_state.dart';
import 'package:redstars/src/redux/states/transaction_unblock_request/transaction_unblock_request_state.dart';
import 'package:redstars/src/redux/states/transaction_unblock_request_approval/transaction_unblock_request_approval_state.dart';
import 'package:redstars/src/redux/states/unconfirmed_transaction_details/unconfirmed_transaction_details_state.dart';
import 'package:redstars/src/redux/states/vehicle_enquiry/vehicle_enquiry_state.dart';

import 'back_dated_entry_permission/back_dated_entry_permission_state.dart';
import 'branch_blocked_notification/branch_blocked_notification_state.dart';
import 'document_approval/document_approval_state.dart';
import 'grading_and_costing/grading_and_costing_state.dart';
import 'item_grade_rate_settings/item_grade_rate_settings_state.dart';
import 'requisition/requisition_state.dart';

@immutable
class AppState extends BaseAppState {
  final DocumentApprovalState docApprovalState;
  final SalesInsightState salesInsightState;
  final RequisitionState requisitionState;
  final SalesEnquiryMisState salesEnquiryMisState;
  final JobProgressState jobProgressState;
  final GINState ginState;
  final GradingCostingState gradingCostingState;
  final AcknowledgeState acknowledgeState;
  final PaymentVoucherState paymentVoucherState;
  final PricingState pricingState;
  final SalesInvoiceState salesInvoiceState;
  final ItemGradeRateState itemGradeRateState;
  final TransactionUnblockReqApprlState transactionUnblockReqApprlState;
  final POkhatState pokhatState;
  final UnConfirmedTransactionDetailState unConfirmedTransactionDetailState;
  final BlockedNotificationState blockedNotificationState;
  final TransUnblkReqState tranUnblkReqState;
  final NotificationStatisticsState notificationStatisticsState;
  final NotificationDataState notificationDataState;
  final VehicleEnquiryProductionDetailState vehicleEnquiryProductionDetailState;

  // final VehicleEnquiryProductionDetailState vehicleEnquiryProductionDetailState;

  final BackDatedEntryState backDatedEntryState;
  AppState({
    @required SignInState signInState,
    @required ScanState scanState,
    @required this.docApprovalState,
    @required this.salesInsightState,
    @required this.requisitionState,
    @required this.salesEnquiryMisState,
    @required this.jobProgressState,
    @required this.tranUnblkReqState,
    @required this.ginState,
    @required HomeState homeState,
    @required this.acknowledgeState,
    @required this.gradingCostingState,
    @required this.paymentVoucherState,
    @required this.pricingState,
    @required this.salesInvoiceState,
    @required this.itemGradeRateState,
    @required this.transactionUnblockReqApprlState,
    @required this.pokhatState,
    @required this.unConfirmedTransactionDetailState,
    @required this.blockedNotificationState,
    @required this.notificationStatisticsState,
    @required this.notificationDataState,
    @required this.vehicleEnquiryProductionDetailState,

    // @required this.vehicleEnquiryProductionDetailState,
    @required this.backDatedEntryState,
  }) : super(
          signInState: signInState,
          homeState: homeState,
          scanState: scanState,
        );

  factory AppState.initial() {
    return AppState(
        signInState: SignInState.initial(),
        homeState: HomeState.initial(),
        salesInsightState: SalesInsightState.initial(),
        docApprovalState: DocumentApprovalState.initial(),
        requisitionState: RequisitionState.initial(),
        scanState: ScanState.initial(),
        tranUnblkReqState: TransUnblkReqState.initial(),
        salesEnquiryMisState: SalesEnquiryMisState.initial(),
        jobProgressState: JobProgressState.initial(),
        ginState: GINState.initial(),
        gradingCostingState: GradingCostingState.initial(),
        acknowledgeState: AcknowledgeState.initial(),
        paymentVoucherState: PaymentVoucherState.initial(),
        pricingState: PricingState.initial(),
        salesInvoiceState: SalesInvoiceState.initial(),
        itemGradeRateState: ItemGradeRateState.initial(),
        transactionUnblockReqApprlState:
            TransactionUnblockReqApprlState.initial(),
        pokhatState: POkhatState.initial(),
        unConfirmedTransactionDetailState:
            UnConfirmedTransactionDetailState.initial(),
        blockedNotificationState: BlockedNotificationState.initial(),
        notificationStatisticsState: NotificationStatisticsState.initial(),
        notificationDataState: NotificationDataState.initial(),
        backDatedEntryState: BackDatedEntryState.initial(),
        vehicleEnquiryProductionDetailState:
            VehicleEnquiryProductionDetailState.initial());
  }

  AppState copyWith({
    SignInState signInState,
    HomeState homeState,
    DocumentApprovalState docApprovalState,
    SalesInsightState salesInsightState,
    RequisitionState requisitionState,
    ScanState scanState,
    SalesEnquiryMisState salesEnquiryMisState,
    JobProgressState jobProgressState,
    GINState ginState,
    GradingCostingState gradingCostingState,
    AcknowledgeState acknowledgeState,
    PaymentVoucherState paymentVoucherState,
    PricingState pricingState,
    SalesInvoiceState salesInvoiceState,
    ItemGradeRateState itemGradeRateState,
    TransactionUnblockReqApprlState transactionUnblockReqApprlState,
    POkhatState pokhatState,
    TransUnblkReqState transUnblkReqState,
    UnConfirmedTransactionDetailState unConfirmedTransactionDetailState,
    BlockedNotificationState blockedNotification,
    NotificationStatisticsState notificationStatisticsState,
    NotificationDataState notificationDataState,
    VehicleEnquiryProductionDetailState vehicleEnquiryProductionDetailState,
    BackDatedEntryState backDatedEntryState,
  }) {
    return AppState(
        homeState: homeState ?? this.homeState,
        signInState: signInState ?? this.signInState,
        docApprovalState: docApprovalState ?? this.docApprovalState,
        salesInsightState: salesInsightState ?? this.salesInsightState,
        requisitionState: requisitionState ?? this.requisitionState,
        scanState: scanState ?? this.scanState,
        salesEnquiryMisState: salesEnquiryMisState ?? this.salesEnquiryMisState,
        jobProgressState: jobProgressState ?? this.jobProgressState,
        ginState: ginState ?? this.ginState,
        gradingCostingState: gradingCostingState ?? this.gradingCostingState,
        acknowledgeState: acknowledgeState ?? this.acknowledgeState,
        paymentVoucherState: paymentVoucherState ?? this.paymentVoucherState,
        pricingState: pricingState ?? this.pricingState,
        salesInvoiceState: salesInvoiceState ?? this.salesInvoiceState,
        itemGradeRateState: itemGradeRateState ?? this.itemGradeRateState,
        transactionUnblockReqApprlState: transactionUnblockReqApprlState ??
            this.transactionUnblockReqApprlState,
        pokhatState: pokhatState ?? this.pokhatState,
        unConfirmedTransactionDetailState: unConfirmedTransactionDetailState ??
            this.unConfirmedTransactionDetailState,
        tranUnblkReqState: transUnblkReqState ?? this.tranUnblkReqState,
        notificationStatisticsState:
            notificationStatisticsState ?? this.notificationStatisticsState,
        blockedNotificationState:
            blockedNotification ?? this.blockedNotificationState,
        backDatedEntryState: backDatedEntryState ?? this.backDatedEntryState,
        notificationDataState:
            notificationDataState ?? this.notificationDataState,
        vehicleEnquiryProductionDetailState:
            vehicleEnquiryProductionDetailState ??
                this.vehicleEnquiryProductionDetailState);
  }
}

import 'package:base/redux.dart';
import 'package:redstars/src/redux/reducers/back_dated_entry_permission/back_dated_entry_permission_reducer.dart';
import 'package:redstars/src/redux/reducers/document_approval/document_approval_reducer.dart';
import 'package:redstars/src/redux/reducers/gin/gin_reducer.dart';
import 'package:redstars/src/redux/reducers/item_grade_rate_settings/item_grade_rate_settings_reducer.dart';
import 'package:redstars/src/redux/reducers/job_progress/job_progress_reducer.dart';
import 'package:redstars/src/redux/reducers/payment_voucher/payment_voucher_reducer.dart';
import 'package:redstars/src/redux/reducers/po_acknowledge/po_acknowledge_reducer.dart';
import 'package:redstars/src/redux/reducers/po_khat/po_khat_reducer.dart';
import 'package:redstars/src/redux/reducers/pricing/pricing_reducer.dart';
import 'package:redstars/src/redux/reducers/requisition/requesition_reducer.dart';
import 'package:redstars/src/redux/reducers/sales_enquiry_mis/sales_enquiry_mis_reducer.dart';
import 'package:redstars/src/redux/reducers/sales_insight/sales_insight_reducer.dart';
import 'package:redstars/src/redux/reducers/sales_invoice/si_reducer.dart';
import 'package:redstars/src/redux/reducers/transaction_unblock_request/transaction_unblock_request_reducers.dart';
import 'package:redstars/src/redux/reducers/transaction_unblock_request_approval/transaction_unblock_request_approval_reducer.dart';
import 'package:redstars/src/redux/reducers/unconfirmed_transaction_details/unconfirmed_transaction_details_reducer.dart';
import 'package:redstars/src/redux/reducers/vehicle_enquiry/vehicle_enquiry_reducer.dart';
import 'package:redstars/src/redux/states/app_state.dart';

import 'branch_blocked_notification/branch_blocked_notificaion_reducer.dart';
import 'grading_and_costing/grading_and_costing_reducer.dart';
import 'notification_statistics_report/notification_statistics_reducers.dart';
import 'notifications/notifications_reducer.dart';

AppState appReducer(AppState state, dynamic action) => state.copyWith(
    requisitionState: requisitionReducer(state.requisitionState, action),
    docApprovalState: documentApprovalReducer(state.docApprovalState, action),
    signInState: signinReducer(state.signInState, action),
    salesInsightState: salesInsightReducer(state.salesInsightState, action),
    homeState: homeReducer(state.homeState, action),
    scanState: scanReducer(state.scanState, action),
    salesEnquiryMisState: seMISReducer(state.salesEnquiryMisState, action),
    jobProgressState: jobProgressReducer(state.jobProgressState, action),
    ginState: ginReducer(state.ginState, action),
    acknowledgeState: acknowledgeReducer(state.acknowledgeState, action),
    paymentVoucherState:
        paymentVoucherReducer(state.paymentVoucherState, action),
    gradingCostingState:
        gradingCostingReducer(state.gradingCostingState, action),
    salesInvoiceState: salesInvoiceReducer(state.salesInvoiceState, action),
    pricingState: pricingReducer(state.pricingState, action),
    itemGradeRateState:
        itemGradeRateSettingsReducer(state.itemGradeRateState, action),
    transactionUnblockReqApprlState: transactionUnblockRequestApprovalReducer(
        state.transactionUnblockReqApprlState, action),
    pokhatState: pokhatReducer(state.pokhatState, action),
    unConfirmedTransactionDetailState: unConfirmedTransactionDetailReducer(
        state.unConfirmedTransactionDetailState, action),
    transUnblkReqState:
        transactionUnblockReducer(state.tranUnblkReqState, action),
    notificationStatisticsState: notificationStatisticsReducer(
        state.notificationStatisticsState, action),
    blockedNotification:
        blockedNotificationReducer(state.blockedNotificationState, action),
    notificationDataState:
        notificationsReducer(state.notificationDataState, action),
    backDatedEntryState:
        backDatedEntryReducer(state.backDatedEntryState, action),
    vehicleEnquiryProductionDetailState: vehicleEnquiryDetailReducer(
        state.vehicleEnquiryProductionDetailState, action));

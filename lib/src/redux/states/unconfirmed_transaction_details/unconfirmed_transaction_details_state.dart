import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_unblock_notification_model.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_list_model.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/model/unconfirmed_filter.dart';

class UnConfirmedTransactionDetailState extends BaseState {
  final List<BCCModel> statusTypes;
  final List<BCCModel> transOptionTypes;
  final bool unConfirmedTransactionDetailSave;
  final int optionId;
  final List<UnConfirmedTransactionDetailList>
      unConfirmedTransactionDetailListData;
  final UnConfirmedFilterModel unConfirmedFilterModel;
  final List<UnConfirmedTransactionDetailList> addedUnconfirmedItems;
  final UnConfirmedTransactionDetailList selectedUnconfirmedData;
  final DateTime fromDate;
  final DateTime toDate;
  final BCCModel initialTransType;
  final List<UnreadNotificationListModel> unreadList;
  final List<NotificationCountDetails> notificationDetails;
  final TransactionUnblockNotificationModel unconfirmedNotificationModel;

  ///update
  String message;
  bool unconfirmedTransactionApprovalFailure;

  final int statusCode;

  UnConfirmedTransactionDetailState(
      {LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.statusTypes,
    this.transOptionTypes,
    this.unConfirmedTransactionDetailSave,
    this.optionId,
    this.unConfirmedTransactionDetailListData,
    this.unConfirmedFilterModel,
    this.addedUnconfirmedItems,
    this.selectedUnconfirmedData,
    this.toDate,
    this.fromDate,
    this.initialTransType,
    this.unreadList,
    this.notificationDetails,
    this.unconfirmedNotificationModel,
    this.statusCode,
    this.message,
    this.unconfirmedTransactionApprovalFailure

//    this.dtlMapData,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  UnConfirmedTransactionDetailState copyWith(
      {LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    List<BCCModel> statusTypes,
    List<BCCModel> transOptionTypes,
    bool unConfirmedTransactionDetailSave,
    List<NotificationCountDetails> notificationDetails,
    int optionId,
    List<UnreadNotificationListModel> unreadList,
      List<UnConfirmedTransactionDetailList>
          unConfirmedTransactionDetailListData,
    UnConfirmedFilterModel unConfirmedFilterModel,
    List<UnConfirmedTransactionDetailList> addedUnconfirmedItems,
    UnConfirmedTransactionDetailList selectedUnconfirmedData,
    TransactionUnblockNotificationModel unconfirmedNotificationModel,
    DateTime fromDate,
    DateTime toDate,
    BCCModel initialTransType,
      int statusCode,
    String message,
    bool unconfirmedTransactionApprovalFailure,
  }) {
    return UnConfirmedTransactionDetailState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        loadingError: loadingError ?? this.loadingError,
        optionId: optionId ?? this.optionId,
        transOptionTypes: transOptionTypes ?? this.transOptionTypes,
        statusTypes: statusTypes ?? this.statusTypes,
        unConfirmedTransactionDetailSave: unConfirmedTransactionDetailSave ??
            this.unConfirmedTransactionDetailSave,
        notificationDetails: notificationDetails ?? this.notificationDetails,
        unConfirmedTransactionDetailListData:
            unConfirmedTransactionDetailListData ??
                this.unConfirmedTransactionDetailListData,
        unConfirmedFilterModel:
            unConfirmedFilterModel ?? this.unConfirmedFilterModel,
        addedUnconfirmedItems:
            addedUnconfirmedItems ?? this.addedUnconfirmedItems,
        selectedUnconfirmedData:
            selectedUnconfirmedData ?? this.selectedUnconfirmedData,
        unreadList: unreadList ?? this.unreadList,
        fromDate: fromDate ?? this.fromDate,
        statusCode: statusCode ?? this.statusCode,
        toDate: toDate ?? this.toDate,
        unconfirmedNotificationModel:
            unconfirmedNotificationModel ?? this.unconfirmedNotificationModel,
        initialTransType: initialTransType ?? this.initialTransType,
        message: message??this.message,
        unconfirmedTransactionApprovalFailure: unconfirmedTransactionApprovalFailure??this.unconfirmedTransactionApprovalFailure
    );
  }

  factory UnConfirmedTransactionDetailState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);

    return UnConfirmedTransactionDetailState(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        statusTypes: List(),
        transOptionTypes: List(),
        unConfirmedTransactionDetailSave: false,
        unConfirmedTransactionDetailListData: List(),
        addedUnconfirmedItems: [],
        selectedUnconfirmedData: null,
        initialTransType: null,
        notificationDetails: List(),
        fromDate: startDate,
        unconfirmedNotificationModel: null,
        statusCode: 0,
        unreadList: List(),
        toDate: currentDate,
        message: "",
        unconfirmedTransactionApprovalFailure: false,
        unConfirmedFilterModel: UnConfirmedFilterModel(
            fromDate: startDate, toDate: currentDate, optionCode: null));
  }
}

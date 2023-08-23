import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_detail_data_model.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_object_model.dart';

class NotificationStatisticsState extends BaseState {
  final List<NotificationStatisticsObject> notificationObj;
  final List<NotificationStatisticeReportObject> reportObjList;
  final List<NotificationStatisticeUserList> userList;
  final String selectedReportType;
  final String selectedAccountName;
  final String selectedNotifType;
  final String selectedFromDate;
  final String selectedToDate;
  final int selectedAnalysisCodeId;
  final int selectedAccountNameId;
  final int initReportTypeId;
  final int numberField;
  final List<BCCModel> voucherTypes;
  final List<BCCModel> numberTypes;
  final String fromDate;
  final String toDate;
  final String reporType;
  final bool accountFlag;
  final String notifiType;
  final String selectedUser;
  final String userName;
  final double scrollPosition;
  final String voucher;
  final String count;
  final BCCModel numberFormatTypeCode;
  final List<BCCModel> sortingTypes;
  final NotificationStatisticsDetailDataModel notificationDetailModel;
  final int selectedSortBccId;
  final BCCModel sortType;
  final List<BCCModel> sortTypeForUserType;
  NotificationStatisticsState({
    this.notificationObj,
    this.fromDate,
    this.accountFlag,
    this.selectedAccountName,
    this.initReportTypeId,
    this.voucherTypes,
    this.selectedAccountNameId,
    this.toDate,
    this.numberField,
    this.reporType,
    this.notifiType,
    this.selectedUser,
    this.scrollPosition,
    this.userName,
    this.reportObjList,
    this.userList,
    this.numberTypes,
    this.selectedReportType,
    this.selectedAnalysisCodeId,
    this.selectedNotifType,
    this.selectedFromDate,
    this.selectedToDate,
    this.notificationDetailModel,
    this.voucher,
    this.numberFormatTypeCode,
    this.count,
    this.sortingTypes,
    this.selectedSortBccId,
    this.sortType,
    this.sortTypeForUserType,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  NotificationStatisticsState copyWith({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    String selectedReportType,
    String selectedAccountName,
    int selectedAnalysisCodeId,
    int selectedAccountNameId,
    int initReportTypeId,
    String selectedNotifType,
    String selectedFromDate,
    String selectedToDate,
    String fromDate,
    String toDate,
    String reporType,
    bool accountFlag,
    String notifiType,
    String selectedUser,
    double scrollPosition,
    String userName,
    NotificationStatisticsDetailDataModel notificationDetailModel,
    List<NotificationStatisticsObject> notificationObj,
    List<NotificationStatisticeReportObject> reportObjList,
    List<NotificationStatisticeUserList> userList,
    List<BCCModel> voucherTypes,
    List<BCCModel> numberTypes,
    String voucher,
    int numberField,
    BCCModel numberFormatTypeCode,
    String count,
    List<BCCModel> sortingTypes,
    int selectedSortBccId,
    BCCModel sortType,
    List<BCCModel> sortTypeForUserType,
  }) {
    return NotificationStatisticsState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        loadingError: loadingError ?? this.loadingError,
        notificationObj: notificationObj ?? this.notificationObj,
        reportObjList: reportObjList ?? this.reportObjList,
        selectedUser: selectedUser ?? this.selectedUser,
        selectedAccountName: selectedAccountName ?? this.selectedAccountName,
        selectedAccountNameId:
            selectedAccountNameId ?? this.selectedAccountNameId,
        userList: userList ?? this.userList,
        accountFlag: accountFlag ?? this.accountFlag,
        scrollPosition: scrollPosition ?? this.scrollPosition,
        voucherTypes: voucherTypes ?? this.voucherTypes,
        numberTypes: numberTypes ?? this.numberTypes,
        selectedReportType: selectedReportType ?? this.selectedReportType,
        selectedAnalysisCodeId:
            selectedAnalysisCodeId ?? this.selectedAnalysisCodeId,
        selectedNotifType: selectedNotifType ?? this.selectedNotifType,
        selectedToDate: selectedToDate ?? this.selectedToDate,
        selectedFromDate: selectedFromDate ?? this.selectedFromDate,
        notificationDetailModel:
            notificationDetailModel ?? this.notificationDetailModel,
        voucher: voucher ?? this.voucher,
        count: count ?? this.count,
        numberFormatTypeCode: numberFormatTypeCode ?? this.numberFormatTypeCode,
        numberField: numberField ?? this.numberField,
        sortingTypes: sortingTypes ?? this.sortingTypes,
        sortType: sortType ?? this.sortType,
        selectedSortBccId: selectedSortBccId ?? this.selectedSortBccId,
        sortTypeForUserType: sortTypeForUserType ?? this.sortTypeForUserType);
  }

  factory NotificationStatisticsState.initial() {
    return NotificationStatisticsState(
      loadingError: "",
      loadingMessage: "",
      selectedReportType: "Transaction wise",
      scrollPosition: 0.0,
      selectedNotifType: null,
      selectedAccountName: null,
      selectedUser: null,
      selectedAnalysisCodeId: null,
      selectedAccountNameId: null,
      initReportTypeId: 1548,
      selectedFromDate: null,
      selectedToDate: null,
      numberFormatTypeCode: null,
      voucher: null,
      count: null,
      sortType: null,
      selectedSortBccId: null,
      accountFlag: false,
      loadingStatus: LoadingStatus.success,
      sortTypeForUserType: [],
      notificationObj: [],
      sortingTypes: [],
      voucherTypes: [],
      notificationDetailModel: null,
      reportObjList: [],
      userList: [],
    );
  }
}

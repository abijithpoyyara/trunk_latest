import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/redux/actions/notification_statistics_report/notification_statistics_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_detail_data_model.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_object_model.dart';

class NotificationStatisticsViewModel extends BaseViewModel {
  final List<NotificationStatisticsObject> notificationObj;
  final List<BCCModel> voucherTypes;
  final List<NotificationStatisticeReportObject> reportObjList;
  final List<NotificationStatisticeUserList> userList;
  final Function(String reportType) seletectedReportTypeFunc;
  final Function(String user) selectedUserFunc;
  final Function(int user) selectedAnalysisCodeIdFunc;
  final Function(String notifType) seletectedNotifTypeFunc;
  final Function(String fromDate) selectedFromDateFunc;
  final Function(String toDate) selectedToDateFunc;
  final Function(String toDate) selectedAccountNameFunc;
  final Function(int toDate) selectedAccountNameIdFunc;
  final Function(bool flag) accountFlagFunc;
  final List<BCCModel> numberTypes;
  final String report;
  final String notifType;
  final String user;
  final String fromDate;
  final String toDate;
  final bool accountFlag;
  final double scrollPosition;
  final Function(String voucher) selectedvoucherNo;
  final Function(String Count) selectedCount;
  final Function(int numberField) selectedCountType;
  final Function() ResetingFilter;
  final Function(BCCModel) onChangeFormatCode;
  final List<BCCModel> sortTypeForUserType;

  final Function(
      {String SelectedCount,
      String Voucher,
      String fromDate,
      String toDate,
      int start,
      int limit,
      int reportId,
      int notifId,
      int userId,
      int accountId,
      int numberField,
      int sortBccId}) getReportData;
  final Function({
    String report,
    String notifType,
    String user,
    String fromDate,
    String toDate,
  }) saveFilter;
  final String selectedReportType;
  final String selectedNotifType;
  final String selectedUser;
  final String selectedFromDate;
  final String selectedToDate;
  final String selectedAccountName;
  final int selectedAnalysisCodeId;
  final int initReportTypeId;
  final int selectedAccountNameId;
  final NotificationStatisticsDetailDataModel notificationDetailModel;
  final String voucher;
  final String count;
  final int numberField;
  final BCCModel numberFormatTypeCode;
  final List<BCCModel> sortingTypes;
  final Function() onClearAction;
  final int selectedSortBccId;
  final Function(int sortBccId) sortByAction;
  final BCCModel sortType;
  final Function(BCCModel) saveSortType;
  final Function() clearSortType;
  NotificationStatisticsViewModel({
    this.numberTypes,
    this.seletectedReportTypeFunc,
    this.selectedAccountNameId,
    this.selectedAccountNameIdFunc,
    this.initReportTypeId,
    this.voucherTypes,
    this.accountFlag,
    this.accountFlagFunc,
    this.selectedFromDateFunc,
    this.selectedAccountName,
    this.selectedAccountNameFunc,
    this.selectedToDateFunc,
    this.selectedUserFunc,
    this.selectedAnalysisCodeIdFunc,
    this.selectedAnalysisCodeId,
    this.selectedUser,
    this.scrollPosition,
    this.selectedFromDate,
    this.selectedToDate,
    this.numberField,
    this.selectedCountType,
    this.notificationObj,
    this.reportObjList,
    this.seletectedNotifTypeFunc,
    this.userList,
    this.selectedReportType,
    this.selectedNotifType,
    this.getReportData,
    this.notificationDetailModel,
    this.saveFilter,
    this.report,
    this.notifType,
    this.user,
    this.fromDate,
    this.toDate,
    this.voucher,
    this.count,
    this.selectedvoucherNo,
    this.ResetingFilter,
    this.selectedCount,
    this.numberFormatTypeCode,
    this.onChangeFormatCode,
    this.sortingTypes,
    this.onClearAction,
    this.selectedSortBccId,
    this.sortByAction,
    this.sortType,
    this.saveSortType,
    this.sortTypeForUserType,
    this.clearSortType,
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  factory NotificationStatisticsViewModel.fromStore(Store<AppState> store) {
    final state = store.state.notificationStatisticsState;
    return NotificationStatisticsViewModel(
      loadingStatus: state.loadingStatus,
      loadingError: state.loadingError,
      loadingMessage: state.loadingMessage,
      selectedReportType: state.selectedReportType,
      selectedNotifType: state.selectedNotifType,
      selectedAccountName: state.selectedAccountName,
      voucherTypes: state.voucherTypes,
      numberTypes: state.numberTypes,
      numberField: state.numberField,
      accountFlag: state.accountFlag,
      initReportTypeId: state.initReportTypeId,
      notificationDetailModel: state.notificationDetailModel,
      sortTypeForUserType: state.sortTypeForUserType,
      report: state.reporType,
      voucher: state.voucher,
      count: state.count,
      numberFormatTypeCode: state.numberFormatTypeCode,
      notifType: state.notifiType,
      selectedUser: state.selectedUser,
      selectedAnalysisCodeId: state.selectedAnalysisCodeId,
      selectedFromDate: state.selectedFromDate,
      selectedAccountNameId: state.selectedAccountNameId,
      selectedToDate: state.selectedToDate,
      scrollPosition: state.scrollPosition,
      user: state.userName,
      toDate: state.toDate,
      fromDate: state.fromDate,
      sortingTypes: state.sortingTypes,
      sortType: state.sortType,
      selectedSortBccId: state.selectedSortBccId,
      saveFilter: ({
        String report,
        String notifType,
        String user,
        String fromDate,
        String toDate,
      }) {
        store.dispatch(SaveFilter(
          report: report,
          notifType: notifType,
          user: user,
          fromDate: fromDate,
          toDate: toDate,
        ));
      },
      saveSortType: (type) {
        store.dispatch(OnSaveBccModel(type));
      },
      clearSortType: () {
        store.dispatch(ClearSortAtUser());
      },
      getReportData: (
          {String SelectedCount,
          String Voucher,
          String fromDate,
          String toDate,
          int start,
          int limit,
          int reportId,
          int notifId,
          int userId,
          int accountId,
          int numberField,
          int sortBccId}) {
        store.dispatch(fetchReportData(
            count: SelectedCount,
            Voucher: Voucher,
            start: start,
            limit: limit,
            userId: userId,
            notifId: notifId,
            reportId: reportId,
            fromDate: fromDate,
            toDate: toDate,
            accountId: state.selectedAccountNameId,
            numberFieldId: numberField,
            sortBccId: sortBccId));
      },
      seletectedReportTypeFunc: (reportType) {
        store.dispatch(SelectedReportType(reportType));
      },
      accountFlagFunc: (flag) {
        store.dispatch(AccountFlag(flag));
      },
      onChangeFormatCode: (formatCode) {
        store.dispatch(ChangeNumberFormatAction(formatCode));
      },
      selectedAccountNameIdFunc: (accountNameId) {
        store.dispatch(SelectedAccountNameIdFunc(accountNameId));
      },
      selectedAccountNameFunc: (accountName) {
        store.dispatch(SelectedAccountname(accountName));
      },
      selectedUserFunc: (user) {
        store.dispatch(SelectedUser(user));
      },
      selectedAnalysisCodeIdFunc: (userId) {
        store.dispatch(SelectedAnalysisCodeId(userId));
      },
      sortByAction: (sortBccId) {
        store.dispatch(ChangeSorting(sortBccId: sortBccId));
      },
      seletectedNotifTypeFunc: (notifType) {
        store.dispatch(SelectedNotifype(notifType));
      },
      selectedFromDateFunc: (fromDate) {
        store.dispatch(SelectedFromDate(fromDate));
      },
      onClearAction: () {
        store.dispatch(OnClearInitialNumberTypeAction());
      },
      selectedToDateFunc: (toDate) {
        store.dispatch(SelectedToDate(toDate));
      },
      selectedvoucherNo: (voucher) {
        store.dispatch(SelectedVoucher(voucher));
      },
      selectedCount: (Count) {
        store.dispatch(SelectedCountAction(Count));
      },
      selectedCountType: (type) {
        store.dispatch(ChangeNumberTypeAction(type));
      },
      ResetingFilter: () {
        store.dispatch(Resetfilter());
      },
      notificationObj: state.notificationObj,
      reportObjList: state.reportObjList,
      userList: state.userList,
    );
  }
}

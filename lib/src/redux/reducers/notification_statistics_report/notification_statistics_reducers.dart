import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/redux/actions/notification_statistics_report/notification_statistics_actions.dart';
import 'package:redstars/src/redux/states/notification_statistics_report/notification_statistics_state.dart';

final notificationStatisticsReducer =
    combineReducers<NotificationStatisticsState>([
  TypedReducer<NotificationStatisticsState, LoadingAction>(_lodingStatusAction),
  TypedReducer<NotificationStatisticsState, GetInitialDataAction>(
      _getInitialData),
  TypedReducer<NotificationStatisticsState, SelectedReportType>(
      _selectedReportType),
  TypedReducer<NotificationStatisticsState, SelectedNotifype>(
      _selectedNotifType),
  TypedReducer<NotificationStatisticsState, SelectedUser>(_selectedUser),
  TypedReducer<NotificationStatisticsState, SelectedAnalysisCodeId>(
      _selectedUserId),
  TypedReducer<NotificationStatisticsState, SelectedToDate>(_selectedToDate),
  TypedReducer<NotificationStatisticsState, SelectedAccountNameIdFunc>(
      _selectedAccountNameIdFunc),
  TypedReducer<NotificationStatisticsState, SelectedFromDate>(
      _selectedFromDate),
  TypedReducer<NotificationStatisticsState, SelectedAccountname>(
      _selectedAccountName),
  TypedReducer<NotificationStatisticsState, GetReportData>(_getReportData),
  TypedReducer<NotificationStatisticsState, SaveFilter>(_saveFilter),
  TypedReducer<NotificationStatisticsState, ClearAction>(_clearAction),
  TypedReducer<NotificationStatisticsState, AccountFlag>(_accountFlag),
  TypedReducer<NotificationStatisticsState, FetchInitialCofig>(
      _fetchInitialCofig),
  TypedReducer<NotificationStatisticsState, SelectedVoucher>(_selectedVoucher),
  TypedReducer<NotificationStatisticsState, SelectedCountAction>(
      _selectedCount),
  TypedReducer<NotificationStatisticsState, Resetfilter>(_resetfilter),
  TypedReducer<NotificationStatisticsState, ChangeNumberTypeAction>(
      _changedNumberAction),
  TypedReducer<NotificationStatisticsState, ChangeNumberFormatAction>(
      _changedNumberFormatCodeAction),
  TypedReducer<NotificationStatisticsState, OnClearInitialNumberTypeAction>(
      _onClearInitialNumberType),
  TypedReducer<NotificationStatisticsState, ChangeSorting>(_onChangeSortAction),
  TypedReducer<NotificationStatisticsState, FetchSortTypes>(_sortingAction),
  TypedReducer<NotificationStatisticsState, OnSaveBccModel>(_saveSortType),
  TypedReducer<NotificationStatisticsState, ClearSortAtUser>(_clearSortType),
]);

NotificationStatisticsState _lodingStatusAction(
    NotificationStatisticsState state, LoadingAction action) {
  return state.copyWith(
      loadingMessage: action.message,
      loadingError: action.message,
      loadingStatus: action.status);
}

NotificationStatisticsState _getInitialData(
    NotificationStatisticsState state, GetInitialDataAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    notificationObj: action.notificationObj,
    reportObjList: action.reportObjList,
    userList: action.userList,
  );
}

NotificationStatisticsState _onChangeSortAction(
    NotificationStatisticsState state, ChangeSorting action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      selectedSortBccId: action.sortBccId);
}

NotificationStatisticsState _saveSortType(
    NotificationStatisticsState state, OnSaveBccModel action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      sortType: action.sortType);
}

NotificationStatisticsState _clearSortType(
    NotificationStatisticsState state, ClearSortAtUser action) {
  return NotificationStatisticsState.initial().copyWith(
    numberFormatTypeCode: state.numberFormatTypeCode,
    numberTypes: state.numberTypes,
    notificationObj: state.notificationObj,
    reportObjList: state.reportObjList,
    toDate: state.toDate,
    fromDate: state.fromDate,
    selectedFromDate: state.selectedFromDate,
    selectedToDate: state.selectedToDate,
    sortingTypes: state.sortingTypes,
    selectedSortBccId: null,
    sortType: null,
    sortTypeForUserType: state.sortTypeForUserType,
    selectedUser: state.selectedUser,
    selectedReportType: state.selectedReportType,
    selectedNotifType: state.selectedNotifType,
    selectedAccountName: state.selectedAccountName,
    selectedAccountNameId: state.selectedAccountNameId,
    selectedAnalysisCodeId: state.selectedAnalysisCodeId,
    notifiType: state.notifiType,
    reporType: state.reporType,
    voucher: state.voucher,
    voucherTypes: state.voucherTypes,
    // userName: state.userName,
    userList: state.userList,
  );
  // voucher: state.voucher,
  // userName: state.userName,
  // userList: state.userList,
  // selectedUser: state.selectedUser,
  // selectedReportType: "Transaction wise",
  // selectedNotifType: state.selectedNotifType,
  // selectedAccountName: state.selectedAccountName,
  // selectedAccountNameId: state.selectedAccountNameId,
  // selectedAnalysisCodeId: state.selectedAnalysisCodeId,
  // notifiType: state.notifiType,
  // reporType: state.reporType,
  // initReportTypeId: state.initReportTypeId);
}

NotificationStatisticsState _sortingAction(
    NotificationStatisticsState state, FetchSortTypes action) {
  List<BCCModel> sortTypeForUserType = [];
  action.sortingTypes.forEach((element) {
    if (element.code.contains("COUNT")) {
      sortTypeForUserType.add(element);
      return sortTypeForUserType;
    }
    print(sortTypeForUserType);
    return sortTypeForUserType;
  });
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      sortingTypes: action.sortingTypes,
      sortTypeForUserType: sortTypeForUserType);
}

NotificationStatisticsState _changedNumberFormatCodeAction(
    NotificationStatisticsState state, ChangeNumberFormatAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      numberFormatTypeCode: action.numberFormatCode);
}

NotificationStatisticsState _changedNumberAction(
    NotificationStatisticsState state, ChangeNumberTypeAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      numberField: action.numberType);
}

NotificationStatisticsState _selectedReportType(
    NotificationStatisticsState state, SelectedReportType action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedReportType: action.reportType,
  );
}

NotificationStatisticsState _selectedNotifType(
    NotificationStatisticsState state, SelectedNotifype action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedNotifType: action.notifType,
  );
}

NotificationStatisticsState _selectedAccountName(
    NotificationStatisticsState state, SelectedAccountname action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedAccountName: action.accountName,
  );
}

NotificationStatisticsState _selectedAccountNameIdFunc(
    NotificationStatisticsState state, SelectedAccountNameIdFunc action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedAccountNameId: action.accountNameId,
  );
}

NotificationStatisticsState _selectedUser(
    NotificationStatisticsState state, SelectedUser action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedUser: action.user,
  );
}

NotificationStatisticsState _selectedUserId(
    NotificationStatisticsState state, SelectedAnalysisCodeId action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedAnalysisCodeId: action.userId,
  );
}

NotificationStatisticsState _selectedToDate(
    NotificationStatisticsState state, SelectedToDate action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      selectedToDate: action.toDate);
}

NotificationStatisticsState _selectedFromDate(
    NotificationStatisticsState state, SelectedFromDate action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedFromDate: action.fromDate,
  );
}

NotificationStatisticsState _getReportData(
    NotificationStatisticsState state, GetReportData action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      notificationDetailModel: action.notificationDataModel);
}

NotificationStatisticsState _saveFilter(
    NotificationStatisticsState state, SaveFilter action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    fromDate: action.fromDate,
    toDate: action.toDate,
    reporType: action.report,
    notifiType: action.notifType,
    userName: action.user,
  );
}

NotificationStatisticsState _clearAction(
    NotificationStatisticsState state, ClearAction action) {
  return NotificationStatisticsState.initial();
}

NotificationStatisticsState _onClearInitialNumberType(
    NotificationStatisticsState state, OnClearInitialNumberTypeAction action) {
  return NotificationStatisticsState.initial().copyWith(
    numberFormatTypeCode: null,
    numberTypes: state.numberTypes,
    notificationObj: state.notificationObj,
    reportObjList: state.reportObjList,
    toDate: state.toDate,
    fromDate: state.fromDate,
    selectedFromDate: state.selectedFromDate,
    selectedToDate: state.selectedToDate,
    sortingTypes: state.sortingTypes,
    selectedUser: state.selectedUser,
    sortTypeForUserType: state.sortTypeForUserType,
    selectedReportType: state.selectedReportType,
    selectedNotifType: state.selectedNotifType,
    selectedAccountName: state.selectedAccountName,
    selectedAccountNameId: state.selectedAccountNameId,
    selectedAnalysisCodeId: state.selectedAnalysisCodeId,
    notifiType: state.notifiType,
    reporType: state.reporType,
    initReportTypeId: state.initReportTypeId,
    voucher: state.voucher,
    voucherTypes: state.voucherTypes,
    // userName: state.userName,
    // userList: state.userList,
  );

  // userName: state.userName,
  // userList: state.userList,
  // selectedUser: state.selectedUser,
  // selectedReportType: "Transaction wise",
  // selectedNotifType: state.selectedNotifType,
  // selectedAccountName: state.selectedAccountName,
  // selectedAccountNameId: state.selectedAccountNameId,
  // selectedAnalysisCodeId: state.selectedAnalysisCodeId,
  // notifiType: state.notifiType,
  // reporType: state.reporType,
  // initReportTypeId: state.initReportTypeId
  // );
}

NotificationStatisticsState _accountFlag(
    NotificationStatisticsState state, AccountFlag action) {
  return state.copyWith(accountFlag: action.flag);
}

NotificationStatisticsState _fetchInitialCofig(
    NotificationStatisticsState state, FetchInitialCofig action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    voucherTypes: action.voucherTypes,
    numberTypes: action.numberTypes,
    // sortingTypes: action.sortingTypes
  );
}

NotificationStatisticsState _selectedVoucher(
    NotificationStatisticsState state, SelectedVoucher action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    voucher: action.voucher,
  );
}

NotificationStatisticsState _selectedCount(
    NotificationStatisticsState state, SelectedCountAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    count: action.count,
  );
}

NotificationStatisticsState _resetfilter(
    NotificationStatisticsState state, Resetfilter action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    voucher: null,
    count: null,
  );
}

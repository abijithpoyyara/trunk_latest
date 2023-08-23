import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:intl/intl.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_detail_data_model.dart';
import 'package:redstars/src/services/model/response/notification_statistics_report/notification_statistics_object_model.dart';
import 'package:redstars/src/services/repository/notification_statistics_report/notification_statistics_repository.dart';
import 'package:redux_thunk/redux_thunk.dart';

class GetInitialDataAction {
  List<NotificationStatisticsObject> notificationObj;
  List<NotificationStatisticeReportObject> reportObjList;
  List<NotificationStatisticeUserList> userList;

  GetInitialDataAction(
    this.notificationObj,
    this.reportObjList,
    this.userList,
  );
}

class SelectedReportType {
  String reportType;

  SelectedReportType(this.reportType);
}

class AccountFlag {
  bool flag;

  AccountFlag(this.flag);
}

class SelectedAccountNameIdFunc {
  int accountNameId;

  SelectedAccountNameIdFunc(this.accountNameId);
}

class ChangeNumberFormatAction {
  BCCModel numberFormatCode;
  ChangeNumberFormatAction(this.numberFormatCode);
}

class SelectedAccountname {
  String accountName;

  SelectedAccountname(this.accountName);
}

class SelectedUser {
  String user;

  SelectedUser(this.user);
}

class SelectedAnalysisCodeId {
  int userId;

  SelectedAnalysisCodeId(this.userId);
}

class SelectedNotifype {
  String notifType;

  SelectedNotifype(this.notifType);
}

class SelectedToDate {
  String toDate;

  SelectedToDate(this.toDate);
}

class SelectedVoucher {
  String voucher;

  SelectedVoucher(this.voucher);
}

class FetchSortTypes {
  List<BCCModel> sortingTypes;
  FetchSortTypes({this.sortingTypes});
}

class SelectedCountAction {
  String count;

  SelectedCountAction(this.count);
}

class ChangeNumberTypeAction {
  int numberType;
  ChangeNumberTypeAction(this.numberType);
}

class Resetfilter {}

class SelectedFromDate {
  String fromDate;

  SelectedFromDate(this.fromDate);
}

class GetReportData {
  NotificationStatisticsDetailDataModel notificationDataModel;

  GetReportData(this.notificationDataModel);
}

class SaveFilter {
  String report;
  String notifType;
  String user;
  String fromDate;
  String toDate;

  SaveFilter(
      {this.report, this.notifType, this.user, this.fromDate, this.toDate});
}

class OnClearInitialNumberTypeAction {}

class ClearAction {
  ClearAction();
}

class OnSaveBccModel {
  BCCModel sortType;
  OnSaveBccModel(this.sortType);
}

class ClearSortAtUser {}

class FetchInitialCofig {
  List<BCCModel> voucherTypes;
  List<BCCModel> numberTypes;
  List<BCCModel> sortingTypes;
  FetchInitialCofig({this.voucherTypes, this.numberTypes, this.sortingTypes});
}

class ChangeSorting {
  int sortBccId;
  ChangeSorting({this.sortBccId});
}

ThunkAction fetchInitialData() {
  DateTime currentDate = DateTime.now();
  DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String formattedCurrent = formatter.format(currentDate);
  String formattedStart = formatter.format(startDate);
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading, message: "Fetching Details"));
    });
    NotificationStatisticsRepository().getInitialData(
        onRequestSuccess: (objResult, statsResult, userResult) => {
              store.dispatch(
                  GetInitialDataAction(objResult, statsResult, userResult)),
            },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error,
              message: error.toString(),
            )));
  };
}

ThunkAction fetchSortListData() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      NotificationStatisticsRepository().getSortList(
          onRequestSuccess: ({
            List<BCCModel> sortingTypes,
          }) =>
              store.dispatch(FetchSortTypes(sortingTypes: sortingTypes)),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: error.toString())));
    });
  };
}

ThunkAction fetchVoucherInitialData() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      NotificationStatisticsRepository().getInitialConfigs(
          onRequestSuccess: ({
            List<BCCModel> voucherTypes,
            List<BCCModel> numberTypes,
            List<BCCModel> sortingTypes,
          }) =>
              store.dispatch(FetchInitialCofig(
                  voucherTypes: voucherTypes,
                  numberTypes: numberTypes,
                  sortingTypes: sortingTypes)),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: error.toString())));
    });
  };
}

ThunkAction fetchReportData(
    {String Voucher,
    String count,
    String fromDate,
    String toDate,
    int start,
    int limit,
    int reportId,
    int notifId,
    int userId,
    int accountId,
    int sortBccId,
    List<NotificationStatisticsDetailData> listData,
    int numberFieldId}) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading, message: "Fetching Details"));
    });
    NotificationStatisticsRepository().getReportData(
        voucher: Voucher,
        count: count,
        fromDate: fromDate,
        toDate: toDate,
        start: start,
        limit: limit,
        reportId: reportId,
        notifId: notifId,
        userId: userId,
        accountId: accountId,
        numberFieldId: numberFieldId,
        sortByBccId: sortBccId,
        onRequestSuccess: (result) => {
              listData?.addAll(result.notificationDetailData),
              store.dispatch(GetReportData(result)),
            },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error, message: error.toString())));
  };
}

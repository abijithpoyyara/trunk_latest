import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/notifications/notifications_model.dart';
import 'package:redstars/src/services/repository/notifications/notifications_repository.dart';
import 'package:redux_thunk/redux_thunk.dart';



class NotificationGeneratedReportDataAction {
 final  List<NotificationDisplayListData> notificationReportData;

 NotificationGeneratedReportDataAction(this.notificationReportData);
}

ThunkAction fetchNotificationReportList() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      NotificationGeneratedRepository().generatedNotificationData(
          onRequestSuccess: (data) {
            store.dispatch(NotificationGeneratedReportDataAction(data
            ));

          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error,
              message: error.toString())));
    });
  };
}

ThunkAction fetchDataFromNotificationList() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      NotificationGeneratedRepository().getDataFromNotification(
          onRequestSuccess: (data) => store.dispatch(NotificationGeneratedReportDataAction(data
          )),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error,
              message: error.toString())));
    });
  };
}





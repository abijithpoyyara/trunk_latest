import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/notifications/notification_actions.dart';
import 'package:redstars/src/redux/states/notifications/notictions_state.dart';



final notificationsReducer = combineReducers<NotificationDataState>([
  TypedReducer<NotificationDataState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<NotificationDataState, NotificationGeneratedReportDataAction>(_notificationDetailFetchAction),
 
]);

NotificationDataState _changeLoadingStatusAction(
    NotificationDataState state, LoadingAction action) {
  return state.copyWith(
    loadingStatus: action.status,
    loadingMessage: action.message,
    loadingError: action.message,
  );
}

NotificationDataState _notificationDetailFetchAction(
    NotificationDataState state, NotificationGeneratedReportDataAction action) {
  print(action.notificationReportData.length);
  return state.copyWith(loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      notificationReportData:action.notificationReportData,
  );
}


import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/notifications/notification_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/notifications/notictions_state.dart';
import 'package:redstars/src/services/model/response/notifications/notifications_model.dart';


class NotificationGeneratedViewModel extends BaseViewModel {
  final int optionId;
  final List<NotificationDisplayListData>
  notificationDetailListData;
  final Function()onRefreshNotificationData;

  var scrollPosition;


  NotificationGeneratedViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,

    this.optionId,
    this.notificationDetailListData,
    this.onRefreshNotificationData,
    this.scrollPosition
  }) : super(
    loadingStatus: loadingStatus,
    loadingMessage: loadingMessage,
    loadingError: errorMessage,
  );

  factory NotificationGeneratedViewModel.fromStore(
      Store<AppState> store) {
    NotificationDataState state=store.state.notificationDataState;
    int optionId = store.state.homeState.selectedOption?.optionId;

    return NotificationGeneratedViewModel(
        loadingStatus: state.loadingStatus,
        errorMessage: state.loadingError,
        loadingMessage: state.loadingMessage,
        optionId: optionId,
      notificationDetailListData: state.notificationReportData,
      onRefreshNotificationData: () {
          store.dispatch(fetchNotificationReportList());
      }

        );
  }
}

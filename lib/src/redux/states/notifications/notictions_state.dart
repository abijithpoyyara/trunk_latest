import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/notifications/notifications_model.dart';


class NotificationDataState extends BaseState {
  final List<NotificationDisplayListData> notificationReportData;
  final List<NotificationDisplayListData> data;


  NotificationDataState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,

    this.notificationReportData,
    this.data,

  }) : super(
      loadingStatus: loadingStatus,
      loadingError: loadingError,
      loadingMessage: loadingMessage);

  NotificationDataState copyWith({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    List<NotificationDisplayListData> notificationReportData,
    List<NotificationDisplayListData> data,

  }) {
    return NotificationDataState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        loadingError: loadingError ?? this.loadingError,
      notificationReportData: notificationReportData ?? this.notificationReportData,
      data: data ?? this.data,

    );
  }

  factory NotificationDataState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);

    return NotificationDataState(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
      notificationReportData: List(),
      data: null,
    );
  }
}

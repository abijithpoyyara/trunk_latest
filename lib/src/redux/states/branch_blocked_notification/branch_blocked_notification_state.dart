import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/branch_bolocked_notification/branch_blocked_notification_model.dart';



class BlockedNotificationState extends BaseState {
final BlockedNotificationModel blockedNotificationData;




  BlockedNotificationState({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,

this.blockedNotificationData,


  }) : super(
    loadingMessage: loadingMessage,
    loadingError: loadingError,
    loadingStatus: loadingStatus,
  );

  BlockedNotificationState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    BlockedNotificationModel blockedNotificationData,


  }) {
    return BlockedNotificationState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingError: loadingError,
      loadingMessage: loadingMessage,
        blockedNotificationData:blockedNotificationData ??this.blockedNotificationData,



    );
  }

  factory BlockedNotificationState.initial() {
    return BlockedNotificationState(
      loadingStatus: LoadingStatus.success,
      loadingError: '',
      loadingMessage: '',
        blockedNotificationData:null

    );
  }
}
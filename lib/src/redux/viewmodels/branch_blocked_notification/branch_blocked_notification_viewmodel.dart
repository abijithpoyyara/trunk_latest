import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/branch_blocked_notification/branch_blocked_notification_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/branch_bolocked_notification/branch_blocked_notification_model.dart';

class BlockedNotificationViewmodel extends BaseViewModel {
  final BlockedNotificationModel blockedNotificationData;
  final Function() run;
  final int optionId;

  BlockedNotificationViewmodel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    this.blockedNotificationData,
    this.run,
  this.optionId,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  factory BlockedNotificationViewmodel.fromStore(Store<AppState> store) {
    final state = store.state.blockedNotificationState;
    int optionid = store.state.homeState.selectedOption.optionId;
    String loginUser = store.state.homeState.user.userName;
    return BlockedNotificationViewmodel(
      loadingStatus: state.loadingStatus,
      loadingError: state.loadingError,
      loadingMessage: state.loadingMessage,
      blockedNotificationData: state.blockedNotificationData,
      run: () {
        store.dispatch(fetchBlockedNotification());

      },
      optionId: optionid,
    );
  }
}

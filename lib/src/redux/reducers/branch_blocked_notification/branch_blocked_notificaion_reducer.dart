

import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/branch_blocked_notification/branch_blocked_notification_action.dart';
import 'package:redstars/src/redux/states/branch_blocked_notification/branch_blocked_notification_state.dart';


final blockedNotificationReducer = combineReducers<BlockedNotificationState>([
  TypedReducer<BlockedNotificationState, LoadingAction>(
      _changeLoadingStatusAction),
  TypedReducer<BlockedNotificationState, BlockNotificationAction>(
      _blocknotification),



]);
BlockedNotificationState _changeLoadingStatusAction(
    BlockedNotificationState state, LoadingAction action) {
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message);
}
BlockedNotificationState _blocknotification(
    BlockedNotificationState state, BlockNotificationAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      blockedNotificationData: action.blockedNotificationResult);
}
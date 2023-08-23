
import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/branch_bolocked_notification/branch_blocked_notification_model.dart';
import 'package:redstars/src/services/repository/branch_blocking_notification/branch_blocking_noti_repository.dart';
import 'package:redux_thunk/redux_thunk.dart';


class BlockNotificationAction {
  BlockedNotificationModel blockedNotificationResult;
  BlockNotificationAction(this.blockedNotificationResult);
}




ThunkAction fetchBlockedNotification({
int clientId,int branchId
//  TransactionReqHeadingList tableModelList,
  // PendingTransactionDetailModelList dtlModelList,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));
      BlockingNotifiRepository().getBlockedNotification(

        onRequestSuccess: (documentResponse) => store
            .dispatch(new BlockNotificationAction(documentResponse)),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error,
            message: error.toString())),
      );
    });
  };
}
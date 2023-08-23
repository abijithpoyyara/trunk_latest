import 'dart:developer';

import 'package:base/constants.dart';
import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/repository/document_approval/document_approval_repository.dart';

import '../../../../utility.dart';
import 'document_approval_action.dart';

class TransactionFetchSuccessAction {
  TransactionTypeModel documentResponse;
  int statusCode;
  TransactionFetchSuccessAction(this.documentResponse, this.statusCode);
}

class DAInitAction {
  VoidCallback isSuperUser;
  VoidCallback isStandardUser;

  DAInitAction({this.isSuperUser, this.isStandardUser});
}

class UserTypeAction {
  bool isSuperUser;

  UserTypeAction({this.isSuperUser});
}

class SummaryClearAction {}

class BranchListFetchAction {
  List<BranchList> branchList;

  BranchListFetchAction(this.branchList);
}

class BranchSelectAction {
  BranchList selectedBranch;

  BranchSelectAction(this.selectedBranch);
}

class GetNotificationCount {
  List<NotificationCountDetails> notificationCountDetails;
  GetNotificationCount(this.notificationCountDetails);
}


class SelectBranchId{
  int branchId;
  SelectBranchId({this.branchId});
}


ThunkAction fetchInitialList({int branchId}) {
  return (Store store) async {
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int optionId = store.state.homeState.selectedOption.optionId;

    Future(() async {
      store.dispatch(DAInitAction(isStandardUser: () {
        store.dispatch(UserTypeAction(isSuperUser: false));
      }, isSuperUser: () {
        store.dispatch(UserTypeAction(isSuperUser: true));
      }));
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading,
          message: "Getting Transactions",
          type: DocumentApprovalAction.HOME_SCREEN));
      DocumentApprovalRepository().getTransactionList(
        selectedBranchId: branchId,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: DocumentApprovalAction.HOME_SCREEN)),
          onRequestSuccess: (response, statusCode) => store
              .dispatch(TransactionFetchSuccessAction(response, statusCode)));
      DocumentApprovalRepository().getNotificationCount(
        selectedBranchId: branchId,
          clientId: clientId,
          userId: userId,
          optionID: optionId,
          onRequestSuccess: (response) =>
              store.dispatch(GetNotificationCount(response)),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: DocumentApprovalAction.HOME_SCREEN)));
      DocumentApprovalRepository().getBranchList(
          onRequestSuccess: (response) =>
              store.dispatch(BranchListFetchAction(response.branchList)),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: DocumentApprovalAction.HOME_SCREEN)));
    });
  };
}

ThunkAction fetchNotificationCount({int userid, String clientid}) {
  return (Store store) async {
    new Future(() async {
      String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
      int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
// store.dispatch(//new LoadingAction(status: LoadingStatus.loading, message: "Loading"));// store.dispatch(SignInAction(loginModel));
      BaseUserRepository().getNotificationCount(
          clientId: clientid ?? clientId,
          userId: userid ?? userId,
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(new NotificationCountAction(response)));
    });
  };
}

ThunkAction fetchTransactionsTypeList(BranchList selectedBranch) {
  return (Store store) async {
    Future(() async {
      store.dispatch(BranchSelectAction(selectedBranch));
      log("unknown call from here");
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading,
          message: "Getting Transactions",
          type: DocumentApprovalAction.HOME_SCREEN));

      DocumentApprovalRepository().getTransactionList(
          selectedBranchId: selectedBranch.id,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: DocumentApprovalAction.HOME_SCREEN)),
          onRequestSuccess: (response, statusCode) => store
              .dispatch(TransactionFetchSuccessAction(response, statusCode)));
    });
  };
}

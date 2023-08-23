import 'package:base/redux.dart';
import 'package:base/utility.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_history.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_status.dart';
import 'package:redstars/src/services/repository/document_approval/document_approval_repository.dart';

import 'document_approval_action.dart';

class ListHistoryFetchSuccessAction {
  List<TransactionHistoryList> transactionHistoryList;

  ListHistoryFetchSuccessAction(this.transactionHistoryList);
}

class ListApprovalsFetchSuccessAction {
  List<TransactionApprovalList> transactionApprovalList;

  ListApprovalsFetchSuccessAction(this.transactionApprovalList);
}

class TransactionStatusSuccessAction {
  Map<int, List<AppTreeModel>> transactionMap;

  TransactionStatusSuccessAction(this.transactionMap);
}

ThunkAction fetchTransactionsHistory({int optionId, int dataId}) {
  return (Store store) async {
    Future(() async {
      print("starting transaction history fetch");
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading,
          message: "Getting Transations History",
          type: DocumentApprovalAction.RELATION_SCREEN));
      DocumentApprovalRepository().getTransactionTracking(
          optionId: optionId,
          dataId: dataId,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: DocumentApprovalAction.RELATION_SCREEN)),
          onRequestSuccess: (response) =>
              store.dispatch(ListHistoryFetchSuccessAction(response)));
    });
  };
}

ThunkAction fetchTransactionsApprovals(
    {int dataId, int optionId, int tableId}) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading,
          message: "Getting Transactions Approvals",
          type: DocumentApprovalAction.RELATION_SCREEN));
      DocumentApprovalRepository().getTransactionsApprovals(
          dataId: dataId,
          optionId: optionId,
          tableId: tableId,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: DocumentApprovalAction.RELATION_SCREEN)),
          onRequestSuccess: (response) =>
              store.dispatch(ListApprovalsFetchSuccessAction(response)));
    });
  };
}

ThunkAction fetchTransactionStatusList(
    {@required TransactionDetails transaction, @required int optionId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading,
          message: "Loading List",
          type: DocumentApprovalAction.RELATION_SCREEN));
      DocumentApprovalRepository().getTransactionStatus(
        transactionId: transaction.refTableDataId,
        optionId: optionId,
        onRequestSuccess: (documentResponse) => store.dispatch(
            new TransactionStatusSuccessAction(
                _parseTransactionStatus(documentResponse))),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
            type: DocumentApprovalAction.RELATION_SCREEN)),
      );
    });
  };
}

Map<int, List<AppTreeModel>> _parseTransactionStatus(
    List<TransactionStatus> documentResponse) {
  Map<int, List<AppTreeModel>> treeModel = Map();

  documentResponse.forEach((element) {
    int key = element.parentId;
    if (treeModel.containsKey(key)) {
      List<AppTreeModel> childs = treeModel[key];
      childs.add(AppTreeModel(
          id: element.id,
          parentId: element.parentId,
          title: element.name,
          subTitle: element.transactionNo,
          isLeaf: element.leafYN,
          isExpanded: element.expanded,
          data: element.leafYN ? element.toMap() : null));
      treeModel[key] = childs;
    } else {
      List<AppTreeModel> childs = List();
      childs.add(AppTreeModel(
          id: element.id,
          parentId: element.parentId,
          title: element.name,
//          subTitle: element.transactionNo,
          isLeaf: element.leafYN,
          isExpanded: element.expanded,
          data: element.leafYN ? element.toMap() : null));
      treeModel[key] = childs;
    }
  });

  return treeModel;
}

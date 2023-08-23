import 'package:base/redux.dart';
import 'package:base/utility.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_action.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_history_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/document_approval/document_approval_state.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_history.dart';

class DocumentApprHistoryViewModel extends BaseViewModel {
  final TransactionTypes transaction;
  final Map<int, List<AppTreeModel>> tranactionStatus;
  final List<TransactionHistoryList> transactionHistories;
  final List<TransactionApprovalList> transactionApprovals;

  final Function({int dataId, int tableId, int optionId}) onRelationItemSelect;

  DocumentApprHistoryViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.transaction,
    this.tranactionStatus,
    this.transactionApprovals,
    this.transactionHistories,
    this.onRelationItemSelect,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory DocumentApprHistoryViewModel.fromStore(Store<AppState> store) {
    DAHistoryState state = store.state.docApprovalState.historyState;

    return DocumentApprHistoryViewModel(
        loadingStatus: state.loadingStatus,
        errorMessage: state.loadingError,
        loadingMessage: state.loadingMessage,
        tranactionStatus: state.transactionStatus,
        transactionHistories: state.transactionHistories,
        transactionApprovals: state.transactionApprovals,
        onRelationItemSelect: ({int dataId, int tableId, int optionId}) => {
              store.dispatch(
                  fetchTransactionsHistory(optionId: optionId, dataId: dataId)),
              store.dispatch(fetchTransactionsApprovals(
                  dataId: dataId, optionId: optionId, tableId: tableId)),
            });
  }
}

import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_action.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_summary_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/document_approval/document_approval_state.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';

class DocumentApprSummaryViewModel extends BaseViewModel {
  final bool isSuperUser;
  final List<TransactionTypes> transactionTypeList;
  final Future<void> Function(int branchId) refreshList;
  final Future<void> Function(int branchId) loadTransactions;
  final Function(TransactionTypes ) onTransactionSelected;
  final List<BranchList> branchList;
  final BranchList selectedBranch;
  final Function(BranchList) fetchTransactions;

  final Function(int branchId) setBranchId;

  final List<NotificationCountDetails> notificationDetails;
  final int statusCode;

  final int branchId;

  final Function(BranchList) selectBranchList;

  DocumentApprSummaryViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.isSuperUser,
    this.transactionTypeList,
    this.refreshList,
    this.branchList,
    this.selectedBranch,
    this.onTransactionSelected,
    this.fetchTransactions,
    this.notificationDetails,
    this.statusCode,
    this.branchId,
    this.setBranchId,
    this.loadTransactions,
    this.selectBranchList
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory DocumentApprSummaryViewModel.fromStore(Store<AppState> store) {
    DASummaryState state = store.state.docApprovalState.summaryState;

    return DocumentApprSummaryViewModel(
      loadingStatus: state.loadingStatus,
      errorMessage: state.loadingError,
      loadingMessage: state.loadingMessage,
      transactionTypeList: state.transactionTypeList,
      notificationDetails: state.notificationDetails,
      isSuperUser: state.isSuperUser,
      branchList: state.branchList,
      selectedBranch: state.selectedBranch,
      statusCode: state.statusCode,
      branchId: state.branchId,
      setBranchId: (branchId){
        store.dispatch(SelectBranchId(branchId: branchId));
      },
      selectBranchList: (selectedBranch){
        store.dispatch(BranchSelectAction(selectedBranch));
      },
      fetchTransactions: (branch) =>
          store.dispatch(fetchTransactionsTypeList(branch)),
      refreshList: (branchid) => store.dispatch(fetchInitialList(branchId: branchid)),
      loadTransactions: (branchid) => store.dispatch(fetchInitialList(branchId: branchid)),
      onTransactionSelected: (transactionType) => store.dispatch(
          TransactionTypeSelectedAction(
              transaction: transactionType,
              approvalTypes: state.approvalTypes)),
    );
  }
}

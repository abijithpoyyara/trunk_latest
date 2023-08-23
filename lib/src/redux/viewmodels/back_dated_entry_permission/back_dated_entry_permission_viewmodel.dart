import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/actions/back_dated_entry_permission/back_dated_entry_permission_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_date_view_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_dated_entry_detail_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/sactioned_options_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_entry_view/model/back_date_sub_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/filter_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/initial_model.dart';

class BackDatedEntryViewModel extends BaseViewModel {
  final AddOptionModel optionList;
  final AddBranchModel branchList;
  final AddUserListModel userList;
  final int optionId;
  final Function(String branchName) setOptionName;
  final Function(String branchName) setBranchName;
  final Function(List<dynamic> userList) setUserList;
  final Function(SanctionedOptionsModel) addSanctionedModelFunc;
  final Function(BackDatedEntryViewModel viewModel, DateTime periodFrom,
      DateTime periodTo, DateTime validTo, BackDateEntryDetailModel) onSave;
  final Function(
    BackDatedEntryViewModel viewModel,
    DateTime periodFrom,
    DateTime periodTo,
    DateTime validTo,
  ) onEditSave;
  final Function(int branchId, int optionId) getUserList;
  final String selectedBranchName;
  final String selectedOptionName;
  final List<dynamic> selectedUsers;
  final List<SanctionedOptionsModel> sanctionedList;
  final double scrollPosition;
  final BackDateEntryDetailModel dtlModel;
  final bool isSaved;
  final bool isEditSaved;
  final Function() onClear;
  final int isEdited;
  final BackDateInitialModel backDateInitialModel;
  final BackDateFilterModel backDateFilterModel;
  final Function(BackDateFilterModel model) onSaveFilter;
  final Function(BackDateFilterModel data) onChangeViewData;
  final Function(BackDateInitialModel data) onChangeDates;
  final Function(DateTime data) onChangePeriodFrom;
  final Function(DateTime data) onChangePeriodTo;
  final Function(DateTime data) onChangePeriodValidUpto;
  final DateTime periodFrom;
  final DateTime periodTo;
  final DateTime validUpto;
  final List<BackDateEntrySubModel> backDatedEntrySanctionedData;
  final ValueSetter<BackDateEntrySubModel> onRemoveItem;
  final Function(BackDateEntrySubModel, int) onAdd;
  final Function(BackDateEntrySubModel) onModelSave;
  final Function(BackDateViewDetails) getDetailViewList;
  final BackDateEntrySubModel model;
  BackDatedEntryViewModel(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      String loadingError,
      this.optionList,
      this.branchList,
      this.setBranchName,
      this.optionId,
      this.selectedBranchName,
      this.getUserList,
      this.userList,
      this.sanctionedList,
      this.setOptionName,
      this.selectedOptionName,
      this.selectedUsers,
      this.setUserList,
      this.addSanctionedModelFunc,
      this.scrollPosition,
      this.dtlModel,
      this.onSave,
      this.isEditSaved,
      this.isSaved,
      this.onClear,
      this.backDateFilterModel,
      this.onChangeViewData,
      this.onSaveFilter,
      this.onChangeDates,
      this.backDateInitialModel,
      this.periodTo,
      this.isEdited,
      this.periodFrom,
      this.validUpto,
      this.onChangePeriodFrom,
      this.onChangePeriodTo,
      this.onEditSave,
      this.backDatedEntrySanctionedData,
      this.onChangePeriodValidUpto,
      this.onAdd,
      this.model,
      this.onModelSave,
      this.getDetailViewList,
      this.onRemoveItem})
      : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  factory BackDatedEntryViewModel.fromStore(Store<AppState> store) {
    final state = store.state.backDatedEntryState;
    int optionId = store.state.homeState.selectedOption?.optionId;
    return BackDatedEntryViewModel(
        loadingStatus: state.loadingStatus,
        loadingError: state.loadingError,
        loadingMessage: state.loadingMessage,
        optionList: state.optionList,
        branchList: state.branchList,
        userList: state.userList,
        optionId: optionId,
        isEdited: state.isEdited,
        backDatedEntrySanctionedData: state.backDatedEntrySanctionedData,
        selectedBranchName: state.selectedBranchName,
        sanctionedList: state.sanctionedList,
        selectedOptionName: state.selectedOptionName,
        selectedUsers: state.selectedUserList,
        scrollPosition: state.scrollPosition,
        dtlModel: state.dtlModel,
        isSaved: state.saved,
        isEditSaved: state.isEditSaved,
        validUpto: state.validUpto,
        periodFrom: state.periodFrom,
        periodTo: state.periodTo,
        model: state.model,
        backDateInitialModel: state.backDateInitialModel,
        backDateFilterModel: state.backDateFilterModel,
        onChangePeriodFrom: (pf) {
          store.dispatch(ChangePeriodFrom(pf));
        },
        onChangePeriodTo: (pt) {
          store.dispatch(ChangePeriodTo(pt));
        },
        onChangePeriodValidUpto: (vu) {
          store.dispatch(ChangeValidUpto(vu));
        },
        getDetailViewList: (dtl) {
          store.dispatch(fetchBackDetailView(dtl: dtl));
        },
        onChangeDates: (dates) {
          store.dispatch(FetchInitialData(BackDateInitialModel(
              periodTo: dates.periodTo,
              periodFrom: dates.periodFrom,
              validUpto: dates.validUpto)));
        },
        onClear: () {
          store.dispatch(OnClearFunction());
        },
        setBranchName: (branch) {
          store.dispatch(SetBranchNameAction(branch));
        },
        onSave: (
          viewModel,
          periodFrom,
          periodTo,
          validTo,
          detail,
        ) {
          store.dispatch(onSaveFunc(
            viewModel: viewModel,
            periodFrom: periodFrom,
            periodTo: periodTo,
            validTo: validTo,
            detail: detail,
          ));
        },
        onEditSave: (viewModel, periodFrom, periodTo, validTo) {
          store.dispatch(onEditSaveFunc(
            viewModel: viewModel,
            periodFrom: periodFrom,
            periodTo: periodTo,
            validTo: validTo,
          ));
        },
        addSanctionedModelFunc: (branch) {
          store.dispatch(AddSanctionModelFunc(branch));
        },
        setOptionName: (branch) {
          store.dispatch(SetOptionNameAction(branch));
        },
        setUserList: (branch) {
          store.dispatch(SetUserListAction(branch));
        },
        getUserList: (branchId, optionId) {
          store.dispatch(fetchUserList(
            branchId: branchId,
            optionId: optionId,
          ));
        },
        onModelSave: (model) =>
            store.dispatch(BackDateEntryModelSaveAction(model)),
        onRemoveItem: (item) => store.dispatch(RemoveOptionAction(item)),
        onAdd: (model, index) =>
            store.dispatch(AddNewOptionAction(model, index)),
        onSaveFilter: (model) {
          store.dispatch(BackDateFilterChangeAction(model));
        },
        onChangeViewData: (model) {
          store.dispatch(fetchBackDateView(backDateFilterModel: model));
        });
  }
}

import 'package:base/redux.dart';
import 'package:redstars/src/redux/viewmodels/back_dated_entry_permission/back_dated_entry_permission_viewmodel.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_date_view_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_dated_entry_detail_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/sactioned_options_model.dart';
import 'package:redstars/src/services/repository/back_dated_entry_permission/back_dated_entry_permission_repository.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_entry_view/model/back_date_sub_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/filter_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/initial_model.dart';

class FetchOptionList {
  final AddOptionModel list;
  FetchOptionList(this.list);
}

class AddNewOptionAction {
  int updateIndex;
  BackDateEntrySubModel item;

  AddNewOptionAction(this.item, this.updateIndex);
}

class RemoveOptionAction {
  BackDateEntrySubModel item;

  RemoveOptionAction(this.item);
}

class FetchBranchList {
  final AddBranchModel list;
  FetchBranchList(this.list);
}

class FetchUserList {
  final AddUserListModel list;
  FetchUserList(this.list);
}

class SetBranchNameAction {
  final String branchName;
  SetBranchNameAction(this.branchName);
}

class AddSanctionModelFunc {
  final SanctionedOptionsModel branchName;
  AddSanctionModelFunc(this.branchName);
}

class SetOptionNameAction {
  final String optionName;
  SetOptionNameAction(this.optionName);
}

class BackDateEntryModelSaveAction {
  final BackDateEntrySubModel model;

  BackDateEntryModelSaveAction(this.model);
}

class OnClearFunction {}

class SetUserListAction {
  final List<dynamic> userList;
  SetUserListAction(this.userList);
}

class FetchViewList {
  final List<BackDateViewDetails> backDatedViewModel;
  FetchViewList(this.backDatedViewModel);
}

class FetchBackDetailView {
  final BackDateEntryDetailModel dtlList;
  FetchBackDetailView(this.dtlList);
}

class BackDateFilterChangeAction {
  final BackDateFilterModel backDateFilterModel;
  BackDateFilterChangeAction(this.backDateFilterModel);
}

class FetchInitialData {
  final BackDateInitialModel backDateInitialModel;

  FetchInitialData(this.backDateInitialModel);
}

class ChangePeriodFrom {
  final DateTime periodFrom;

  ChangePeriodFrom(this.periodFrom);
}

class ChangePeriodTo {
  final DateTime periodTo;

  ChangePeriodTo(this.periodTo);
}

class ChangeValidUpto {
  final DateTime validUpto;

  ChangeValidUpto(this.validUpto);
}

class SaveAction {}

class EditSaveAction {}

ThunkAction fetchOptions() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));
      BackDatedEntryRepository().getOptions(
        onRequestSuccess: (optionsList) =>
            store.dispatch(FetchOptionList(optionsList)),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}

ThunkAction onSaveFunc({
  BackDatedEntryViewModel viewModel,
  BackDateEntryDetailModel detail,
  DateTime periodFrom,
  DateTime periodTo,
  DateTime validTo,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));
      BackDatedEntryRepository().saveFunction(
        periodFrom: periodFrom,
        periodTo: periodTo,
        validTo: validTo,
        detail: detail,
        viewModel: viewModel,
        onRequestSuccess: () => store.dispatch(SaveAction()),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}

ThunkAction onEditSaveFunc({
  BackDatedEntryViewModel viewModel,
  DateTime periodFrom,
  DateTime periodTo,
  DateTime validTo,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));
      BackDatedEntryRepository().editSaveFunction(
        periodFrom: periodFrom,
        periodTo: periodTo,
        validTo: validTo,
        viewModel: viewModel,
        onRequestSuccess: () => store.dispatch(EditSaveAction()),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}

ThunkAction fetchBackDateView({
  BackDateFilterModel backDateFilterModel,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));
      BackDatedEntryRepository().getBacDateViewDtlList(
        start: 0,
        backDateFilterModel: backDateFilterModel,
        onRequestSuccess: (optionsList) =>
            store.dispatch(FetchViewList(optionsList)),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}

ThunkAction fetchBackDetailView({
  BackDateViewDetails dtl,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));
      BackDatedEntryRepository().getBackDateViewDetail(
        dtl: dtl,
        onRequestSuccess: (optionsList) =>
            store.dispatch(FetchBackDetailView(optionsList)),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}

ThunkAction fetchBranch() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));
      BackDatedEntryRepository().getBranch(
        onRequestSuccess: (branchList) =>
            store.dispatch(FetchBranchList(branchList)),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}

ThunkAction fetchUserList({int optionId, int branchId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));
      BackDatedEntryRepository().getUserList(
        branchId: branchId,
        optionId: optionId,
        onRequestSuccess: (list) => store.dispatch(FetchUserList(list)),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}

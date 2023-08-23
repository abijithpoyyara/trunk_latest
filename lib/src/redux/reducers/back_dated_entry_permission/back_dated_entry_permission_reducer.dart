import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/back_dated_entry_permission/back_dated_entry_permission_action.dart';
import 'package:redstars/src/redux/states/back_dated_entry_permission/back_dated_entry_permission_state.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/sactioned_options_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_entry_view/model/back_date_sub_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/initial_model.dart';

final backDatedEntryReducer = combineReducers<BackDatedEntryState>([
  TypedReducer<BackDatedEntryState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<BackDatedEntryState, FetchOptionList>(_fetchOptionList),
  TypedReducer<BackDatedEntryState, FetchBranchList>(_fetchBranchList),
  TypedReducer<BackDatedEntryState, SetBranchNameAction>(_setBranchNameAction),
  TypedReducer<BackDatedEntryState, FetchUserList>(_fetchUserList),
  TypedReducer<BackDatedEntryState, SetUserListAction>(_setUserListAction),
  TypedReducer<BackDatedEntryState, SetOptionNameAction>(_setOptionNameAction),
  TypedReducer<BackDatedEntryState, AddSanctionModelFunc>(
      _addSanctionedModelFunc),
  TypedReducer<BackDatedEntryState, FetchViewList>(_fetchViewList),
  TypedReducer<BackDatedEntryState, FetchBackDetailView>(_fetchBackDetailView),
  TypedReducer<BackDatedEntryState, SaveAction>(_saveAction),
  TypedReducer<BackDatedEntryState, EditSaveAction>(_editSaveAction),
  TypedReducer<BackDatedEntryState, OnClearFunction>(_onClearFunction),
  TypedReducer<BackDatedEntryState, BackDateFilterChangeAction>(
      _fetchBackFilter),
  TypedReducer<BackDatedEntryState, FetchInitialData>(_fetchInitialAction),
  TypedReducer<BackDatedEntryState, ChangePeriodFrom>(_changePFAction),
  TypedReducer<BackDatedEntryState, ChangePeriodTo>(_changePTAction),
  TypedReducer<BackDatedEntryState, ChangeValidUpto>(_changeVUAction),
  TypedReducer<BackDatedEntryState, ChangePeriodTo>(_changePTAction),
  TypedReducer<BackDatedEntryState, ChangeValidUpto>(_changeVUAction),
  TypedReducer<BackDatedEntryState, AddNewOptionAction>(_newItemAction),
  TypedReducer<BackDatedEntryState, RemoveOptionAction>(_removeItemAction),
  TypedReducer<BackDatedEntryState, BackDateEntryModelSaveAction>(
      _modelSaveAction),
]);

BackDatedEntryState _changeLoadingStatusAction(
    BackDatedEntryState state, LoadingAction action) {
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message);
}

BackDatedEntryState _fetchBackFilter(
    BackDatedEntryState state, BackDateFilterChangeAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    backDateFilterModel: action.backDateFilterModel,
  );
}

BackDatedEntryState _modelSaveAction(
    BackDatedEntryState state, BackDateEntryModelSaveAction action) {
  print(action.model?.userList?.length ?? 0);
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    model: action.model,
  );
}

BackDatedEntryState _fetchBackDetailView(
    BackDatedEntryState state, FetchBackDetailView action) {
  BackDateEntrySubModel model;
  List<BackDateEntrySubModel> data = [];
  BackDateInitialModel initialModel;

  for (int i = 0; i < action.dtlList.viewList.length; i++) {
    List<AddUserList> users = [];
    for (int j = 0; j < action.dtlList.viewList[i].userList.length; j++) {
      AddUserList user = AddUserList(
          id: action.dtlList.viewList[i].userList[j].userid,
          name: action.dtlList.viewList[i].userList[j].name);
      users.add(user);
    }

    initialModel = BackDateInitialModel(
      periodTo: DateTime.parse(action.dtlList.viewList[i].periodto),
      periodFrom: DateTime.parse(action.dtlList.viewList[i].periodfrom),
      validUpto: DateTime.parse(action.dtlList.viewList[i].validupto),
    );
    // users.addAll(action.dtlList.viewList[i].userList);

    model = BackDateEntrySubModel(
        updatedId: action.dtlList.viewList[i].Id,
        branchName: AddBranchList(
            id: action.dtlList.viewList[i].branchid,
            name: action.dtlList.viewList[i].branchname),
        optionName: AddOptionList(
            id: action.dtlList.viewList[i].refoptionid,
            refoptionId: action.dtlList.viewList[i].Id,
            optionname: action.dtlList.viewList[i].optionname),
        userList: users);
    data.add(model);
  }

  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      backDatedEntrySanctionedData: data,
      isEdited: 1,
      dtlModel: action.dtlList,
      backDateInitialModel: initialModel);
}

BackDatedEntryState _changePFAction(
    BackDatedEntryState state, ChangePeriodFrom action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    periodFrom: action.periodFrom,
  );
}

BackDatedEntryState _changePTAction(
    BackDatedEntryState state, ChangePeriodTo action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    periodTo: action.periodTo,
  );
}

BackDatedEntryState _changeVUAction(
    BackDatedEntryState state, ChangeValidUpto action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    validUpto: action.validUpto,
  );
}

BackDatedEntryState _fetchInitialAction(
    BackDatedEntryState state, FetchInitialData action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    backDateInitialModel: action.backDateInitialModel,
  );
}

BackDatedEntryState _newItemAction(
    BackDatedEntryState state, AddNewOptionAction action) {
  List<BackDateEntrySubModel> items = state.backDatedEntrySanctionedData;

  if (action.updateIndex == null) {
    if (items?.contains(action.item) ?? false) {
      int index = items.indexOf(action.item);
      var updatedItem = items[index];
      updatedItem.optionName = action.item.optionName;
      updatedItem.branchName = action.item.branchName;
      updatedItem.userList = action.item.userList;
      items[index] = updatedItem;
      return state.copyWith(backDatedEntrySanctionedData: items);
    } else
      return state
          .copyWith(backDatedEntrySanctionedData: [action.item, ...items]);
  } else {
    int index = action.updateIndex;
    var updatedItem = items[index];
    updatedItem.optionName = action.item.optionName;
    updatedItem.branchName = action.item.branchName;
    updatedItem.userList = action.item.userList;
    items[index] = updatedItem;
    return state.copyWith(backDatedEntrySanctionedData: items);
  }
}

BackDatedEntryState _removeItemAction(
    BackDatedEntryState state, RemoveOptionAction action) {
  List<BackDateEntrySubModel> items = state.backDatedEntrySanctionedData;

  if (items.contains(action.item)) {
    items.remove(action.item);
    return state.copyWith(backDatedEntrySanctionedData: items);
  }
  return state.copyWith();
}

BackDatedEntryState _onClearFunction(
    BackDatedEntryState state, OnClearFunction action) {
  return BackDatedEntryState.initial()
      .copyWith(branchList: state.branchList, optionList: state.optionList);
}

BackDatedEntryState _fetchViewList(
    BackDatedEntryState state, FetchViewList action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    backDatedViewModel: action.backDatedViewModel,
  );
}

BackDatedEntryState _saveAction(BackDatedEntryState state, SaveAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    saved: true,
  );
}

BackDatedEntryState _editSaveAction(
    BackDatedEntryState state, EditSaveAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    isEditSaved: true,
  );
}

BackDatedEntryState _addSanctionedModelFunc(
    BackDatedEntryState state, AddSanctionModelFunc action) {
  List<SanctionedOptionsModel> list = state.sanctionedList;
  List<SanctionedOptionsModel> newList = [];
  newList.addAll(list);
  newList.forEach((element) {
    if (element.userList.isEmpty || element.userList == null) {
      state.sanctionedList.remove(element);
    }
  });
  newList.add(action.branchName);
  return state.copyWith(
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    sanctionedList: newList,
  );
}

BackDatedEntryState _fetchOptionList(
    BackDatedEntryState state, FetchOptionList action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    optionList: action.list,
  );
}

BackDatedEntryState _fetchBranchList(
    BackDatedEntryState state, FetchBranchList action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      branchList: action.list);
}

BackDatedEntryState _fetchUserList(
    BackDatedEntryState state, FetchUserList action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    userList: action.list,
  );
}

BackDatedEntryState _setBranchNameAction(
    BackDatedEntryState state, SetBranchNameAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedBranchName: action.branchName,
  );
}

BackDatedEntryState _setUserListAction(
    BackDatedEntryState state, SetUserListAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedUserList: action.userList,
  );
}

BackDatedEntryState _setOptionNameAction(
    BackDatedEntryState state, SetOptionNameAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    selectedOptionName: action.optionName,
  );
}

import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/grading_and_costing/grading_and_costing_action.dart';
import 'package:redstars/src/redux/states/grading_and_costing/grading_and_costing_state.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/model/grading_model.dart';

final gradingCostingReducer = combineReducers<GradingCostingState>([
  TypedReducer<GradingCostingState, LoadingAction>(_lodingStatusAction),
  TypedReducer<GradingCostingState, OnClearAction>(_disposeAction),
  TypedReducer<GradingCostingState, AddGradeAction>(_addGrade),
  TypedReducer<GradingCostingState, RemoveGradeAction>(_removeGrade),
  TypedReducer<GradingCostingState, DataFetchAction>(_refreshGinAction),
  TypedReducer<GradingCostingState, GradingFillDataFetchAction>(
      _gradingListAction),
  TypedReducer<GradingCostingState, ProcessFromGINListFetchAction>(
      _processFromGinFetchAction),
  TypedReducer<GradingCostingState, CurrencyExchangeFetchAction>(
      _currencyExchange),
  TypedReducer<GradingCostingState, GradingSaveAction>(_saveAction),
  TypedReducer<GradingCostingState, GINFilterModelFetchAction>(_modelAction),
  TypedReducer<GradingCostingState, ItemDetailClearAction>(_clearAction),
  TypedReducer<GradingCostingState, SavingModelVarAction>(_saveModelVarAction),
  TypedReducer<GradingCostingState, GradingViewListFetchAction>(
      _viewListFetchAction),
  TypedReducer<GradingCostingState, GradingViewListDetailFetchAction>(
      _viewListDetailAction),
  TypedReducer<GradingCostingState, GINFilterViewListSaveAction>(
      _ginFilterSaveAction),
  TypedReducer<GradingCostingState, SavingFilterAction>(_savingFilterAction),
  TypedReducer<GradingCostingState, GradeRateFetchAction>(_gradeRateAction),
  TypedReducer<GradingCostingState, EditGradeAction>(_editGrade),
  TypedReducer<GradingCostingState, GradeListFetchAction>(_gradeListAction),
]);

GradingCostingState _gradeListAction(
    GradingCostingState state, GradeListFetchAction action) {
  return state.copyWith(
      loadingMessage: "",
      loadingError: "",
      loadingStatus: LoadingStatus.success,
      gradeList: action.grades);
}

GradingCostingState _ginFilterSaveAction(
    GradingCostingState state, GINFilterViewListSaveAction action) {
  return state.copyWith(
      loadingMessage: "",
      loadingError: "",
      loadingStatus: LoadingStatus.success,
      ginFilterModel: action.ginFilterModel);
}

GradingCostingState _lodingStatusAction(
    GradingCostingState state, LoadingAction action) {
  return state.copyWith(
      loadingMessage: action.message,
      loadingError: action.message,
      loadingStatus: action.status);
}

GradingCostingState _viewListFetchAction(
    GradingCostingState state, GradingViewListFetchAction action) {
  return state.copyWith(
      loadingMessage: "",
      loadingError: "",
      loadingStatus: LoadingStatus.success,
      gradingViewListModel: action.gradingViewListModel);
}

GradingCostingState _gradeRateAction(
    GradingCostingState state, GradeRateFetchAction action) {
  print("gradeList----${action.gradeRate.length}");
  return state.copyWith(
    loadingMessage: "",
    loadingError: "",
    loadingStatus: LoadingStatus.success,
    gradeRateList: action.gradeRate,
  );
}

GradingCostingState _editGrade(
    GradingCostingState state, EditGradeAction action) {
  List<GradeModel> items = state.listOfGradeModel;
  if (items.contains(action.item)) {
    int index = items.indexOf(action.item);
    var updatedItem = items[index];
    updatedItem.qty = action.item.qty;
    updatedItem.rate = action.item.rate;
    updatedItem.total = action.item.total;
    items[index] = updatedItem;
    return state.copyWith(listOfGradeModel: items);
  } else
    return state.copyWith(listOfGradeModel: [action.item, ...items]);
}

GradingCostingState _viewListDetailAction(
    GradingCostingState state, GradingViewListDetailFetchAction action) {
  return state.copyWith(
    loadingMessage: "",
    loadingError: "",
    loadingStatus: LoadingStatus.success,
    gradingCostingViewDetailModel: action.gradingCostingViewDetailModel,
  );
}

GradingCostingState _modelAction(
    GradingCostingState state, GINFilterModelFetchAction action) {
  return state.copyWith(
    loadingMessage: "",
    loadingError: "",
    loadingStatus: LoadingStatus.success,
    ginFilterModel: action.ginFilterModel,
  );
}

// GradingCostingState _newItemAction(
//     GradingCostingState state, AddStockRequisitionAction action) {
//   List<StockRequisitionModel> items = state.stockItems;
//   if (items.contains(action.item)) {
//     int index = items.indexOf(action.item);
//     var updatedItem = items[index];
//     updatedItem.qty = action.item.qty;
//     items[index] = updatedItem;
//     return state.copyWith(stockItems: items);
//   } else
//     return state.copyWith(stockItems: [action.item, ...items]);
// }

GradingCostingState _gradingListAction(
    GradingCostingState state, GradingFillDataFetchAction action) {
  action.gradingList.forEach((element) {
    state.itemDetailList.clear();
    return state.itemDetailList.addAll(element.itemDtl);
  });
  return state.copyWith(
    loadingError: "",
    loadingMessage: "Loading",
    loadingStatus: LoadingStatus.success,
    gradingList: action.gradingList,
  );
}

GradingCostingState _clearAction(
        GradingCostingState state, ItemDetailClearAction action) =>
    GradingCostingState.initial().copyWith();

GradingCostingState _saveAction(
    GradingCostingState state, GradingSaveAction action) {
  return state.copyWith(
    saveData: true,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

GradingCostingState _disposeAction(
    GradingCostingState state, OnClearAction action) {
  return GradingCostingState.initial();
}

GradingCostingState _refreshGinAction(
    GradingCostingState state, DataFetchAction action) {
  print("hello123${action.refreshGinList.length}");
  return state.copyWith(
    refreshGinList: action.refreshGinList,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

// GradingCostingState _refreshFilterAction(
//     GradingCostingState state, DataFilterAction action) {
//   print("hello123${action.gradingViewList.length}");
//   return state.copyWith(
//     gradingViewList: action.gradingViewList,
//     loadingError: "",
//     loadingMessage: "",
//     loadingStatus: LoadingStatus.success,
//   );
// }

GradingCostingState _processFromGinFetchAction(
    GradingCostingState state, ProcessFromGINListFetchAction action) {
  return state.copyWith(
    refreshGinList: action.processFromGinList,
    processGinList: action.processFromGinList,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

GradingCostingState _currencyExchange(
    GradingCostingState state, CurrencyExchangeFetchAction action) {
  print("exchange======${action.currencyEx}");
  return state.copyWith(
    currencyExchange: action.currencyEx,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

GradingCostingState _addGrade(
    GradingCostingState state, AddGradeAction action) {
  List<GradeModel> items = state.listOfGradeModel;
  if (items.contains(action.item)) {
    int index = items.indexOf(action.item);
    var updatedItem = items[index];
    updatedItem.qty = action.item.qty;
    updatedItem.rate = action.item.rate;
    updatedItem.total = action.item.total;
    items[index] = updatedItem;
    return state.copyWith(listOfGradeModel: items);
  } else
    return state.copyWith(listOfGradeModel: [action.item, ...items]);
}

GradingCostingState _removeGrade(
    GradingCostingState state, RemoveGradeAction action) {
  List<GradeModel> items = state.listOfGradeModel;

  if (items.contains(action.item)) {
    items.remove(action.item);
    return state.copyWith(listOfGradeModel: items);
  }
  return state.copyWith();
}

GradingCostingState _saveModelVarAction(
    GradingCostingState state, SavingModelVarAction action) {
  print("Saved Data ${action.filters.toString()}");
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    ginFilterModel: action.filters,
  );
}

GradingCostingState _savingFilterAction(
    GradingCostingState state, SavingFilterAction action) {
  print("Saved Data ${action.filterModel.toString()}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      ginFilterModel: action.filterModel);
}

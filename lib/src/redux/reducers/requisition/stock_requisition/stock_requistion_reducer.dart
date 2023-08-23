import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/requisition/stock_requisition/stock_requisition_action.dart';
import 'package:redstars/src/redux/states/requisition/stock_requisition/stock_requistion_state.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_requisition_model.dart';

final stockRequisitionReducer = combineReducers<StockRequisitionState>([
  TypedReducer<StockRequisitionState, LoadingAction>(
      _changeLoadingStatusAction),
  TypedReducer<StockRequisitionState, OnClearAction>(_disposeAction),
//  TypedReducer<StockRequisitionState, OnClearAction>(_clearAction),
  TypedReducer<StockRequisitionState, ItemDetailFetchAction>(_itemFetchAction),
  TypedReducer<StockRequisitionState, ItemStockDetailClearAction>(
      _itemClearAction),
  TypedReducer<StockRequisitionState, StockLocationChangeAction>(
      _locationChangeAction),
  TypedReducer<StockRequisitionState, AddStockRequisitionAction>(
      _newItemAction),
  TypedReducer<StockRequisitionState, RemoveStockRequisitionAction>(
      _removeItemAction),
  TypedReducer<StockRequisitionState, RemoveSelectedStockRequisitionAction>(
      _removeSelectedStockAction),
  TypedReducer<StockRequisitionState, TransactionStatusFetchAction>(
      _transStatusAction),
  TypedReducer<StockRequisitionState, StockLocationsFetchAction>(
      _locationFetchAction),
  TypedReducer<StockRequisitionState, ItemBudgetDetails>(_itemBudgetDtlAction),
  TypedReducer<StockRequisitionState, RequisitionSaveAction>(_saveAction),
  TypedReducer<StockRequisitionState, StockViewListFectchAction>(
      _stockListAction),
  TypedReducer<StockRequisitionState, SelectedStockViewFetchAction>(
      _selectedView),
  TypedReducer<StockRequisitionState, SavingStockFilterAction>(_filterAction),
  TypedReducer<StockRequisitionState, ItemsFetchAction>(_itemsAction),
]);

StockRequisitionState _changeLoadingStatusAction(
    StockRequisitionState state, LoadingAction action) {
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message,
      stockDtlLoading: action.type == StockRequisitionViews.STOCK_DETAIL
          ? action.status
          : null);
}

StockRequisitionState _stockListAction(
    StockRequisitionState state, StockViewListFectchAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      viewListModel: action.stockViewListModel);
}

StockRequisitionState _itemsAction(
    StockRequisitionState state, ItemsFetchAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      items: action.items);
}

StockRequisitionState _selectedView(
    StockRequisitionState state, SelectedStockViewFetchAction action) {
  StockRequisitionModel model;
  List<StockRequisitionModel> data = [];
//  List<StockLocation> targetLocation=[];
  StockLocation selectedTarget;
  state.locations.forEach((element) {
    if (element.id ==
        action.stockViewModel.stockViewList.first
            .targetbusinessleveltabledataid) {
      //  targetLocation.add(element);
      selectedTarget = element;
    }
    return selectedTarget;
  });

  for (int i = 0;
      i < action.stockViewModel.stockViewList.first.detailDtl.length;
      i++) {
    model = StockRequisitionModel(
        objId: action.stockViewModel..stockViewList.first.id,
        detailId: action.stockViewModel.stockViewList.first.detailDtl[i].id,
        remark: action.stockViewModel.stockViewList.first.remarks,
        item: ItemLookupItem(
          description:
              action.stockViewModel.stockViewList.first.detailDtl[i]?.itemname,
          code:
              action.stockViewModel.stockViewList.first.detailDtl[i]?.itemcode,
        ),
        qty: action.stockViewModel.stockViewList.first.detailDtl[i]?.qty,
        uom: action.stockViewModel.stockViewList.first.detailDtl[i]?.uomTypes,
        itemBudget: BudgetDtlModel(
          id: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.id,
          itemcost: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.rate,
          accountid: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.id,
          itemid: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.itemid,
          inprocess: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.inprocess,
          remaining: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.remaining,
          actual: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.actual,
          budgeted: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.budgeted,
          budgetdate: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.budgetdate,
          departmentid: action.stockViewModel.stockViewList.first.detailDtl[i]
              .budjetdtljson?.departmentid,
        ));
    data.add(model);
  }

  print("Selected stock id ${action.stockViewModel.stockViewList.first.id}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      stockViewModel: action.stockViewModel,
      stockItems: data,
      stockReqId: 1,
      selectedDestinationLocation: selectedTarget);
}

StockRequisitionState _filterAction(
    StockRequisitionState state, SavingStockFilterAction action) {
  print("Saved Data ${action.filterModel.toString()}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      filterModel: action.filterModel);
}

StockRequisitionState _itemBudgetDtlAction(
    StockRequisitionState state, ItemBudgetDetails action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      itemBudgetDtl: action.itembudgetDtl);
}

BudgetDtlModel itemBudget;

StockRequisitionState _newItemAction(
    StockRequisitionState state, AddStockRequisitionAction action) {
  itemBudget = state.itemBudgetDtl != null && state.itemBudgetDtl.isNotEmpty
      ? state.itemBudgetDtl.first
      : null;
  action.item.budgetDtl = itemBudget;
  List<StockRequisitionModel> items = state.stockItems;
  if (items.contains(action.item)) {
    int index = items.indexOf(action.item);
    var updatedItem = items[index];
    updatedItem.qty = action.item.qty;
    items[index] = updatedItem;
    return state.copyWith(stockItems: items);
  } else
    return state.copyWith(stockItems: [action.item, ...items]);
}

StockRequisitionState _transStatusAction(
    StockRequisitionState state, TransactionStatusFetchAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      status: action.status);
}

StockRequisitionState _saveAction(
    StockRequisitionState state, RequisitionSaveAction action) {
  return state.copyWith(
    saved: true,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

StockRequisitionState _disposeAction(
    StockRequisitionState state, OnClearAction action) {
  return StockRequisitionState.initial();
}

StockRequisitionState _removeItemAction(
    StockRequisitionState state, RemoveStockRequisitionAction action) {
  List<StockRequisitionModel> items = state.stockItems;

  if (items.contains(action.item)) {
    items.remove(action.item);
    return state.copyWith(stockItems: items);
  }
  return state.copyWith();
}

StockRequisitionState _removeSelectedStockAction(
    StockRequisitionState state, RemoveSelectedStockRequisitionAction action) {
  List<SelectedStockViewModel> items = state.selectedStock;
  if (items.contains(action.item)) {
    items.remove(action.item);
    return state.copyWith(selectedStock: items);
  }
  return state.copyWith();
}

StockRequisitionState _locationFetchAction(
    StockRequisitionState state, StockLocationsFetchAction action) {
  return state.copyWith(
    locations: action.locations,
    sourceLocations: action.sources,
    selectedSourceLocation: action.locations?.firstWhere(
        (location) => location.id == action.locationId,
        orElse: () => null),
    selectedDestinationLocation: null,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

StockRequisitionState _locationChangeAction(
    StockRequisitionState state, StockLocationChangeAction action) {
  return state.copyWith(
    selectedDestinationLocation: action.isTarget ? action.location : null,
    selectedSourceLocation: !action.isTarget ? action.location : null,
  );
}

StockRequisitionState _itemFetchAction(
    StockRequisitionState state, ItemDetailFetchAction action) {
  return state.copyWith(
    stockDetails: action.stockDtl,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    stockDtlLoading: LoadingStatus.success,
  );
}

StockRequisitionState _itemClearAction(
    StockRequisitionState state, ItemStockDetailClearAction action) {
  return state.copyWith(
    stockDetails: [],
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

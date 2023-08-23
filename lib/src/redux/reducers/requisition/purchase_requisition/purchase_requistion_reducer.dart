import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/requisition/purchase_requisition/purchase_requisition_action.dart';
import 'package:redstars/src/redux/states/requisition/purchase_requisition/purchase_requistion_state.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/department_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/branch_store_model.dart';
import 'package:redstars/src/widgets/screens/requisition/purchase_requisition/model/purchase_requisition_model.dart';

final purchaseRequisitionReducer = combineReducers<PurchaseRequisitionState>([
  TypedReducer<PurchaseRequisitionState, LoadingAction>(
      _changeLoadingStatusAction),
  TypedReducer<PurchaseRequisitionState, OnClearAction>(_clearAction),
  TypedReducer<PurchaseRequisitionState, AddPurchaseRequisitionAction>(
      _newItemAction),
  TypedReducer<PurchaseRequisitionState, RemovePurchaseRequisitionAction>(
      _removeItemAction),
  TypedReducer<PurchaseRequisitionState, TransactionStatusFetchAction>(
      _transStatusAction),
  TypedReducer<PurchaseRequisitionState, PurchaseItemBudgetDetails>(
      _itemBudgetDtlAction),
  TypedReducer<PurchaseRequisitionState, RequisitionSaveAction>(_saveAction),
  TypedReducer<PurchaseRequisitionState, DepartmentListAction>(_getDepartments),
  TypedReducer<PurchaseRequisitionState, BranchListAction>(_getBranches),
  TypedReducer<PurchaseRequisitionState, PurchaseViewListFectchAction>(
      _purchaseViewListAction),
  TypedReducer<PurchaseRequisitionState, SavingPurchaseFilterAction>(
      _filterAction),
  TypedReducer<PurchaseRequisitionState, PurchaseViewDetailListFectchAction>(
      _purchaseViewListDetailAction),
  TypedReducer<PurchaseRequisitionState, UomObjectFetchAction>(
      _uomObjectAction),
  TypedReducer<PurchaseRequisitionState, ItemFetchAction>(_itemsFetchAction),
  TypedReducer<PurchaseRequisitionState, GetsBranchStoreListAction>(
      _branchStoreAction),
]);

PurchaseRequisitionState _branchStoreAction(
    PurchaseRequisitionState state, GetsBranchStoreListAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    branchStoreList: action.branchStorelist,
  );
}

PurchaseRequisitionState _itemsFetchAction(
    PurchaseRequisitionState state, ItemFetchAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    itemList: action.itemList,
  );
}

PurchaseRequisitionState _uomObjectAction(
    PurchaseRequisitionState state, UomObjectFetchAction action) {
  print("uomObject---${action.uomList.length}");
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    uomList: action.uomList,
  );
}

PurchaseRequisitionState _purchaseViewListDetailAction(
    PurchaseRequisitionState state, PurchaseViewDetailListFectchAction action) {
  PurchaseRequisitionModel model;
  List<PurchaseRequisitionModel> data = [];
  ItemLookupItem itemData;
  BranchStore branchStore;
  DepartmentItem departmentItem;

  for (int i = 0;
      i < action.purchaseModel.purchaseDetailViewList.first.detailDtl.length;
      i++) {
    state.branchStoreList.forEach((element) {
      if (element.id ==
          action.purchaseModel.purchaseDetailViewList.first.detailDtl[i]
              .departmentDtl?.branchid) {
        branchStore = element;
      }
      return branchStore;
    });

    state.departmentList.forEach((element) {
      if (element.departmentid ==
          action.purchaseModel.purchaseDetailViewList.first.detailDtl[i]
              .departmentDtl?.departmentid) {
        departmentItem = element;
      }
      return departmentItem;
    });

    model = PurchaseRequisitionModel(
        remark: action.purchaseModel.purchaseDetailViewList.first.remarks,
        branch: branchStore,
        id: action.purchaseModel.purchaseDetailViewList.first.detailDtl[i]
            .departmentDtl?.id,
        detailListId:
            action.purchaseModel.purchaseDetailViewList.first.detailDtl[i]?.Id,
        item: ItemLookupItem(
            code: action.purchaseModel.purchaseDetailViewList.first.detailDtl[i]
                ?.itemcode,
            description: action.purchaseModel.purchaseDetailViewList.first
                .detailDtl[i]?.itemname,
            id: action.purchaseModel.purchaseDetailViewList.first.detailDtl[i]
                ?.itemid),
        uom: UomTypes(
            uomid: action.purchaseModel.purchaseDetailViewList.first
                ?.detailDtl[i]?.uomid,
            uomtypebccid: action.purchaseModel.purchaseDetailViewList.first
                ?.detailDtl[i]?.uomtypebccid,
            uomname: action.purchaseModel.purchaseDetailViewList.first
                ?.detailDtl[i]?.uomDtl?.uomname),
        qty: action
            .purchaseModel.purchaseDetailViewList.first?.detailDtl[i]?.qty,
        itemBudget: BudgetDtlModel(
          itemcost: action.purchaseModel.purchaseDetailViewList.first
              ?.detailDtl[i]?.departmentDtl?.rate,
          budgeted: action.purchaseModel.purchaseDetailViewList.first
              ?.detailDtl[i]?.departmentDtl?.budgeted,
          actual: action.purchaseModel.purchaseDetailViewList.first
              ?.detailDtl[i]?.departmentDtl?.actual,
          remaining: action.purchaseModel.purchaseDetailViewList.first
              ?.detailDtl[i]?.departmentDtl?.remaining,
          departmentid: action.purchaseModel.purchaseDetailViewList.first
              ?.detailDtl[i]?.departmentDtl?.departmentid,
          itemid: action.purchaseModel.purchaseDetailViewList.first
              ?.detailDtl[i]?.departmentDtl?.itemid,
          budgetdate: action.purchaseModel.purchaseDetailViewList.first
              ?.detailDtl[i]?.departmentDtl?.budgetdate,
        ),
        department: departmentItem
        // DepartmentItem(
        //   departmentid: action.purchaseModel.purchaseDetailViewList.first
        //       ?.detailDtl[i]?.departmentDtl?.departmentid,
        // )
        );
    data.add(model);
  }
  print(
      "purchaseDetailList${action.purchaseModel.purchaseDetailViewList.first.detailDtl.length}");

  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    detailPurchaseModelData: action.purchaseModel,
    purchaseItems: data,
    viewdtlId: 1,
    purchaseDetailViewList: action.purchaseModel.purchaseDetailViewList,
  );
}

PurchaseRequisitionState _purchaseViewListAction(
    PurchaseRequisitionState state, PurchaseViewListFectchAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      viewListModel: action.purchaseViewlist);
}

PurchaseRequisitionState _filterAction(
    PurchaseRequisitionState state, SavingPurchaseFilterAction action) {
  print("Saved Data ${action.filterModel.toString()}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      filterModel: action.filterModel);
}

PurchaseRequisitionState _changeLoadingStatusAction(
    PurchaseRequisitionState state, LoadingAction action) {
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message);
}

BudgetDtlModel itemBudget;
PurchaseRequisitionState _newItemAction(
    PurchaseRequisitionState state, AddPurchaseRequisitionAction action) {
  itemBudget = state.purchaseItemBudgetDtl != null &&
          state.purchaseItemBudgetDtl.isNotEmpty
      ? state.purchaseItemBudgetDtl.first
      : null;
  action.item.budgetDtl = itemBudget;
  List<PurchaseRequisitionModel> items = state.purchaseItems;
  if (items.contains(action.item)) {
    int index = items.indexOf(action.item);
    var updatedItem = items[index];
    updatedItem.qty = action.item.qty;
    items[index] = updatedItem;
    return state.copyWith(purchaseItems: items);
  } else
    return state.copyWith(purchaseItems: [action.item, ...items]);
}

PurchaseRequisitionState _getDepartments(
    PurchaseRequisitionState state, DepartmentListAction action) {
  print("department=----${action.departments.length}");
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      departmentList: action.departments);
}

PurchaseRequisitionState _getBranches(
    PurchaseRequisitionState state, BranchListAction action) {
  print("department=----${action.branches.length}");
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      branchList: action.branches);
}

PurchaseRequisitionState _itemBudgetDtlAction(
    PurchaseRequisitionState state, PurchaseItemBudgetDetails action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      purchaseItemBudgetDtl: action.itembudgetDtl);
}

PurchaseRequisitionState _transStatusAction(
    PurchaseRequisitionState state, TransactionStatusFetchAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      status: action.status);
}

PurchaseRequisitionState _saveAction(
    PurchaseRequisitionState state, RequisitionSaveAction action) {
  return state.copyWith(
    saved: true,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

PurchaseRequisitionState _clearAction(
    PurchaseRequisitionState state, OnClearAction action) {
  return PurchaseRequisitionState.initial().copyWith(
      departmentList: state.departmentList,
      branchList: state.branchList,
      detailPurchaseModelData: state.detailPurchaseModelData,
      itemList: state.itemList,
      status: state.status);
}

PurchaseRequisitionState _removeItemAction(
    PurchaseRequisitionState state, RemovePurchaseRequisitionAction action) {
  List<PurchaseRequisitionModel> items = state.purchaseItems;

  if (items.contains(action.item)) {
    items.remove(action.item);
    return state.copyWith(purchaseItems: items);
  }
  return state.copyWith();
}

import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/requisition/purchase_requisition/purchase_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/requisition/purchase_requisition/purchase_requistion_state.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/department_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/branch_store_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/purchase_list_view_details_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/purchase_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/requisition/transaction_status_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/purchase_requisition/model/purchase_requisition_model.dart';

import '../../../../../utility.dart';

class PurchaseRequisitionViewModel extends BaseViewModel {
  final Function(PurchaseRequisitionModel) onAdd;
  final Function(int, int, List<PurchaseRequisitionModel>, String, int,
      PurchaseDetailsViewModel) onSave;
  final List<PurchaseRequisitionModel> requisitionItems;
  final List<TransactionStatusItem> status;
  final VoidCallback onClear;
  final int optionId;
  final List<BudgetDtlModel> itemPurchaseBudgetDtl;
  final List<DepartmentItem> departmentList;
  final List<BranchStockLocation> branchList;
  final double scrollPosition;
  final Function(ItemLookupItem, DepartmentItem, BranchStore)
      onPurchaseItemBudget;
  final ValueSetter<PurchaseRequisitionModel> onRemoveItem;
  final bool isSaved;
  final PVFilterModel model;
  final Function(PVFilterModel result, int start, double position,
      List<PurchaseViewList>) onFilterSubmit;
  final Function(PVFilterModel result) onSubmit;
  String statusinformation;
  final Function(PVFilterModel model) onFilter;
  final List<PurchaseViewList> purchaseViewList;
  final bool initLoad;
  final PurchaseViewListModel purchaseViewListModel;
  final PurchaseDetailsViewModel detailPurchaseModelData;
  // final List<UomTypes> uomList;
  final List<ItemLookupItem> itemList;
  final int viewDtlId;
  final List<BranchStore> branchStoreList;
  final Function(
    PurchaseViewListModel,
    PurchaseViewList,
    PVFilterModel,
  ) onPurchaseView;

  PurchaseRequisitionViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    //  this.uomList,
    this.branchStoreList,
    this.viewDtlId,
    this.onSubmit,
    this.itemList,
    this.initLoad,
    this.statusinformation,
    this.purchaseViewList,
    this.departmentList,
    this.branchList,
    this.itemPurchaseBudgetDtl,
    this.onPurchaseItemBudget,
    this.onAdd,
    this.isSaved,
    this.onSave,
    this.requisitionItems,
    this.status,
    this.optionId,
    this.onRemoveItem,
    this.onClear,
    this.scrollPosition,
    this.model,
    this.onFilterSubmit,
    this.purchaseViewListModel,
    this.onFilter,
    this.detailPurchaseModelData,
    this.onPurchaseView,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory PurchaseRequisitionViewModel.fromStore(Store<AppState> store) {
    PurchaseRequisitionState state =
        store.state.requisitionState.purchaseRequisitionState;
    var optionId = store.state.homeState.selectedOption.optionId;
    return PurchaseRequisitionViewModel(
        loadingStatus: state.loadingStatus,
        errorMessage: state.loadingError,
        loadingMessage: state.loadingMessage,
        requisitionItems: state.purchaseItems,
        itemPurchaseBudgetDtl: state.purchaseItemBudgetDtl,
        status: state.status,
        viewDtlId: state.viewdtlId,
        scrollPosition: state.scrollPosition,
        departmentList: state.departmentList,
        branchList: state.branchList,
        optionId: optionId,
        isSaved: state.saved,
        statusinformation: state.statusinfo,
        model: state.filterModel,
        itemList: state.itemList,
        purchaseViewList: state.purchaseViewList,
        branchStoreList: state.branchStoreList,
        purchaseViewListModel: state.viewListModel,
        detailPurchaseModelData: state.detailPurchaseModelData,
        //  uomList: state.uomList,
        onPurchaseView: (detailmodel, listData, filtermodel) {
          store.dispatch(fetchPurchaseViewDetails(
              sor_Id: detailmodel?.SOR_Id ?? 0,
              eor_Id: detailmodel?.EOR_Id ?? 0,
              totalRecords: detailmodel?.totalRecords ?? 0,
              filterModel: PVFilterModel(
                  fromDate: filtermodel.fromDate ?? state.fromDate,
                  toDate: filtermodel.toDate ?? state.toDate),
              resultData: listData));
        },
        onFilter: (filterModel) {
          store.dispatch(SavingPurchaseFilterAction(filterModel: filterModel));
        },
        onSubmit: (filter) {
          store.dispatch(fetchPurchaseViewListData(
              listData: [],
              start: 0,
              // sor_id: state.viewListModel.SOR_Id,
              // eor_id: state.viewListModel.EOR_Id,
              // totalrecords: state.viewListModel.totalRecords,
              filterModel: PVFilterModel(
                  fromDate: filter?.fromDate,
                  toDate: filter?.toDate,
                  reqNo: filter.reqNo)));
        },
        onFilterSubmit: (result, start, position, list) {
          print("start----$start");
          store.dispatch(fetchPurchaseViewListData(
              listData: list,
              start: start,
              // sor_id: state.viewListModel.SOR_Id,
              // eor_id: state.viewListModel.EOR_Id,
              // totalrecords: state.viewListModel.totalRecords,
              filterModel: PVFilterModel(
                  fromDate: result?.fromDate,
                  toDate: result?.toDate,
                  reqNo: result.reqNo)));
        },
        onPurchaseItemBudget: (item, department, branch) {
          return store.dispatch(fetchPurchaseItemBudgetDtl(
              itemId: item.id,
              optionId: optionId,
              departmentId: department.departmentid,
              branchId: branch.id));
        },
        onSave: (optionId, statusId, items, remarks, viewDtlId, detailData) {
          store.dispatch(saveRequisitionAction(
            optionId: optionId,
            status: statusId,
            detailData: detailData,
            requisitionItems: items,
            viewDtlId: viewDtlId,

            // budgetDtlModel: state.purchaseItemBudgetDtl.first,
            remarks: remarks,
          ));
        },
        onClear: () => store.dispatch(OnClearAction()),
        onRemoveItem: (item) =>
            store.dispatch(RemovePurchaseRequisitionAction(item)),
        onAdd: (model) => store.dispatch(AddPurchaseRequisitionAction(model)));
  }

  void onLoadMore(
    PVFilterModel model,
    int start,
    double position,
    List<PurchaseViewList> purchaseListData,
    // PurchaseViewListModel list
  ) {
    // start += 10;
    print("start---$start");
    onFilterSubmit(model, start, position, purchaseListData);
  }

  void saveRequisition({
    String remarks,
  }) {
    int statusBccId = status
            .firstWhere((element) => element.code == 'PENDING',
                orElse: () => null)
            ?.id ??
        0;

    onSave(optionId, statusBccId, requisitionItems, remarks, viewDtlId,
        detailPurchaseModelData);
  }

  int departId;
  Future<int> depat() async {
    departId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    print(departId);
    return departId;
  }

  String validateItems() {
    var id = depat();
    String message = "";
    bool valid = true;
    itemPurchaseBudgetDtl?.forEach((element) {
      var item = element.itemid;
      var itemName;
      var totalValue;
      requisitionItems.forEach((ele) {
        totalValue =
            double.parse(((ele.qty * element.itemcost))?.toStringAsFixed(2));
        if (ele.item.id == item) {
          itemName = ele.item.description;
        }
        return itemName;
      });

      if (valid) {
        if (id == null) {
          message = "User has no department";
          print(departId);
          valid = false;
        } else if (element.budgetreqyn == "Y" && element.budgeted == 0) {
          message = "Budget not defined for $itemName ";
          valid = false;
        } else if ((element.budgeted > 0) && (totalValue > element.remaining)) {
          message = "Amount cannot be greater than Remaining Amount";
          valid = false;
        } else if (element.budgetreqyn && element.budgetreqyn == "N") {
          if (element.budgeted > 0) {
            message =
                "Following item $itemName defined as budget exempted but it seems to be linked with a ledger having budget.";
          }
        }
      }
    });
    return message;
  }
}

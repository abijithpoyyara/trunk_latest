import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/department_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/branch_store_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/purchase_list_view_details_model.dart';
import 'package:redstars/src/services/model/response/requisition/purchase_requisition/purchase_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/requisition/transaction_status_model.dart';
import 'package:redstars/src/services/repository/requisition/purchase_requisition/purchase_requisition_repository.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/purchase_requisition/model/purchase_requisition_model.dart';

class AddPurchaseRequisitionAction {
  PurchaseRequisitionModel item;

  AddPurchaseRequisitionAction(this.item);
}

class GetsBranchStoreListAction {
  List<BranchStore> branchStorelist;
  GetsBranchStoreListAction(this.branchStorelist);
}

class RemovePurchaseRequisitionAction {
  PurchaseRequisitionModel item;

  RemovePurchaseRequisitionAction(this.item);
}

class TransactionStatusFetchAction {
  List<TransactionStatusItem> status;

  TransactionStatusFetchAction(this.status);
}

class ItemFetchAction {
  List<ItemLookupItem> itemList;
  ItemFetchAction(this.itemList);
}

class RequisitionSaveAction {}

class DepartmentListAction {
  List<DepartmentItem> departments;
  DepartmentListAction(this.departments);
}

class PurchaseViewDetailListFectchAction {
  PurchaseDetailsViewModel purchaseModel;
  PurchaseViewDetailListFectchAction(this.purchaseModel);
}

class UomObjectFetchAction {
  List<UomTypes> uomList;
  UomObjectFetchAction(this.uomList);
}

class PurchaseViewListFectchAction {
  // List<PurchaseViewList> purchaseViewlist;
  // PurchaseViewListFectchAction(this.purchaseViewlist);
  PurchaseViewListModel purchaseViewlist;
  PurchaseViewListFectchAction(this.purchaseViewlist);
}

class PurchaseViewListDetailsFetchAction {
  PurchaseDetailsViewModel viewPurchaseDetailsModel;
  PurchaseViewListDetailsFetchAction(this.viewPurchaseDetailsModel);
}

class SavingPurchaseFilterAction {
  PVFilterModel filterModel;

  SavingPurchaseFilterAction({this.filterModel});
}

class BranchListAction {
  List<BranchStockLocation> branches;
  BranchListAction(this.branches);
}

class PurchaseItemBudgetDetails {
  List<BudgetDtlModel> itembudgetDtl;
  PurchaseItemBudgetDetails(this.itembudgetDtl);
}

ThunkAction fetchUomData() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      PurchaseRequisitionRepository().getInitialConfig(
        onRequestSuccess: (uom) =>
            store.dispatch(new UomObjectFetchAction(uom)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchBranchStore() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      PurchaseRequisitionRepository().getBranchStore(
        onRequestSuccess: (branchList) =>
            store.dispatch(new GetsBranchStoreListAction(branchList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchItems() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      PurchaseRequisitionRepository().getItems(
        onRequestSuccess: (item) => store.dispatch(ItemFetchAction(item)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchInitialData() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      PurchaseRequisitionRepository().getApprovalStatus(
        onRequestSuccess: (status) =>
            store.dispatch(new TransactionStatusFetchAction(status)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchPurchaseViewDetails(
    {int start,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    PVFilterModel filterModel,
    PurchaseViewList resultData}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      PurchaseRequisitionRepository().getEnteredPurchaseList(
        start: 0,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        filterModel: filterModel,
        pqModelView: resultData,
        onRequestSuccess: (result) =>
            store.dispatch(new PurchaseViewDetailListFectchAction(result)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchPurchaseViewListData(
    {int start,
    PVFilterModel filterModel,
    int sor_id,
    int eor_id,
    int totalrecords,
    // PurchaseViewListModel model,
    List<PurchaseViewList> listData}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      PurchaseRequisitionRepository().getPurchaseView(
        start: start,
        filterModel: filterModel,
        sor_Id: sor_id,
        eor_Id: eor_id,
        totalRecords: totalrecords,
        onRequestSuccess: (status) {
          // start += 10;
          sor_id = status.SOR_Id;
          eor_id = status.EOR_Id;
          totalrecords = status.totalRecords;
          listData.addAll(status.purchaseViewList);
          store.dispatch(new PurchaseViewListFectchAction(status));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchBranches() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Branch details ",
      ));

      PurchaseRequisitionRepository().getBranchList(
          onRequestSuccess: (result) =>
              {store.dispatch(BranchListAction(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchDepartments() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Departments ",
      ));

      PurchaseRequisitionRepository().getDepartment(
          onRequestSuccess: (result) =>
              {store.dispatch(DepartmentListAction(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchPurchaseItemBudgetDtl(
    {int optionId, int itemId, int departmentId, int branchId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching Budget Details ",
      ));

      PurchaseRequisitionRepository().getPurchaseItemBudget(
          optionId: optionId,
          itemId: itemId,
          departmentId: departmentId,
          branchId: branchId,
          onRequestSuccess: (result) =>
              {store.dispatch(PurchaseItemBudgetDetails(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction saveRequisitionAction({
  int optionId,
  int status,
  List<PurchaseRequisitionModel> requisitionItems,
  String remarks,
  BudgetDtlModel budgetDtlModel,
  int statusBccid,
  int viewDtlId,
  PurchaseDetailsViewModel detailData,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Requisition ",
      ));

      store.dispatch(uploadDocumentsAction((xml) {
        PurchaseRequisitionRepository().saveRequisition(
          attachmentXml: xml,
          requisitionItems: requisitionItems,
          optionId: optionId,
          remarks: remarks,
          budgetDtl: budgetDtlModel,
          viewDtlId: viewDtlId,
          detailData: detailData,
          statusBccid: status,
          onRequestSuccess: () => store.dispatch(new RequisitionSaveAction()),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
          )),
        );
      }));
    });
  };
}

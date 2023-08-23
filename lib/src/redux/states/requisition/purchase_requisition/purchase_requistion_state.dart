import 'package:base/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

@immutable
class PurchaseRequisitionState extends BaseState {
  final List<PurchaseRequisitionModel> purchaseItems;
  final List<TransactionStatusItem> status;
  final bool saved;
  final List<BudgetDtlModel> purchaseItemBudgetDtl;
  final List<DepartmentItem> departmentList;
  final List<BranchStockLocation> branchList;
  final List<PurchaseViewList> purchaseViewList;
  final PVFilterModel filterModel;
  final DateTime fromDate;
  final DateTime toDate;
  final double scrollPosition;
  final PurchaseViewListModel viewListModel;
  final PurchaseDetailsViewModel detailPurchaseModelData;
  final List<UomTypes> uomList;
  final List<PurchaseDetailsViewList> purchaseDetailViewList;
  final List<ItemLookupItem> itemList;
  final int viewdtlId;
  final List<BranchStore> branchStoreList;
  final String statusinfo;
  PurchaseRequisitionState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    String filePath,
    this.branchStoreList,
    this.statusinfo,
    this.viewdtlId,
    this.purchaseDetailViewList,
    this.itemList,
    this.uomList,
    this.purchaseItems,
    this.status,
    this.saved,
    this.purchaseItemBudgetDtl,
    this.departmentList,
    this.branchList,
    this.filterModel,
    this.purchaseViewList,
    this.toDate,
    this.fromDate,
    this.scrollPosition,
    this.viewListModel,
    this.detailPurchaseModelData,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            filePath: filePath,
            loadingMessage: loadingMessage);

  PurchaseRequisitionState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    List<PurchaseRequisitionModel> purchaseItems,
    List<TransactionStatusItem> status,
    bool saved,
    List<BudgetDtlModel> purchaseItemBudgetDtl,
    List<DepartmentItem> departmentList,
    List<BranchStockLocation> branchList,
    List<PurchaseViewList> purchaseViewList,
    List<PurchaseViewList> listStatus,
    PVFilterModel filterModel,
    DateTime fromDate,
    DateTime toDate,
    double scrollPosition,
    PurchaseViewListModel viewListModel,
    PurchaseDetailsViewModel detailPurchaseModelData,
    List<UomTypes> uomList,
    List<ItemLookupItem> itemList,
    List<PurchaseDetailsViewList> purchaseDetailViewList,
    int viewdtlId,
    List<BranchStore> branchStoreList,
  }) {
    return PurchaseRequisitionState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingError: loadingError ?? this.loadingError,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      purchaseItems: purchaseItems ?? this.purchaseItems,
      status: status ?? this.status,
      departmentList: departmentList ?? this.departmentList,
      branchList: branchList ?? this.branchList,
      saved: saved ?? this.saved,
      filePath: filePath ?? this.filePath,
      viewdtlId: viewdtlId ?? this.viewdtlId,
      branchStoreList: branchStoreList ?? this.branchStoreList,
      purchaseDetailViewList:
          purchaseDetailViewList ?? this.purchaseDetailViewList,
      purchaseItemBudgetDtl:
          purchaseItemBudgetDtl ?? this.purchaseItemBudgetDtl,
      filterModel: filterModel ?? this.filterModel,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      viewListModel: viewListModel ?? this.viewListModel,
      uomList: uomList ?? this.uomList,
      itemList: itemList ?? this.itemList,
      detailPurchaseModelData:
          detailPurchaseModelData ?? this.detailPurchaseModelData,
      purchaseViewList: purchaseViewList ?? this.purchaseViewList,
      statusinfo: statusinfo ?? this.statusinfo,
    );
  }

  factory PurchaseRequisitionState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    return PurchaseRequisitionState(
        loadingStatus: LoadingStatus.success,
        loadingError: "",
        loadingMessage: "",
        filePath: "",
        purchaseItems: [],
        fromDate: DateTime(currentDate.year, currentDate.month, 1),
        toDate: DateTime.now(),
        status: [],
        itemList: [],
        saved: false,
        uomList: [],
        purchaseItemBudgetDtl: List(),
        departmentList: List(),
        purchaseViewList: List(),
        statusinfo: " ",
        scrollPosition: 0.0,
        viewdtlId: 0,
        viewListModel: null,
        branchStoreList: List(),
        purchaseDetailViewList: List(),
        detailPurchaseModelData: null,
        filterModel: PVFilterModel(
            dateRange: DateTimeRange(
              start: startDate,
              end: currentDate,
            ),
            fromDate: startDate,
            toDate: currentDate),
        branchList: List());
  }
}

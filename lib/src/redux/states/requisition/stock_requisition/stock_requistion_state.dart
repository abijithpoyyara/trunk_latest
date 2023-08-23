import 'package:base/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/department_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/transaction_status_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_requisition_model.dart';

@immutable
class StockRequisitionState extends BaseState {
  final List<StockRequisitionModel> stockItems;
  final List<TransactionStatusItem> status;
  final bool saved;
  final List<StockLocation> locations;
  final StockLocation selectedSourceLocation;
  final StockLocation selectedDestinationLocation;

  final List<StockLocation> sourceLocations;
  final List<BudgetDtlModel> itemBudgetDtl;

  final List<StockDetail> stockDetails;
  final LoadingStatus stockDtlLoading;
  final List<DepartmentItem> departmentList;
  final List<BranchStockLocation> branchList;
  final List<StockViewList> stockViewList;
  final SRFilterModel filterModel;
  final DateTime fromDate;
  final DateTime toDate;
  final double scrollPosition;
  final StockViewListModel viewListModel;
  final SelectedStockViewModel stockViewModel;
  final List<SelectedStockViewModel> selectedStock;
  final List<ItemLookupItem> items;
  final int stockReqId;
  final SelectedStockViewModel stoItem;

  StockRequisitionState({
    this.selectedSourceLocation,
    this.selectedDestinationLocation,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.stockViewModel,
    this.stoItem,
    this.itemBudgetDtl,
    this.stockItems,
    this.status,
    this.saved,
    this.locations,
    this.sourceLocations,
    this.scrollPosition,
    this.stockDetails,
    this.stockDtlLoading,
    this.departmentList,
    this.branchList,
    this.filterModel,
    this.stockViewList,
    this.toDate,
    this.fromDate,
    this.viewListModel,
    this.selectedStock,
    this.items,
    this.stockReqId,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  StockRequisitionState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    List<StockRequisitionModel> stockItems,
    List<TransactionStatusItem> status,
    bool saved,
    List<StockLocation> locations,
    StockLocation selectedSourceLocation,
    StockLocation selectedDestinationLocation,
    List<StockLocation> sourceLocations,
    List<StockDetail> stockDetails,
    LoadingStatus stockDtlLoading,
    List<BudgetDtlModel> itemBudgetDtl,
    List<DepartmentItem> departmentList,
    List<BranchStockLocation> branchList,
    List<StockViewList> stockViewList,
    SRFilterModel filterModel,
    DateTime fromDate,
    DateTime toDate,
    double scrollPosition,
    StockViewListModel viewListModel,
    SelectedStockViewModel stockViewModel,
    List<SelectedStockViewModel> selectedStock,
    List<ItemLookupItem> items,
    int stockReqId,
    SelectedStockViewModel stoItem,
  }) {
    return StockRequisitionState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        stockDtlLoading: stockDtlLoading ?? this.stockDtlLoading,
        loadingError: loadingError ?? this.loadingError,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        stockItems: stockItems ?? this.stockItems,
        status: status ?? this.status,
        saved: saved ?? this.saved,
        locations: locations ?? this.locations,
        sourceLocations: sourceLocations ?? this.sourceLocations,
        selectedSourceLocation:
            selectedSourceLocation ?? this.selectedSourceLocation,
        selectedDestinationLocation:
            selectedDestinationLocation ?? this.selectedDestinationLocation,
        stockDetails: stockDetails ?? this.stockDetails,
        itemBudgetDtl: itemBudgetDtl ?? this.itemBudgetDtl,
        branchList: branchList ?? this.branchList,
        filterModel: filterModel ?? this.filterModel,
        stoItem: stoItem ?? this.stoItem,
        stockViewList: stockViewList ?? this.stockViewList,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        items: items ?? this.items,
        stockReqId: stockReqId ?? this.stockReqId,
        scrollPosition: scrollPosition ?? this.scrollPosition,
        viewListModel: viewListModel ?? this.viewListModel,
        stockViewModel: stockViewModel ?? this.stockViewModel,
        departmentList: departmentList ?? this.departmentList,
        selectedStock: selectedStock ?? this.selectedStock);
  }

  factory StockRequisitionState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    return StockRequisitionState(
      loadingStatus: LoadingStatus.success,
      stockDtlLoading: LoadingStatus.success,
      loadingError: "",
      loadingMessage: "",
      fromDate: DateTime(currentDate.year, currentDate.month, 1),
      toDate: DateTime.now(),
      stockItems: [],
      status: [],
      saved: false,
      locations: [],
      sourceLocations: [],
      selectedSourceLocation: null,
      selectedDestinationLocation: null,
      stockDetails: [],
      itemBudgetDtl: List(),
      departmentList: List(),
      stockViewModel: null,
      viewListModel: null,
      branchList: List(),
      scrollPosition: 0.0,
      stockReqId: 0,
      items: [],
      stoItem: null,
      filterModel: SRFilterModel(
          dateRange: DateTimeRange(
            start: startDate,
            end: currentDate,
          ),
          fromDate: startDate,
          toDate: currentDate),
      stockViewList: [],
      selectedStock: [],
    );
  }
}

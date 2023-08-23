import 'package:base/redux.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_sourcemapping_dtl_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_dtl_list_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_list_data.dart';
import 'package:redstars/src/services/model/response/gin/po_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/gin/model/gin_filter_model.dart';

class GINState extends BaseState {
  final GINFilterModel filterRange;
  final List<PoModel> purchaseOrders;
  final double scrollPosition;
  final GINModel ginDetails;
  final GINFilterModel gnFilter;
  final List<GINSourceMappingDtlList> ginSrcList;
  final List<BranchStockLocation> ginLocations;
  final BranchStockLocation ginSelelctedLoc;
  final BranchStockLocation lc;
  final String remarks;
  final bool isGinSaved;
  final GINSourceMappingDtlList srcData;
  final GINViewListDataListModel savedViewListModel;
  final GINViewDetailModel viewDtlListModel;
  final GINDateFilterModel dateFilter;
  final int ginEditedId;
  final int limit;
  final List<SupplierLookupItem> suppliers;
  final List<dynamic> supplierList;
  final GINFilterModel initialFilterModel;

  GINState({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    this.filterRange,
    this.purchaseOrders,
    this.scrollPosition,
    this.ginDetails,
    this.ginSrcList,
    this.ginLocations,
    this.remarks,
    this.ginSelelctedLoc,
    this.isGinSaved,
    this.srcData,
    this.gnFilter,
    this.savedViewListModel,
    this.viewDtlListModel,
    this.dateFilter,
    this.ginEditedId,
    this.suppliers,
    this.lc,
    this.limit,
    this.supplierList,
    this.initialFilterModel,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  GINState copyWith({
    GINFilterModel filterRange,
    LoadingStatus loadingStatus,
    double scrollPosition,
    String loadingMessage,
    String loadingError,
    List<PoModel> purchaseOrders,
    GINModel ginDetails,
    List<GINSourceMappingDtlList> ginSrcList,
    List<BranchStockLocation> ginLocations,
    BranchStockLocation ginSelelctedLoc,
    String remarks,
    bool isGINSaved,
    GINSourceMappingDtlList srcData,
    GINViewListDataListModel savedViewListModel,
    GINViewDetailModel viewDtlListModel,
    GINDateFilterModel dateFilter,
    int ginEditedId,
    int limit,
    List<SupplierLookupItem> suppliers,
    List<dynamic> supplierList,
    GINFilterModel gnFilter,
    BranchStockLocation lc,
    GINFilterModel initialFilterModel,
  }) {
    return GINState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      filterRange: filterRange ?? this.filterRange,
      loadingMessage: loadingMessage,
      loadingError: loadingError,
      purchaseOrders: purchaseOrders ?? this.purchaseOrders,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      ginDetails: ginDetails ?? this.ginDetails,
      ginSrcList: ginSrcList ?? this.ginSrcList,
      ginLocations: ginLocations ?? this.ginLocations,
      remarks: remarks ?? this.remarks,
      gnFilter: gnFilter ?? this.gnFilter,
      ginSelelctedLoc: ginSelelctedLoc ?? this.ginSelelctedLoc,
      //?? this.ginSelelctedLoc,
      srcData: srcData ?? this.srcData,
      savedViewListModel: savedViewListModel ?? this.savedViewListModel,
      viewDtlListModel: viewDtlListModel ?? this.viewDtlListModel,
      dateFilter: dateFilter ?? this.dateFilter,
      ginEditedId: ginEditedId ?? this.ginEditedId,
      suppliers: suppliers ?? this.suppliers,
      supplierList: supplierList ?? this.supplierList,
      lc: lc ?? this.lc,
      limit: limit ?? this.limit,
      isGinSaved: isGINSaved ?? this.isGinSaved,
      initialFilterModel: initialFilterModel ?? this.initialFilterModel,
    );
  }

  factory GINState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    return GINState(
        filterRange: GINFilterModel(
          fromDate: startDate,
          toDate: currentDate,
          dateRange: DateTimeRange(start: startDate, end: currentDate),
          supplier: null,
          transNo: '',
        ),
        loadingStatus: LoadingStatus.success,
        loadingMessage: '',
        loadingError: '',
        purchaseOrders: [],
        scrollPosition: 0.0,
        ginDetails: null,
        ginLocations: List(),
        remarks: "",
        lc: null,
        limit: 10,
        supplierList: List(),
        initialFilterModel: GINFilterModel(
            fromDate: DateTime(currentDate.year, currentDate.month, 1),
            toDate: DateTime.now(),
            supplier: null,
            transNo: ""),
        dateFilter: GINDateFilterModel(
          fromDate: startDate,
          toDate: currentDate,
        ),
        srcData: null,
        isGinSaved: false,
        ginSelelctedLoc: null,
        savedViewListModel: null,
        viewDtlListModel: null,
        ginEditedId: 0,
        suppliers: [],
        ginSrcList: List());
  }
}

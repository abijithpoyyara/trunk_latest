import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/actions/gin/gin_actions.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/gin/gin_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_sourcemapping_dtl_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_dtl_list_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_list_data.dart';
import 'package:redstars/src/services/model/response/gin/po_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/gin/model/gin_filter_model.dart';

import 'filter_model.dart';
import 'gin_details.dart';

class GINViewModel extends BaseViewModel {
  final DateTime fromDate;
  final DateTime toDate;
  final double scrollPosition;

  final SupplierLookupItem selectedSupplier;
  final String searchQuery;
  final List<PoModel> purchaseOrders;
  final GINModel ginDtls;

  final SupplierModel supplier;
  final List<VehicleModel> vehicles;
  final List<GINItemModel> orderItems;
  final ValueSetter<GINItemModel> updateItem;
  final List<GINSourceMappingDtlList> ginSrcList;
  final List<BranchStockLocation> ginLocations;
  final BranchStockLocation ginSelelctedLoc;
  final String remarks;
  final bool isginSave;
  final Function() onGINSaveClick;
  final GINViewListDataListModel savedViewListModel;
  final GINViewDetailModel viewDtlListModel;
  final GINDateFilterModel ginDtlFilter;
  final int optionId;
  final int ginEditedId;
  final int limit;
  final GINFilterModel ginInitialFilter;
  final List<SupplierLookupItem> suppliers;
  final Function(List<dynamic> changedItems) onChangeItems;
  final Function(GINFilterModel) onSaveGINFilterModelData;
  final Function(GINFilterModel) updateDate;
  final Function(GINDateFilterModel) updateDate2;
  final GINFilterModel gnFTRModel;
  final Function(
    double,
    // List<PoModel> listData,
  ) getLessItem;
  final Function(GINDateFilterModel, int start, List<GINViewListDataList>)
      onGinFilterSubmit;
  final Function(GINDateFilterModel) onFilterChanged;
  final Function() onClear;
  final Function(GINDateFilterModel filterModel, GINViewListDataList list)
      onSavedViewListTap;
  final Function(String) onEnterRemarks;
  final Function(BranchStockLocation) onUserSelectLocation;

  final Future<void> Function() onRefresh;
  final Function(GINFilterModel) onFilter;
  final Function(
    double,
    //List<PoModel> listData,
  ) getMoreItem;
  final Function(String searchKey) onSearch;
  final Function(GINFilterModel ginFilter) onChangeGINFilter;
  final Function(GINFilterModel) onFilterApply;

  GINViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    this.fromDate,
    this.toDate,
    this.selectedSupplier,
    this.searchQuery,
    this.purchaseOrders,
    this.supplier,
    this.onRefresh,
    this.onFilter,
    this.getMoreItem,
    this.onSearch,
    this.scrollPosition,
    this.vehicles,
    this.orderItems,
    this.updateItem,
    this.ginSrcList,
    this.ginLocations,
    this.ginSelelctedLoc,
    this.remarks,
    this.onEnterRemarks,
    this.onUserSelectLocation,
    this.isginSave,
    this.ginDtls,
    this.viewDtlListModel,
    this.savedViewListModel,
    this.onGINSaveClick,
    this.onClear,
    this.onSaveGINFilterModelData,
    this.gnFTRModel,
    this.onFilterChanged,
    this.onGinFilterSubmit,
    this.ginDtlFilter,
    this.optionId,
    this.ginEditedId,
    this.suppliers,
    this.onChangeItems,
    this.updateDate,
    this.updateDate2,
    this.onSavedViewListTap,
    this.getLessItem,
    this.limit,
    this.ginInitialFilter,
    this.onChangeGINFilter,
    this.onFilterApply,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  factory GINViewModel.fromStore(Store<AppState> store) {
    final state = store.state.ginState;
    final filters = state.filterRange;
    final optionId = store.state.homeState.selectedOption.optionId;
    return GINViewModel(
        loadingStatus: state.loadingStatus,
        loadingError: state.loadingError,
        loadingMessage: state.loadingMessage,
        toDate: filters.dateRange.end,
        fromDate: filters.dateRange.start,
        searchQuery: state.filterRange.transNo,
        scrollPosition: state.scrollPosition,
        selectedSupplier: state.filterRange.supplier,
        purchaseOrders: state.purchaseOrders,
        ginSrcList: state.ginSrcList,
        gnFTRModel: state.gnFilter,
        ginLocations: state.ginLocations,
        ginSelelctedLoc: state.ginSelelctedLoc,
        remarks: state.remarks,
        isginSave: state.isGinSaved,
        ginDtls: state.ginDetails,
        optionId: optionId,
        ginInitialFilter: state.initialFilterModel,
        ginEditedId: state.ginEditedId,
        suppliers: state.suppliers,
        savedViewListModel: state.savedViewListModel,
        viewDtlListModel: state.viewDtlListModel,
        limit: state.limit,
        updateDate: (filter) {
          store.dispatch(UpdateDate(filter));
        },
        updateDate2: (filter) {
          store.dispatch(UpdateDate2(filter));
        },
        onChangeItems: (data) {
          store.dispatch(ChangeSuppliersAction(data));
        },
        onFilterApply: (ginF) {
          store.dispatch(fetchPOList(
            start: 0,
            // listData: listData,
            filters: GINFilterModel(
                fromDate: state.initialFilterModel.fromDate,
                toDate: state.initialFilterModel.toDate,
                supplier: state.initialFilterModel.supplier,
                transNo: state.initialFilterModel.transNo),
          ));
        },
        supplier: SupplierModel.fromGIN(state.ginDetails),
        vehicles: state.ginDetails?.vehicles,
        orderItems: state.ginDetails?.items,
        ginDtlFilter: state.dateFilter,
        onSavedViewListTap: (filter, savedListIndex) {
          store.dispatch(fetchGInViewDtlModelDetails(
              start: 0,
              sor_Id: savedListIndex.start,
              eor_Id: savedListIndex.limit,
              totalRecords: savedListIndex.totalrecords,
              id: savedListIndex,
              filterModel: GINDateFilterModel(
                  fromDate: filter?.fromDate ??
                      DateTime(DateTime.now().year, DateTime.now().month, 1),
                  toDate: filter?.toDate ?? DateTime.now()),
              optionId: optionId));
        },
        onRefresh: () =>
            store.dispatch(fetchPOList(filters: filters.copyWith())),
        onSearch: (query) => store
            .dispatch(fetchPOList(filters: filters.copyWith(transNo: query))),
        onSaveGINFilterModelData: (gnF) {
          store.dispatch(SaveGINFilter(gnF));
        },
        onFilter: (filterModel) => store.dispatch(fetchPOList(
              filters: GINFilterModel(
                  fromDate: filterModel.fromDate,
                  toDate: filterModel.toDate,
                  supplier: filterModel.supplier),
            )),
        getMoreItem: (
          offset,
          //listData
        ) =>
            store.dispatch(fetchPOList(
                offset: offset,
                start: state.purchaseOrders.first.limit,
                // listData: listData,
                filters: GINFilterModel(
                    fromDate: state.gnFilter.fromDate,
                    toDate: state.gnFilter.toDate),
                sorid: state.purchaseOrders.first.start,
                eorid: state.purchaseOrders.first.limit,
                totalRecords: state.purchaseOrders.first.totalRecords)),
        getLessItem: (
          offset,
          //listData
        ) =>
            store.dispatch(fetchPOList(
                offset: offset,
                start: 20 - state?.limit ?? 10,
                // listData: listData,
                filters: GINFilterModel(
                    fromDate: state.gnFilter.fromDate,
                    toDate: state.gnFilter.toDate),
                sorid: state.purchaseOrders.first.start,
                eorid: state.purchaseOrders.first.limit,
                totalRecords: state.purchaseOrders.first.totalRecords)),
        updateItem: (item) {
          store.dispatch(UpdateGINItemAction(item));
        },
        onFilterChanged: (ginFilter) =>
            store.dispatch(GInFilterDateChangeAction(ginFilter)),
        onGinFilterSubmit: (ginF, start, listData) {
          store.dispatch(fetchGInSavedData(
              start: start ?? 0,
              optionId: optionId,
              listData: listData,
              filterModel: ginF));
        },
        onClear: () {
          store.dispatch(GINClearAction());
        },
        onChangeGINFilter: (ginF) {
          store.dispatch(GINInitialFilterModelSaveAction(ginF));
        },
        onGINSaveClick: () {
          store.dispatch(saveGINACtion(
            optionId: optionId,
            remarks: state.remarks,
            location: state.ginSelelctedLoc,
            poModel:
                state.purchaseOrders != null && state.purchaseOrders.isNotEmpty
                    ? state.purchaseOrders.first
                    : null,
            ginModel: state.ginDetails,
            items: state.ginDetails.items,
            editId: state.ginEditedId,
            ginSourceMappingList: state.ginSrcList,
            dtlList: state.viewDtlListModel != null &&
                    state.viewDtlListModel.dtlList.isNotEmpty
                ? state.viewDtlListModel.dtlList.first
                : null,
          ));
        },
        onEnterRemarks: (remarks) {
          store.dispatch(ChangeRemarksAction(remarks));
        },
        onUserSelectLocation: (loc) {
          store.dispatch(ChangeLocationAction(loc));
        });
  }

  void onLoadMore(
    double position,
    //List<PoModel> listData,
  ) {
    getMoreItem(
      position,
      // listData,
    );
  }

  void onLoadLess(
    double position,
    //  List<PoModel> listData,
  ) {
    getLessItem(
      position,
      //  listData,
    );
  }

  String validateGINSave() {
    String message = "";
    bool valid = true;
    var flag;
    var result;
    orderItems.forEach((element) {
      flag = element.receivedQty == null;
      if (flag) {
        result = true;
      } else {
        result = false;
      }
      return result;
    });
    if (valid) {
      if (ginSelelctedLoc == null) {
        message = "Please select location.";
        valid = false;
      } else if (result == true) {
        message = "Please enter quantity.";
        valid = false;
      }
    }
    return message;
  }
}

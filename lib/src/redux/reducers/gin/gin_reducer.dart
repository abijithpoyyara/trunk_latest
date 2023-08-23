import 'package:base/redux.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/gin/gin_actions.dart';
import 'package:redstars/src/redux/states/gin/gin_state.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_sourcemapping_dtl_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_dtl_list_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/gin/model/gin_filter_model.dart';

final ginReducer = combineReducers<GINState>([
  TypedReducer<GINState, OnClearAction>(_clearAction),
  TypedReducer<GINState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<GINState, POListFetchSuccessAction>(_fetchPOsAction),
  TypedReducer<GINState, GINFetchSuccessAction>(_fetchGINAction),
  TypedReducer<GINState, UpdateGINItemAction>(_updateGINAction),
  TypedReducer<GINState, GINSourceMappingDtlAction>(_ginSourceAction),
  TypedReducer<GINState, GINLocationAction>(_ginLocationsAction),
  TypedReducer<GINState, ChangeLocationAction>(_changeLocationAction),
  TypedReducer<GINState, ChangeRemarksAction>(_changeRemarksAction),
  TypedReducer<GINState, GINKhatSaveAction>(_ginKhatSaveAction),
  TypedReducer<GINState, GINViewListModelAction>(_ginSavedListAction),
  TypedReducer<GINState, GINViewDtlListModelAction>(_ginViewDtlAction),
  TypedReducer<GINState, GInFilterDateChangeAction>(_ginFilterChangeAction),
  TypedReducer<GINState, GINSupplierGetAction>(_ginSupplierGetAction),
  TypedReducer<GINState, ChangeSuppliersAction>(_changeSupplierAction),
  TypedReducer<GINState, SaveGINFilter>(_saveFilterAction),
  TypedReducer<GINState, GINClearAction>(_clearGin),
  TypedReducer<GINState, UpdateDate>(_updateDate),
  TypedReducer<GINState, UpdateDate2>(_updateDate2),
  TypedReducer<GINState, GINInitialFilterModelSaveAction>(_ginFilterSaveAction),
]);

GINState _changeLoadingStatusAction(GINState state, LoadingAction action) {
  //if (action.type == "GIN") {
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message);
  // }
  // else {
  //   return state;
  // }
}

GINState _ginKhatSaveAction(GINState state, GINKhatSaveAction action) {
  return state.copyWith(
    isGINSaved: true,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

GINState _ginFilterSaveAction(
    GINState state, GINInitialFilterModelSaveAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      initialFilterModel: action.initialGinFilterModel);
}

GINState _updateDate2(GINState state, UpdateDate2 action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      dateFilter: GINDateFilterModel(
          toDate: action.filter.toDate, fromDate: action.filter.fromDate));
}

GINState _clearGin(GINState state, GINClearAction action) {
  return GINState.initial().copyWith(
      purchaseOrders: state.purchaseOrders,
      ginLocations: state.ginLocations,
      suppliers: state.suppliers);
}

GINState _ginSupplierGetAction(GINState state, GINSupplierGetAction action) {
  return state.copyWith(
    suppliers: action.suppliers,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

GINState _saveFilterAction(GINState state, SaveGINFilter action) {
  return state.copyWith(
    gnFilter: action.ginModelFilter,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

GINState _changeSupplierAction(GINState state, ChangeSuppliersAction action) {
  return state.copyWith(
    supplierList: action.suppliers,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

GINState _ginFilterChangeAction(
    GINState state, GInFilterDateChangeAction action) {
  return state.copyWith(
    dateFilter: action.ginDateFilterModel,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}

GINState _clearAction(GINState state, OnClearAction action) =>
    GINState.initial();

GINState _ginSourceAction(GINState state, GINSourceMappingDtlAction action) {
  GINModel ginModelData = state.ginDetails;
  GINSourceMappingDtlList result;
  ginModelData?.items?.forEach((element) {
    action.srcMapping.forEach((src) {
      if (src.itemid == element.itemId) result = src;
      return result;
    });
    element.itemSourceMapList = result;
  });
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      ginSrcList: action.srcMapping,
      ginDetails: ginModelData);
}

GINState _changeRemarksAction(GINState state, ChangeRemarksAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    remarks: action.val,
  );
}

GINState _changeLocationAction(GINState state, ChangeLocationAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    ginSelelctedLoc: action.ginSelectedLocation,
  );
}

GINState _ginLocationsAction(GINState state, GINLocationAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    ginLocations: action.ginLocations,
  );
}

//List<PoModel> porders = [];
GINState _fetchPOsAction(GINState state, POListFetchSuccessAction action) {
  // porders.addAll(action.orders);
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    purchaseOrders: action.orders,
  );
}

GINState _fetchGINAction(GINState state, GINFetchSuccessAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      ginDetails: action.ginModel,
      ginEditedId: 0);
}

GINState _ginSavedListAction(GINState state, GINViewListModelAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    savedViewListModel: action.ginViewListDataListModel,
  );
}

GINState _updateDate(GINState state, UpdateDate action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    filterRange: GINFilterModel(
        dateRange: DateTimeRange(
      start: action.filter.fromDate,
      end: action.filter.toDate,
    )),
  );
}

GINState _ginViewDtlAction(GINState state, GINViewDtlListModelAction action) {
  List<BranchStockLocation> ginLocations = state.ginLocations;
  BranchStockLocation dtlLocation;
  List<GINItemModel> itemList = [];
  GINItemModel selectedGINItem;
  state.ginLocations.forEach((element) {
    if (element.id == action.ginViewDtl.dtlList.first.blreftabledataid &&
        element.branchid == action.ginViewDtl.dtlList.first.branchid)
      dtlLocation = element;
    return dtlLocation;
  });

  for (int i = 0;
      i < action.ginViewDtl.dtlList.first.ginDetailDtlList.length;
      i++) {
    selectedGINItem = GINItemModel(
        itemId: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].itemid,
        itemaccessedcode: action
            .ginViewDtl.dtlList.first.ginDetailDtlList[i].itemaccessedcode,
        itemaccessedcodetypebccid: action.ginViewDtl.dtlList.first
            .ginDetailDtlList[i].itemaccessedcodetypebccid,
        itemCode: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].itemcode,
        itemName: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].itemname,
        uomId: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].uomid,
        uomtypebccid:
            action.ginViewDtl.dtlList.first.ginDetailDtlList[i].uomtypebccid,
        fccurrencyid:
            action.ginViewDtl.dtlList.first.ginDetailDtlList[i].fccurrencyid,
        exchrate: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].exchrate,
        receivedQty: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].poqty,
        qty: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].qty,
        isItemReceived: true,
        id: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].Id,
        uom: action
            .ginViewDtl.dtlList.first.ginDetailDtlList[i].uomDtl.first.uomname,
        itemWiseQtyDtl: GINItemWiseQtyDtl(
            id: action.ginViewDtl.dtlList.first.ginDetailDtlList.first
                .itemWiseQtyDtl.first.id,
            uomtypebccid: action.ginViewDtl.dtlList.first.ginDetailDtlList.first
                .itemWiseQtyDtl.first.uomtypebccid),
        itemSourceMapList: GINSourceMappingDtlList(
            id: action.ginViewDtl.dtlList.first.ginDetailDtlList[i]
                .srcMappingDtl.first.Id,
            refhdrtabledataid: action.ginViewDtl.dtlList.first
                .ginDetailDtlList[i].srcMappingDtl.first.refhdrtabledataid,
            refhdrtableid: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].srcMappingDtl.first.refhdrtableid,
            reftabledataid: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].srcMappingDtl.first.reftabledataid,
            reftableid: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].srcMappingDtl.first.reftableid,
            uomtypebccid: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].srcMappingDtl.first.generateduomtypebccid,
            uomid: action.ginViewDtl.dtlList.first.ginDetailDtlList[i].srcMappingDtl.first.generateduomid));
    itemList.add(selectedGINItem);
  }
  // SupplierModel.fromGIN(GINModel(
  //     supplierid: action.ginViewDtl.dtlList.first.supplierid,
  //     suppliername: action.ginViewDtl.dtlList.first.supplier,
  //     address1: action.ginViewDtl.dtlList.first.grnaddress1,
  //     address2: action.ginViewDtl.dtlList.first.grnaddress2,
  //     address3: action.ginViewDtl.dtlList.first.grnaddress3));

  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    ginSelelctedLoc: dtlLocation,
    viewDtlListModel: action.ginViewDtl,
    ginDetails: GINModel(
        supplierid: action.ginViewDtl.dtlList.first.supplierid,
        suppliername: action.ginViewDtl.dtlList.first.supplier,
        address1: action.ginViewDtl.dtlList.first.grnaddress1,
        address2: action.ginViewDtl.dtlList.first.grnaddress2,
        address3: action.ginViewDtl.dtlList.first.grnaddress3,
        branchid: action.ginViewDtl.dtlList.first.branchid,
        companyid: action.ginViewDtl.dtlList.first.companyid,
        finyearid: action.ginViewDtl.dtlList.first.finyearid,
        createddate: action.ginViewDtl.dtlList.first.createddate,
        createduserid: action.ginViewDtl.dtlList.first.createduserid,
        paymentmode: action.ginViewDtl.dtlList.first.paymentmode,
        grnno: action.ginViewDtl.dtlList.first.grnno,
        items: itemList),
    ginEditedId: 1,
  );
}

GINState _updateGINAction(GINState state, UpdateGINItemAction action) {
  GINModel gin = state.ginDetails;
  List<GINSourceMappingDtlList> sourceMappingDtlList = state.ginSrcList;
  GINModel ginModelData = state.ginDetails;
  GINSourceMappingDtlList result;
  ginModelData?.items?.forEach((element) {
    sourceMappingDtlList.forEach((src) {
      if (src.itemid == element.itemId) result = src;
      return result;
    });
    element.itemSourceMapList = result;
  });
  sourceMappingDtlList.forEach((src) {
    gin.items.forEach((element) {
      if (element.itemId == action.item.itemId) {
        element.receivedQty = action.item.receivedQty;
        element.isItemReceived = action.item.isItemReceived;
      }
      if (element.itemId == src.itemid) {
        element.itemSourceMapList = src;
      }
    });
  });

  return state.copyWith(
    ginDetails: gin,
  );
}

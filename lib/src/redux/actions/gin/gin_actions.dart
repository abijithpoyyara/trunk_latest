import 'package:base/redux.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_sourcemapping_dtl_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_dtl_list_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_list_data.dart';
import 'package:redstars/src/services/model/response/gin/po_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/repository/gin/gin_repository.dart';
import 'package:redstars/src/widgets/screens/gin/model/gin_filter_model.dart';

class POListFetchSuccessAction {
  final List<PoModel> orders;
  final GINFilterModel filters;
  final double offset;

  POListFetchSuccessAction(
    this.orders,
    this.filters,
    this.offset,
  );
}

class GINClearAction {}

class GInFilterDateChangeAction {
  final GINDateFilterModel ginDateFilterModel;
  GInFilterDateChangeAction(this.ginDateFilterModel);
}

class GINInitialFilterModelSaveAction {
  final GINFilterModel initialGinFilterModel;

  GINInitialFilterModelSaveAction(this.initialGinFilterModel);
}

class SaveSearchSupplierAction {
  final SupplierLookupItem savedSupoplierLookup;
  SaveSearchSupplierAction(this.savedSupoplierLookup);
}

class GINViewListModelAction {
  final GINViewListDataListModel ginViewListDataListModel;
  GINViewListModelAction(this.ginViewListDataListModel);
}

class SaveGINFilter {
  final GINFilterModel ginModelFilter;
  SaveGINFilter(this.ginModelFilter);
}

class GINViewDtlListModelAction {
  final GINViewDetailModel ginViewDtl;
  GINViewDtlListModelAction(this.ginViewDtl);
}

class ChangeSuppliersAction {
  List<dynamic> suppliers;
  ChangeSuppliersAction(this.suppliers);
}

class UpdateDate {
  GINFilterModel filter;
  UpdateDate(this.filter);
}

class UpdateDate2 {
  GINDateFilterModel filter;
  UpdateDate2(this.filter);
}

class ChangeLocationAction {
  final BranchStockLocation ginSelectedLocation;
  ChangeLocationAction(this.ginSelectedLocation);
}

class ChangeRemarksAction {
  final String val;
  ChangeRemarksAction(this.val);
}

class GINKhatSaveAction {
  bool ginKhatSave;
  GINKhatSaveAction();
}

class GINFetchSuccessAction {
  final GINModel ginModel;

  GINFetchSuccessAction(this.ginModel);
}

class GINLocationAction {
  final List<BranchStockLocation> ginLocations;
  GINLocationAction(this.ginLocations);
}

class GINSourceMappingDtlAction {
  final List<GINSourceMappingDtlList> srcMapping;

  GINSourceMappingDtlAction(this.srcMapping);
}

class UpdateGINItemAction {
  final GINItemModel item;

  UpdateGINItemAction(this.item);
}

class GINSupplierGetAction {
  final List<SupplierLookupItem> suppliers;
  GINSupplierGetAction(this.suppliers);
}

ThunkAction savegin({
  PoModel poModel,
  GINModel ginModel,
  List<GINItemModel> items,
  List<GINSourceMappingDtlList> ginSourceMappingList,
  BranchStockLocation location,
  String remarks,
  int optionId,
  int editId,
  GINViewDetailList dtlList,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving GIN",
        // type: 'GIN',
      ));
      GINRepository().saveGIN(
        poModel: poModel,
        ginModel: ginModel,
        items: items,
        ginSourceMappingList: ginSourceMappingList,
        location: location,
        remarks: remarks,
        optionId: optionId,
        dtlViewList: dtlList,
        editId: editId,
        onRequestSuccess: () {
          store.dispatch(GINKhatSaveAction());
        },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
          // type: "GIN"
        )),
      );
    });
  };
}

ThunkAction saveGINACtion({
  PoModel poModel,
  GINModel ginModel,
  List<GINItemModel> items,
  List<GINSourceMappingDtlList> ginSourceMappingList,
  BranchStockLocation location,
  String remarks,
  int optionId,
  int editId,
  GINViewDetailList dtlList,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(
          LoadingAction(status: LoadingStatus.loading, message: "Saving"));
      GINRepository().saveGIN(
          poModel: poModel,
          ginModel: ginModel,
          items: items,
          ginSourceMappingList: ginSourceMappingList,
          location: location,
          remarks: remarks,
          optionId: optionId,
          dtlViewList: dtlList,
          editId: editId,
          onRequestSuccess: () {
            store.dispatch(GINKhatSaveAction());
          },
          onRequestFailure: (error) {
            store.dispatch(LoadingAction(
                status: LoadingStatus.error, message: error.toString()));
          });
    });
  };
}

ThunkAction fetchGInViewDtlModelDetails(
    {int start,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int optionId,
    GINDateFilterModel filterModel,
    GINViewListDataList id}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      GINRepository().getGINViewDtlList(
        start: 0,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        optionId: optionId,
        filterModel: filterModel,
        valueId: id,
        onRequestSuccess: (result) =>
            store.dispatch(new GINViewDtlListModelAction(result)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchGInSavedData(
    {int start,
    int optionId,
    GINDateFilterModel filterModel,
    int sor_id,
    int eor_id,
    int totalrecords,
    // PurchaseViewListModel model,
    List<GINViewListDataList> listData}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      GINRepository().getGINSavedListView(
        start: start,
        ginFilter: filterModel,
        sor_Id: sor_id,
        eor_Id: eor_id,
        optionId: optionId,
        totalRecords: totalrecords,
        onRequestSuccess: (status) {
          // start += 10;
          // sor_id = status.SOR_Id;
          // eor_id = status.EOR_Id;
          // totalrecords = status.totalRecords;
          listData.addAll(status.ginSavedViewList);
          store.dispatch(new GINViewListModelAction(status));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchGinSuppliers() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      GINRepository().getGINSuplliers(
        start: 0,
        onRequestSuccess: (status) {
          store.dispatch(new GINSupplierGetAction(status));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchPOList({
  GINFilterModel filters,
  double offset,
  int start = 0,
  int sorid,
  int eorid,
  int totalRecords,
  List<PoModel> listData,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
        //  type: 'GIN',
      ));
      GINRepository().getPurchaseOrders(
        filter: filters,
        start: start,
        sorId: sorid,
        eorId: eorid,
        totalRecords: totalRecords,
        onRequestSuccess: (orders) {
          listData?.addAll(orders);
          store.dispatch(POListFetchSuccessAction(orders, filters, offset));
        },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
            type: "GIN")),
      );
    });
  };
}

ThunkAction fetchInitialData() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
        // type: 'GIN',
      ));

      GINRepository().getLocationList(
        onRequestSuccess: (ginLoc) {
          store.dispatch(GINLocationAction(ginLoc));
        },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
          //type: "GIN"
        )),
      );
    });
  };
}

ThunkAction fetchPODetails(PoModel order) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
        //type: 'GIN',
      ));
      GINRepository().getPODetails(
        po: order,
        onRequestSuccess: (gin) {
          store.dispatch(GINFetchSuccessAction(gin));
        },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
          //  type: "GIN"
        )),
      );
    });
  };
}

ThunkAction fetchPOSourceDetails(PoModel order) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
        // type: 'GIN',
      ));
      GINRepository().getPOSourceMappingDetails(
        po: order,
        onRequestSuccess: (gin) {
          store.dispatch(GINSourceMappingDtlAction(gin));
        },
        onRequestFailure: (error) => store.dispatch(LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
          //type: "GIN"
        )),
      );
    });
  };
}

import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/payment_voucher/purchase_order_process_from_list.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/transaction_status_model.dart';
import 'package:redstars/src/services/repository/requisition/stock_requisition/stock_requisition_repository.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_filter_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_requisition_model.dart';

enum StockRequisitionViews { STOCK_REQUISITION, STOCK_DETAIL }

class AddStockRequisitionAction {
  StockRequisitionModel item;

  AddStockRequisitionAction(this.item);
}

class SavingStockFilterAction {
  SRFilterModel filterModel;

  SavingStockFilterAction({this.filterModel});
}

class ItemBudgetDetails {
  List<BudgetDtlModel> itembudgetDtl;
  ItemBudgetDetails(this.itembudgetDtl);
}

class ItemsFetchAction {
  List<ItemLookupItem> items;
  ItemsFetchAction(this.items);
}

class StockLocationChangeAction {
  StockLocation location;
  bool isTarget;

  StockLocationChangeAction({this.location, this.isTarget});
}

class RemoveStockRequisitionAction {
  StockRequisitionModel item;

  RemoveStockRequisitionAction(this.item);
}

class RemoveSelectedStockRequisitionAction {
  SelectedStockViewModel item;
  RemoveSelectedStockRequisitionAction(this.item);
}

class TransactionStatusFetchAction {
  List<TransactionStatusItem> status;

  TransactionStatusFetchAction(this.status);
}

class StockViewListFectchAction {
  StockViewListModel stockViewListModel;
  StockViewListFectchAction(this.stockViewListModel);
}

class SelectedStockViewFetchAction {
  SelectedStockViewModel stockViewModel;
  SelectedStockViewFetchAction(this.stockViewModel);
}

class FetchActionStockViewList {
  StockViewListModel stockViewList;
  FetchActionStockViewList(this.stockViewList);
}

class StockLocationsFetchAction {
  List<StockLocation> locations;
  List<StockLocation> sources;
  int locationId;

  StockLocationsFetchAction(this.locations, this.sources, this.locationId);
}

class RequisitionSaveAction {}

class ItemStockDetailClearAction {}

class ItemDetailFetchAction {
  List<StockDetail> stockDtl;

  ItemDetailFetchAction(this.stockDtl);
}

ThunkAction fetchDataItems() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      StockRequisitionRepository().getItems(
        onRequestSuccess: (item) => store.dispatch(ItemsFetchAction(item)),
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
          status: LoadingStatus.loading, message: "Loading "));

      StockRequisitionRepository().getApprovalStatus(
          onRequestSuccess: (status) =>
              store.dispatch(new TransactionStatusFetchAction(status)),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: error.toString())));
      StockRequisitionRepository().getLocationObjects(
          onRequestSuccess: (locations, sources, locationId) => store.dispatch(
              StockLocationsFetchAction(locations, sources, locationId)),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: error.toString())));
    });
  };
}

ThunkAction fetchStockViewListData(
    {int start,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    SRFilterModel filterModel,
    List<StockViewList> listData}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading",
      ));
      StockRequisitionRepository().getStockView(
        start: start,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        filterModel: filterModel,
        onRequestSuccess: (status) {
          sor_Id = status.SOR_Id;
          eor_Id = status.EOR_Id;
          totalRecords = status.TotalRecords;
          listData.addAll(status.stockViewList);
          store.dispatch(new StockViewListFectchAction(status));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchSelectedStockViewListData({
  int start,
  SRFilterModel filterModel,
  int sor_Id,
  int eor_Id,
  int totalRecords,
  StockViewList stockList,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      StockRequisitionRepository().getSelectedStockView(
        start: 0,
        filterModel: filterModel,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        stockList: stockList,
        totalRecords: totalRecords,
        onRequestSuccess: (status) =>
            store.dispatch(new SelectedStockViewFetchAction(status)),
        onRequestFailure: (error) => store.dispatch(
          new LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
          ),
        ),
      );
    });
  };
}

ThunkAction fetchItemBudgetDtl({int optionId, int itemId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching Budget Details ",
      ));

      StockRequisitionRepository().getItemBudget(
          optionId: optionId,
          itemId: itemId,
          onRequestSuccess: (result) =>
              {store.dispatch(ItemBudgetDetails(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchStockDetails(ItemLookupItem item) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching Stock Details",
        type: StockRequisitionViews.STOCK_DETAIL,
      ));

      StockRequisitionRepository().getStockDetails(item?.id,
          onRequestSuccess: (stockDtl) =>
              store.dispatch(new ItemDetailFetchAction(stockDtl)),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error,
              message: error.toString(),
              type: StockRequisitionViews.STOCK_DETAIL)));
    });
  };
}

ThunkAction saveRequisitionAction({
  int optionId,
  int status,
  List<StockRequisitionModel> requisitionItems,
  SelectedStockViewModel stoItem,
  String remarks,
  StockLocation sourceLocation,
  StockLocation targetLocation,
  int stockReqId,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Requisition ",
      ));

      StockRequisitionRepository().saveRequisition(
        requisitionItems: requisitionItems,
        optionId: optionId,
        remarks: remarks,
        stoItem: stoItem,
        stockReqId: stockReqId,
        sourceLocation: sourceLocation,
        targetLocation: targetLocation,
        statusBccid: status,
        onRequestSuccess: () => store.dispatch(new RequisitionSaveAction()),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

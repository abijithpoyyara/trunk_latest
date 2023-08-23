import 'package:base/constants.dart';
import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/actions/requisition/stock_requisition/stock_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/requisition/stock_requisition/stock_requistion_state.dart';
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

import '../../../../../utility.dart';

class StockRequisitionViewModel extends BaseViewModel {
  final Function(StockRequisitionModel) onAdd;
  final Function(int, int, List<StockRequisitionModel>, String, int,
      SelectedStockViewModel) onSave;
  final List<StockRequisitionModel> requisitionItems;
  final List<StockRequisitionViewModel> requisitionStockItems;
  final List<TransactionStatusItem> status;
  final VoidCallback onClear;
  final int optionId;
  final ValueSetter<StockRequisitionModel> onRemoveItem;
  final ValueSetter<SelectedStockViewModel> onStockRemoveItem;
  final bool isSaved;
  final StockLocation selectedDestinationLocation;
  final StockLocation selectedSourceLocation;
  final List<StockLocation> sourceLocations;
  final List<StockLocation> destinationLocations;
  final List<StockDetail> stockDetails;
  final List<BudgetDtlModel> itemBudgetDtl;
  final List<DepartmentItem> departmentList;
  final List<BranchStockLocation> branchList;
  final Function(
          SRFilterModel result, int start, double position, List<StockViewList>)
      onSRFilterSubmit;
  final SRFilterModel model;
  final Function(SRFilterModel model) onSRFilter;
  final Function(SRFilterModel result) onSubmit;
  final Function(ItemLookupItem) onItemBudget;
  final Function(StockLocation location, bool bool) onLocationChange;
  final LoadingStatus stockDtlLoading;
  final double scrollPosition;
  final StockViewListModel stockViewListModel;
  final List<StockViewList> stockViewList;
  final Function(StockViewList, SRFilterModel) onStockView;
  final SelectedStockViewModel selectedStockViewModel;
  final List<SelectedStockViewModel> selectedStockItems;
  final int stockReqId;
  final SelectedStockViewModel stoItem;

  StockRequisitionViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.stoItem,
    this.stockReqId,
    this.onSubmit,
    this.stockViewList,
    this.departmentList,
    this.branchList,
    this.onSRFilterSubmit,
    this.model,
    this.onSRFilter,
    this.itemBudgetDtl,
    this.onAdd,
    this.isSaved,
    this.onSave,
    this.requisitionItems,
    this.requisitionStockItems,
    this.status,
    this.optionId,
    this.onRemoveItem,
    this.scrollPosition,
    this.onClear,
    this.selectedDestinationLocation,
    this.selectedSourceLocation,
    this.sourceLocations,
    this.destinationLocations,
    this.onItemBudget,
    this.onLocationChange,
    this.stockDetails,
    this.stockDtlLoading,
    this.stockViewListModel,
    this.onStockView,
    this.selectedStockItems,
    this.selectedStockViewModel,
    this.onStockRemoveItem,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory StockRequisitionViewModel.fromStore(Store<AppState> store) {
    StockRequisitionState state =
        store.state.requisitionState.stockRequisitionState;
    var optionId = store.state.homeState.selectedOption.optionId;
    return StockRequisitionViewModel(
        loadingStatus: state.loadingStatus,
        stockDtlLoading: state.stockDtlLoading,
        errorMessage: state.loadingError,
        loadingMessage: state.loadingMessage,
        requisitionItems: state.stockItems,
        stockReqId: state.stockReqId,
        // selectedStockItems: state.,
        status: state.status,
        optionId: optionId,
        sourceLocations: state.sourceLocations,
        destinationLocations: state.locations,
        selectedDestinationLocation: state.selectedDestinationLocation,
        selectedSourceLocation: state.selectedSourceLocation,
        isSaved: state.saved,
        stockDetails: state.stockDetails,
        itemBudgetDtl: state.itemBudgetDtl,
        departmentList: state.departmentList,
        branchList: state.branchList,
        scrollPosition: state.scrollPosition,
        model: state.filterModel,
        stoItem: state.stockViewModel,
        stockViewList: state.stockViewList,
        stockViewListModel: state.viewListModel,
        selectedStockViewModel: state.stockViewModel,
        onStockView: (detailModel, filterModel) {
          store.dispatch(fetchSelectedStockViewListData(
            start: 0,
            sor_Id: detailModel?.SOR_Id ?? detailModel.start,
            eor_Id: detailModel?.EOR_Id ?? detailModel.limit,
            totalRecords: detailModel?.TotalRecords,
            stockList: detailModel,
            filterModel: SRFilterModel(
                fromDate: filterModel.fromDate ?? state.fromDate,
                toDate: filterModel.toDate ?? state.toDate),
            // result: detailModel.stockViewList.
          ));
          // resultdata: detailModel?.stockViewList?.first));
        },
        onSRFilter: (filterModel) {
          store.dispatch(SavingStockFilterAction(filterModel: filterModel));
        },
        onSubmit: (result) {
          store.dispatch(fetchStockViewListData(
              listData: [],
              start: 0,
              filterModel: SRFilterModel(
                fromDate: result?.fromDate,
                toDate: result?.toDate,
                location: result?.location,
              )));
        },
        onSRFilterSubmit: (result, start, position, model) {
          print("Start----$start");
          store.dispatch(fetchStockViewListData(
            listData: model,
            start: start,
            filterModel: SRFilterModel(
              fromDate: result?.fromDate,
              toDate: result?.toDate,
              location: result?.location,
            ),
          ));
        },
        onSave: (optionId, statusId, items, remarks, stockReqId, stoItem) {
          store.dispatch(saveRequisitionAction(
              optionId: optionId,
              status: statusId,
              requisitionItems: items,
              remarks: remarks,
              stoItem: stoItem,
              stockReqId: stockReqId,
              sourceLocation: state.selectedSourceLocation,
              targetLocation: state.selectedDestinationLocation));
        },
        onItemBudget: (
          item,
        ) {
          return store.dispatch(fetchItemBudgetDtl(
            optionId: optionId,
            itemId: item.id,
          ));
        },
        onClear: () => {
              store.dispatch(OnClearAction()),
              store.dispatch(fetchInitialData()),
            },
        onRemoveItem: (item) =>
            store.dispatch(RemoveStockRequisitionAction(item)),
        onStockRemoveItem: (item) =>
            store.dispatch(RemoveSelectedStockRequisitionAction(item)),
        onLocationChange: (location, isTarget) {
          store.dispatch(StockLocationChangeAction(
              isTarget: isTarget, location: location));
        },
        onAdd: (model) => store.dispatch(AddStockRequisitionAction(model)));
  }

  void saveRequisition({
    String remarks,
  }) {
    int statusBccId = status
            .firstWhere((element) => element.code == 'PREPARED',
                orElse: () => null)
            ?.id ??
        0;

    onSave(
        optionId, statusBccId, requisitionItems, remarks, stockReqId, stoItem);
  }

  int departId;
  Future<int> depat() async {
    departId = await BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
    print(departId);
    return departId;
  }

  String validateSave() {
    var id = depat();
    String message = "";
    bool valid = true;
    print("userid$id");
    //  var  departId= BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);

    if (valid) {
      if (id == null) {
        print("userid$id");
        message = "User has no department.";
        valid = false;
      } else if (selectedSourceLocation == null ||
          selectedDestinationLocation == null) {
        message =
            "Please select ${selectedDestinationLocation == null ? "target" : "source"} location";
        valid = false;
      }
    }

    return message;
  }

  void onLoadMore(SRFilterModel model, int start, double position,
      List<StockViewList> list) {
    print("Start----$start");
    onSRFilterSubmit(model, start, position, list);
  }

  // String validateItems() {
  //   String message = "";
  //   bool valid = true;
  //   itemBudgetDtl ?.forEach((element) {
  //     var item = element.itemid;
  //     var itemName;
  //     var totalValue;
  //     requisitionItems.forEach((ele) {
  //       totalValue=double.parse(( (ele.qty*element.itemcost))?.toStringAsFixed(2));
  //       if(ele.item.id==item){
  //         itemName=ele.item.description;
  //       }
  //       return itemName;
  //     });
  //
  //
  //     if (valid) {
  //       if (element.budgeted==0) {
  //         message = "Budget not defined for $itemName ";
  //         valid = false;
  //       }
  //       else if((element.budgeted>0)&&(totalValue>element.remaining)){
  //         message="Amount cannot be greater than Remaining Amount" ;
  //         valid=false;
  //
  //       }else if(element.budgetreqyn && element.budgetreqyn=="N"){
  //         if(element.budgeted>0){
  //           message="Following item $itemName defined as budget exempted but it seems to be linked with a ledger having budget.";
  //         }}
  //     }
  //   });
  //   return message;
  // }
}

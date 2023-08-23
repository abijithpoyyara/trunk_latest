import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/actions/item_grade_rate_settings/item_grade_rate_settings_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/item_grade_rate_settings/item_grade_rate_settings_state.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_initail_model.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_view_details_page_model.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_view_page_model.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_filter_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_sub_model.dart';

class ItemGradeRateViewModel extends BaseViewModel {
  final Function(ItemGradeRateSubModel) onAdd;
  final Function() onSave;
  final VoidCallback onClear;
  final int optionId;
  final ValueSetter<ItemGradeRateSubModel> onRemoveItem;
  final ValueSetter<SelectedStockViewModel> onStockRemoveItem;
  final bool isSaved;
  final StockLocation selectedDestinationLocation;
  final List<BusinessSubLevelObjModel> businessSubLevelObj;
  final List<StockLocation> itemGradeRateLocationObj;
  final List<BusinessLevelObjModel> businessLevelObj;
  final List<BCCModel> currencyList;
  final List<ItemGradeRateSubModel> itemGradeRateListData;
  final StockLocation selectedLocation;
  final Function(StockLocation location) onLocationChange;
  final List<GradeLookupItem> gradeLists;
  final DateTime selectedDate;
  final Function(DateTime) onDateChange;
  final ItemGradeRateSettingsFilterModel filterModel;
  final ItemGradeRateSettingsViewDetailPageListModel detailPageListModel;
  final ItemGradeRateSettingsViewPageModel viewPageModel;
  final Function(int start, ItemGradeRateViewModel model,
      ItemGradeRateSettingsFilterModel filter) onGetItemGradeRateViewPage;
  final Function(int start, ItemGradeRateSettingsViewPageList pageList,
      ItemGradeRateSettingsFilterModel filter) onGetItemGradeRateViewDetailPage;
  final List<ItemLookupItem> items;
  final double scrollPosition;
  final DateTime frmDate;
  final DateTime toDate;
  final List<ItemLookupItem> listItemData;
  final Function(ItemGradeRateSettingsViewPageList id)
      onPendingItemGradeRateTap;
  final int itemDtlId;
  final Function(ItemGradeRateSettingsFilterModel filterModel) onFilterChange;
  final Function(ItemGradeRateSettingsFilterModel filterModel) onDataSubmission;
  final Function(ItemGradeRateSettingsFilterModel filter, int start,
      List<ItemGradeRateSettingsViewPageList> viewList) onClickSubms;
  final List<ItemLookupItem> changedItems;
  final Function(List<dynamic> changedItems) onChangeItems;

  ItemGradeRateViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.scrollPosition,
    this.businessSubLevelObj,
    this.itemGradeRateLocationObj,
    this.businessLevelObj,
    this.currencyList,
    this.itemGradeRateListData,
    this.selectedLocation,
    this.isSaved,
    this.optionId,
    this.onRemoveItem,
    this.onClear,
    this.selectedDestinationLocation,
    this.onStockRemoveItem,
    this.onLocationChange,
    this.onAdd,
    this.onSave,
    this.gradeLists,
    this.selectedDate,
    this.onDateChange,
    this.viewPageModel,
    this.detailPageListModel,
    this.filterModel,
    this.onGetItemGradeRateViewDetailPage,
    this.onGetItemGradeRateViewPage,
    this.items,
    this.frmDate,
    this.listItemData,
    this.toDate,
    this.onPendingItemGradeRateTap,
    this.itemDtlId,
    this.onFilterChange,
    this.onDataSubmission,
    this.onClickSubms,
    this.changedItems,
    this.onChangeItems,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory ItemGradeRateViewModel.fromStore(Store<AppState> store) {
    ItemGradeRateState state = store.state.itemGradeRateState;
    var optionId = store.state.homeState.selectedOption.optionId;

    return ItemGradeRateViewModel(
        loadingStatus: state.loadingStatus,
        errorMessage: state.loadingError,
        loadingMessage: state.loadingMessage,
        itemGradeRateListData: state.itemGradeRateListData,
        currencyList: state.currencyList,
        businessLevelObj: state.businessLevelObj,
        businessSubLevelObj: state.businessSubLevelObj,
        itemGradeRateLocationObj: state.itemGradeRateLocationObj,
        gradeLists: state.gradeListItemRate,
        selectedDate: state.selectedDate,
        detailPageListModel: state.detailPageListModel,
        filterModel: state.filterModel,
        viewPageModel: state.viewPageModel,
        items: state.items,
        frmDate: state.frmDate,
        toDate: state.toDate,
        listItemData: state.productData,
        scrollPosition: state.scrollPosition,
        changedItems: state.changedItems,
        // selectedStockItems: state.,
        optionId: optionId,
        selectedLocation: state.selectedLocation,
        isSaved: state.saved,
        itemDtlId: state.itemGradeRateDetailId,
        onChangeItems: (data) {
          store.dispatch(ChangeItemsAction(data));
        },
        onFilterChange: (filterModel) {
          store.dispatch(ItemGradeRateSettingFilterChangeAction(filterModel));
        },
        onDateChange: (date) {
          store.dispatch(ChangeDateAction(date));
        },
        onClickSubms: (
          filter,
          start,
          viewList,
        ) {
          store.dispatch(fetchItemGradeRateSettingsViewPageListData(
              optionId: optionId ?? 795,
              start: start,
              listData: viewList,
              filterModel: ItemGradeRateSettingsFilterModel(
                  fromDate: filter?.fromDate ?? state.toDate,
                  toDate: filter?.toDate ?? state.frmDate,
                  locObj: filter?.locObj ?? state.selectedLocation,
                  datas: filter.datas,
                  pricingNo: filter.pricingNo)));
        },
        onDataSubmission: (filter) {
          store.dispatch(fetchItemGradeRateSettingsViewPageListData(
              optionId: optionId,
              start: 0,
              listData: [],
              filterModel: ItemGradeRateSettingsFilterModel(
                  fromDate: filter?.fromDate ?? state.toDate,
                  toDate: filter?.toDate ?? state.frmDate,
                  locObj: filter?.locObj ?? state.selectedLocation,
                  datas: filter.datas,
                  pricingNo: filter.pricingNo)));
        },
        onPendingItemGradeRateTap: (valueId) {
          store.dispatch(fetchItemGradeRateViewDetailListData(
              optionId: optionId,
              start: 0,
              sor_Id: valueId.start,
              eor_Id: valueId.limit,
              totalRecords: valueId.totalrecords,
              filterModel: ItemGradeRateSettingsFilterModel(
                  fromDate: state.toDate,
                  toDate: state.frmDate,
                  locObj: state.selectedLocation,
                  pricingNo: ""),
              valueId: valueId));
        },
        onGetItemGradeRateViewDetailPage: (start, list, filter) {
          store.dispatch(fetchItemGradeRateViewDetailListData(
              optionId: optionId,
              filterModel: ItemGradeRateSettingsFilterModel(
                  fromDate: filter.fromDate,
                  toDate: filter.toDate,
                  locObj: filter.locObj,
                  pricingNo: filter.pricingNo)));
        },
        onGetItemGradeRateViewPage: (start, list, filter) {
          store.dispatch(fetchItemGradeRateSettingsViewPageListData(
              filterModel: ItemGradeRateSettingsFilterModel(
                  fromDate: filter.fromDate,
                  toDate: filter.toDate,
                  locObj: filter.locObj,
                  pricingNo: filter.pricingNo)));
        },
        onSave: () {
          store.dispatch(saveItemGradeRateSettingsAction(
              optionId: optionId,
              dtlModel: state.detailPageListModel,
              itemDtlId: state.itemGradeRateDetailId,
              pricingWefdate: state.selectedDate,
              itemGradeRateListDataItems: state.itemGradeRateListData,
              sourceLocation: state.selectedLocation,
              businessLevelObj: state.businessLevelObj));
        },
        onClear: () => {
              store.dispatch(ItemGradeRatClearAction()),
              //  store.dispatch(fetchInitialData()),
            },
        onLocationChange: (location) {
          store.dispatch(ItemGradeRateLocationChangeAction(location: location));
        },
        onRemoveItem: (item) =>
            store.dispatch(RemoveItemGradeRateRequisitionAction(item)),
        // onStockRemoveItem: (item) =>
        //     store.dispatch(RemoveSelectedStockRequisitionAction(item)),
        onAdd: (model) => store.dispatch(AddNewItemGradeRateAction(model)));
  }

// String validateSave() {
//   var id = depat();
//   String message = "";
//   bool valid = true;
//   print("userid$id");
//   //  var  departId= BasePrefs.getInt(BaseConstants.USER_DEPARTMENT_ID);
//
//   if (valid) {
//     if (id == null) {
//       print("userid$id");
//       message = "User has no department.";
//       valid = false;
//     } else if (selectedSourceLocation == null ||
//         selectedDestinationLocation == null) {
//       message =
//           "Please select ${selectedDestinationLocation == null ? "target" : "source"} location";
//       valid = false;
//     }
//   }
//
//   return message;
// }
//

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

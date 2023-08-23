import 'package:base/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:redstars/src/redux/actions/pricing/pricing_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/pricing/pricing_state.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/services/model/response/pricing/itemdetails_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/pricing/model/pricing_model.dart';

class PricingViewModel extends BaseViewModel {
  final List<ItemGroupLookupItem> itemGroupItems;
  final List<ItemGroupLookupItem> itemModelItems;
  final List<ItemGroupLookupItem> itemBrandItems;
  final List<ItemGroupLookupItem> classificationItems;
  final List<ItemGroupLookupItem> brandItems;
  final ItemGroupLookupItem selectedItem;
  final List<StockLocation> location;
  final StockLocation selectedLocation;
  final StockLocation otherLocation;
  final List<StockLocation> copyToOtherLocation;
  final List<ItemDetailListItems> itemDtl;
  final ItemDetailListItems selectedItems;
  final List<ItemLookupItem> items;
  final List<LocationLookUpItem> locationItems;
  final List<LocationLookUpItem> multipleItems;
  final List<ItemGroup> itemGList;
  final Function(PricingModel) onAdd;
  //final Function(List<ItemGroupLookupItem>, List<ItemLookupItem>) onViewDetails;
  final Function(PricingModel) onViewDetails;
  final Function(double) loadMoreItems;
  final int totalRecords;
  // final int start;
  final String itemGpSearch;
  final String itemBrandSearch;
  final String itemModelSearch;
  final String brandSearch;
  final String classificationSearch;
  final VoidCallback onClearItemGrpSearch;
  final Function(String) onItemGrpSearch;
  final VoidCallback onClearItemModelSearch;
  final Function(String) onItemModelSearch;
  final VoidCallback onClearItemBrandSearch;
  final Function(String) onItemBranSearch;
  final VoidCallback onClearBrandSearch;
  final Function(String) onBrandSearch;
  final VoidCallback onClearClassificationSearch;
  final Function(String) onClassificationSearch;
  final Function(List<LocationLookUpItem> multiLocation) onMultiLocationSelect;
  final Function(StockLocation location, bool bool) onLocationChange;
  final Function() placePricing;
  final bool isSelected;

  // final Function(int, int, List<StockRequisitionModel>, String) onSave;
  final PricingModel pricingItems;
  final PricingModel model;

  // final List<TransactionStatusItem> status;
  final VoidCallback onClear;
  final int optionId;
  final ValueSetter<PricingModel> onRemoveItem;
  final bool isSaved;

  PricingViewModel(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      String errorMessage,
      this.model,
      this.isSelected,
      this.items,
      this.locationItems,
      this.multipleItems,
      this.selectedLocation,
      this.placePricing,
      this.loadMoreItems,
      this.classificationSearch,
      this.brandSearch,
      this.itemBrandSearch,
      this.itemModelSearch,
      this.itemGpSearch,
      this.onBrandSearch,
      this.onClearBrandSearch,
      this.onClassificationSearch,
      this.onClearClassificationSearch,
      this.onClearItemBrandSearch,
      this.onClearItemGrpSearch,
      this.onClearItemModelSearch,
      this.onItemBranSearch,
      this.onItemGrpSearch,
      this.onLocationChange,
      this.onItemModelSearch,
      this.onViewDetails,
      this.totalRecords,
      this.pricingItems,
      this.isSaved,
      this.optionId,
      this.onRemoveItem,
      this.onClear,
      this.onAdd,
      this.onMultiLocationSelect,
      this.otherLocation,
      this.location,
      this.selectedItem,
      this.brandItems,
      this.classificationItems,
      this.copyToOtherLocation,
      this.itemBrandItems,
      this.itemDtl,
      this.itemGroupItems,
      this.itemModelItems,
      this.itemGList,
      this.selectedItems})
      : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory PricingViewModel.fromStore(Store<AppState> store) {
    PricingState state = store.state.pricingState;
    var optionId = store.state.homeState.selectedOption.optionId;
    return PricingViewModel(
        loadingStatus: state.loadingStatus,
        errorMessage: state.loadingError,
        loadingMessage: state.loadingMessage,
        optionId: optionId,
        isSelected: state.multiselectModel != null,
        isSaved: state.saved,
        model: state.model,
        multipleItems: state.multiLocation,
        itemModelSearch: state.itemModelSearch,
        itemGpSearch: state.itemGpSearch,
        itemBrandSearch: state.itemBrandSearch,
        brandSearch: state.brandSearch,
        classificationSearch: state.classificationSearch,
        totalRecords: state.totalRecords,
        itemBrandItems: state.itemBrandItems,
        itemGroupItems: state.itemGroupItems,
        itemModelItems: state.itemModelItems,
        classificationItems: state.classificationItems,
        brandItems: state.brandItems,
        selectedItems: state.selectedItems,
        selectedItem: state.selectedItem,
        locationItems: state.locationItems,
        selectedLocation: state.selectedLocation,
        location: state.location,
        copyToOtherLocation: state.copyToOtherLocation,
        itemGList: state.itemGList,
        items: state.items,
        otherLocation: state.otherLocation,
        onClear: () => store.dispatch(ItemDetailClearAction()),
        onClearItemModelSearch: () {
          store.dispatch(onSearchItemModelAction(""));
        },
        onItemModelSearch: (query) {
          store.dispatch(onSearchItemModelAction(query));
        },
        onMultiLocationSelect: (data) {
          store.dispatch(MultiLocationSelectAction(data));
        },
        onAdd: (model) => store.dispatch(ViewDetailsAction(model)),
        onClearItemGrpSearch: () {
          store.dispatch(onSearchItemGrpAction(""));
        },
        onItemGrpSearch: (query) {
          store.dispatch(onSearchItemGrpAction(query));
        },
        onClearItemBrandSearch: () {
          store.dispatch(onSearchItemBrandAction(""));
        },
        onItemBranSearch: (query) {
          store.dispatch(onSearchItemBrandAction(query));
        },
        onClearBrandSearch: () {
          store.dispatch(onSearchBrandAction(""));
        },
        onBrandSearch: (query) {
          store.dispatch(onSearchBrandAction(query));
        },
        onClearClassificationSearch: () {
          store.dispatch(onSearchClassificationAction(""));
        },
        onClassificationSearch: (query) {
          store.dispatch(onSearchClassificationAction(query));
        },
        onLocationChange: (location, isTarget) {
          store.dispatch(
              CopyToLocationChange(isTarget: isTarget, location: location));
        },
        onViewDetails: (model) {
          store.dispatch(fetchItemDetails(model.items, model.finalAry));
        },
        placePricing: () {
          store.dispatch(savePricing(
              optionId: 49,
              // requisitionItems: state.pricingItems,
              sourceLocation: state.selectedLocation,
              targetLocation: state.otherLocation,
              itemDetails: state.itemDtl,
              locationItems: state.multiLocation));
        },
        loadMoreItems: (position) {
          store.dispatch(fetchItemGrpProducts(
            start: state.start,
            eorId: state.eorId,
            sorId: state.eorId,
            totalRecords: state.totalRecords,
            name: state.itemGpSearch,
            scrollPosition: position,
          ));
        },
        itemDtl: state.itemDtl);
  }

// void saveRequisition({
//   String remarks,
// }) {
//   int statusBccId = status
//       .firstWhere((element) => element.code == 'PREPARED',
//       orElse: () => null)
//       ?.id ??
//       0;
//
//   onSave(optionId, statusBccId, requisitionItems, remarks);
// }
//
// String validateSave() {
//   String message;
//   if (selectedSourceLocation == null || selectedDestinationLocation == null) {
//     message =
//     "Please select ${selectedDestinationLocation == null ? "target" : "source"} location";
//   }
//   return message;
// }
}

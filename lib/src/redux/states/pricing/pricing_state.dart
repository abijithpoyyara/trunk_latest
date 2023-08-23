import 'package:base/redux.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/services/model/response/pricing/itemdetails_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/pricing/model/pricing_model.dart';

@immutable
class PricingState extends BaseState {
  final List<ItemGroupLookupItem> itemGroupItems;
  final List<ItemGroupLookupItem> itemModelItems;
  final List<ItemGroupLookupItem> itemBrandItems;
  final List<ItemGroupLookupItem> classificationItems;
  final List<ItemGroupLookupItem> brandItems;
  final List<ItemLookupItem> items;
  final List<LocationLookUpItem> locationItems;
  final List<LocationLookUpItem> multiLocation;
  final LocationLookupModel multiselectModel;
  final bool saved;
  final bool isSelected;
  final ItemGroupLookupItem selectedItem;
  final List<StockLocation> location;
  final StockLocation selectedLocation;
  final StockLocation selectedSourceLocation;
  final StockLocation selectedDestinationLocation;
  final List<StockLocation> copyToOtherLocation;
  final List<ItemDetailListItems> itemDtl;
  final ItemDetailListItems selectedItems;
  final List<PricingModel> pricingItems;
  final PricingModel model;
  final List<ItemGroup> itemGList;
  final StockLocation otherLocation;
  final int eorId;
  final int sorId;
  final int totalRecords;
  final int start;
  final String itemSearch;
  final String locationSearch;
  final String itemGpSearch;
  final String itemBrandSearch;
  final String itemModelSearch;
  final String brandSearch;
  final String classificationSearch;
  final bool onSearch;

  PricingState(
      {LoadingStatus loadingStatus,
      String loadingError,
      String loadingMessage,
      this.multiselectModel,
      this.locationItems,
      this.multiLocation,
      this.isSelected,
      this.locationSearch,
      this.itemSearch,
      this.model,
      this.saved,
      this.items,
      this.pricingItems,
      this.selectedSourceLocation,
      this.selectedDestinationLocation,
      this.onSearch,
      this.eorId,
      this.sorId,
      this.totalRecords,
      this.start,
      this.selectedLocation,
      this.brandSearch,
      this.itemBrandSearch,
      this.classificationSearch,
      this.itemModelSearch,
      this.itemGpSearch,
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
      this.selectedItems,
      this.itemGList})
      : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  PricingState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    List<ItemGroupLookupItem> itemGroupItems,
    List<ItemGroupLookupItem> itemModelItems,
    List<ItemGroupLookupItem> itemBrandItems,
    List<ItemGroupLookupItem> classificationItems,
    List<ItemGroupLookupItem> brandItems,
    ItemGroupLookupItem selectedItem,
    List<StockLocation> location,
    StockLocation selectedLocation,
    List<StockLocation> copyToOtherLocation,
    List<ItemDetailListItems> itemDtl,
    ItemDetailListItems selectedItems,
    List<ItemGroup> itemGList,
    StockLocation otherLocation,
    int eorId,
    int sorId,
    int totalRecords,
    bool onSearch = false,
    bool saved,
    int start,
    String itemGpSearch,
    String itemBrandSearch,
    String itemModelSearch,
    String brandSearch,
    String classificationSearch,
    StockLocation selectedSourceLocation,
    StockLocation selectedDestinationLocation,
    List<PricingModel> pricingItems,
    PricingModel model,
    List<ItemLookupItem> items,
    List<LocationLookUpItem> multiLocation,
    List<LocationLookUpItem> locationItems,
    String locationSearch,
    String itemSearch,
    bool isSelected,
    LocationLookupModel multiselectModel,
  }) {
    return PricingState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingError: loadingError ?? this.loadingError,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        itemBrandItems: itemBrandItems ?? this.itemBrandItems,
        itemGroupItems: itemGroupItems ?? this.itemGroupItems,
        itemModelItems: itemModelItems ?? this.itemModelItems,
        items: items ?? this.items,
        isSelected: isSelected ?? this.isSelected,
        itemDtl: itemDtl ?? this.itemDtl,
        eorId: onSearch ? eorId : eorId ?? this.eorId,
        sorId: onSearch ? sorId : sorId ?? this.sorId,
        multiselectModel: multiselectModel ?? this.multiselectModel,
        totalRecords:
            onSearch ? totalRecords : totalRecords ?? this.totalRecords,
        start: onSearch ? 0 : start ?? this.start,
        classificationItems: classificationItems ?? this.classificationItems,
        brandItems: brandItems ?? this.brandItems,
        selectedItems: selectedItems ?? this.selectedItems,
        selectedItem: selectedItem ?? this.selectedItem,
        selectedLocation: selectedLocation ?? this.selectedLocation,
        selectedDestinationLocation:
            selectedDestinationLocation ?? this.selectedDestinationLocation,
        selectedSourceLocation:
            selectedSourceLocation ?? this.selectedSourceLocation,
        location: location ?? this.location,
        copyToOtherLocation: copyToOtherLocation ?? this.copyToOtherLocation,
        itemGList: itemGList ?? this.itemGList,
        otherLocation: otherLocation ?? this.otherLocation,
        brandSearch: brandSearch ?? this.brandSearch,
        classificationSearch: classificationSearch ?? this.classificationSearch,
        itemBrandSearch: itemBrandSearch ?? this.itemBrandSearch,
        itemGpSearch: itemGpSearch ?? this.itemGpSearch,
        itemSearch: itemSearch ?? this.itemSearch,
        locationSearch: locationSearch ?? this.locationSearch,
        itemModelSearch: itemModelSearch ?? this.itemModelSearch,
        model: model ?? this.model,
        pricingItems: pricingItems ?? this.pricingItems,
        locationItems: locationItems ?? this.locationItems,
        multiLocation: multiLocation ?? this.multiLocation,
        saved: saved ?? this.saved);
  }

  factory PricingState.initial() {
    return PricingState(
        loadingStatus: LoadingStatus.success,
        loadingError: "",
        loadingMessage: "",
        brandSearch: "",
        classificationSearch: "",
        itemBrandSearch: "",
        itemGpSearch: "",
        itemModelSearch: "",
        start: 0,
        eorId: null,
        sorId: null,
        totalRecords: null,
        itemDtl: List(),
        itemModelItems: List(),
        itemGroupItems: List(),
        itemBrandItems: List(),
        classificationItems: List(),
        brandItems: List(),
        selectedLocation: null,
        selectedSourceLocation: null,
        selectedDestinationLocation: null,
        model: null,
        saved: false,
        isSelected: false,
        pricingItems: List(),
        selectedItem: null,
        selectedItems: null,
        location: List(),
        itemGList: List(),
        items: List(),
        locationItems: List(),
        multiLocation: List(),
        multiselectModel: null,
        copyToOtherLocation: List());
  }
}

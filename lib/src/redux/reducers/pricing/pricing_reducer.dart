import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/pricing/pricing_action.dart';
import 'package:redstars/src/redux/states/pricing/pricing_state.dart';

final pricingReducer = combineReducers<PricingState>([
  TypedReducer<PricingState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<PricingState, OnClearAction>(_disposeAction),
  TypedReducer<PricingState, LocationSelectAction>(_locationSelectAction),
  // TypedReducer<PricingState, LocationChangeAction>(_locationChangeAction),
  TypedReducer<PricingState, CopyToAnotherLocationFetchAction>(
      _copytoOtherLocationAction),
  TypedReducer<PricingState, BrandListFetchAction>(_brandListAction),
  TypedReducer<PricingState, ClassificationListFetchAction>(
      _classificationListAction),
  TypedReducer<PricingState, ItemGroupListFetchAction>(_itemGrpListAction),
  TypedReducer<PricingState, ItemBrandListFetchAction>(_itemBrandListAction),
  TypedReducer<PricingState, ItemModelListFetchAction>(itemModelListAction),
  TypedReducer<PricingState, ItemGrpsListFetchAction>(_itemsFetchAction),
  TypedReducer<PricingState, ItemDetailClearAction>(_clearAction),
  TypedReducer<PricingState, ItemGrpProductFetchAction>(
      _itemGrpproductsFetchAction),
  TypedReducer<PricingState, ItemModelProductFetchAction>(
      _itemModelproductsFetchAction),
  TypedReducer<PricingState, ItemBrandProductFetchAction>(
      _itemBrandproductsFetchAction),
  TypedReducer<PricingState, BrandProductFetchAction>(
      _brandproductsFetchAction),
  TypedReducer<PricingState, ClassificationProductFetchAction>(
      _classificationproductsFetchAction),
  TypedReducer<PricingState, CopyToLocationChange>(_locationChangeAction),
  // TypedReducer<PricingState, ProductsFetchedAction>(_productsFetchAction),
  TypedReducer<PricingState, LocationsFetchAction>(_locationsFetchedAction),
  TypedReducer<PricingState, ItemDetailsFetchAction>(_detailsFetchAction),
  TypedReducer<PricingState, ViewDetailsAction>(_viewDetailsAction),
  TypedReducer<PricingState, PricingSaveAction>(_saveAction),
  TypedReducer<PricingState, ItemsFetchedAction>(_itemProductsFetchAction),

  TypedReducer<PricingState, LocationProductsFetchAction>(
      _locationProductFetchAction),

  TypedReducer<PricingState, MultiLocationSelectAction>(
      _multilocationFecthAction),
]);

PricingState _multilocationFecthAction(
    PricingState state, MultiLocationSelectAction action) {
  print("copyOther${action.locationItems}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      multiLocation: action.locationItems);
}

PricingState _locationProductFetchAction(
    PricingState state, LocationProductsFetchAction action) {
  var locationItems = state.locationItems;
  locationItems.addAll(action.locationItems);
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      locationItems: locationItems,
      locationSearch: action.searchQuery,
      eorId: action.sorId,
      sorId: action.eorId,
      totalRecords: action.totalRecords,
      start: state.start + action.limit,
      multiLocation: null
      // scrollPosition: action.scrollPosition,
      );
}

PricingState _itemProductsFetchAction(
    PricingState state, ItemsFetchedAction action) {
  var items = state.items;
  items.addAll(action.products);
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    items: items,
    itemSearch: action.searchQuery,
    eorId: action.sorId,
    sorId: action.eorId,
    totalRecords: action.totalRecords,
    start: state.start + action.limit,
    // scrollPosition: action.scrollPosition,
  );
}

PricingState _viewDetailsAction(PricingState state, ViewDetailsAction action) {
  print("hello");
  print("itemDeat${action.item}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      model: action.item);
}

PricingState _saveAction(PricingState state, PricingSaveAction action) {
  return state.copyWith(
    saved: true,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

PricingState _detailsFetchAction(
    PricingState state, ItemDetailsFetchAction action) {
  print("hello");
  print("itemDeat${action.itemDeailListItems}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      itemDtl: action.itemDeailListItems);
}

PricingState _locationsFetchedAction(
    PricingState state, LocationsFetchAction action) {
  print(action.locations.length);
  print(action.locationId);
  return state.copyWith(
    location: action.locations,
    copyToOtherLocation: action.sources,
    selectedLocation: action.locations?.firstWhere(
        (location) => location.id == action.locationId,
        orElse: () => null),
    otherLocation: null,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

PricingState _locationChangeAction(
    PricingState state, CopyToLocationChange action) {
  return state.copyWith(
    selectedDestinationLocation: action.isTarget ? action.location : null,
    selectedSourceLocation: !action.isTarget ? action.location : null,
  );
}

PricingState _changeLoadingStatusAction(
    PricingState state, LoadingAction action) {
  return state.copyWith(
    loadingStatus: action.status,
    loadingMessage: action.message,
    loadingError: action.message,
  );
}

PricingState _itemGrpproductsFetchAction(
    PricingState state, ItemGrpProductFetchAction action) {
  var itemGroupItems = state.itemGroupItems;
  itemGroupItems.addAll(action.itemGrps);
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    itemGroupItems: itemGroupItems,
    itemGpSearch: action.searchQuery,
    eorId: action.sorId,
    sorId: action.eorId,
    totalRecords: action.totalRecords,
    start: state.start + action.limit,
    // scrollPosition: action.scrollPosition,
  );
}

PricingState _itemModelproductsFetchAction(
    PricingState state, ItemModelProductFetchAction action) {
  var itemModelItems = state.itemModelItems;
  itemModelItems.addAll(action.itemModel);
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    itemModelItems: itemModelItems,
    itemModelSearch: action.searchQuery,
    eorId: action.sorId,
    sorId: action.eorId,
    totalRecords: action.totalRecords,
    start: state.start + action.limit,
    // scrollPosition: action.scrollPosition,
  );
}

PricingState _itemBrandproductsFetchAction(
    PricingState state, ItemBrandProductFetchAction action) {
  var itemBrandItems = state.itemBrandItems;
  itemBrandItems.addAll(action.itemBrand);
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    itemBrandItems: itemBrandItems,
    itemBrandSearch: action.searchQuery,
    eorId: action.sorId,
    sorId: action.eorId,
    totalRecords: action.totalRecords,
    start: state.start + action.limit,
    //  scrollPosition: action.scrollPosition,
  );
}

PricingState _brandproductsFetchAction(
    PricingState state, BrandProductFetchAction action) {
  var brandItems = state.brandItems;
  brandItems.addAll(action.brandItems);
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    brandItems: brandItems,
    brandSearch: action.searchQuery,
    eorId: action.sorId,
    sorId: action.eorId,
    totalRecords: action.totalRecords,
    start: state.start + action.limit,
    // scrollPosition: action.scrollPosition,
  );
}

PricingState _classificationproductsFetchAction(
    PricingState state, ClassificationProductFetchAction action) {
  var classificationItems = state.classificationItems;
  classificationItems.addAll(action.classificationItems);
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    classificationItems: classificationItems,
    classificationSearch: action.searchQuery,
    eorId: action.sorId,
    sorId: action.eorId,
    totalRecords: action.totalRecords,
    start: state.start + action.limit,
    // scrollPosition: action.scrollPosition,
  );
}

PricingState _clearAction(PricingState state, ItemDetailClearAction action) =>
    PricingState.initial().copyWith();

PricingState _itemsFetchAction(
    PricingState state, ItemGrpsListFetchAction action) {
  print("hello");
  print("itesss${action.itemList}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      itemGList: action.itemList);
}

PricingState itemModelListAction(
        PricingState state, ItemModelListFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        itemModelItems: action.itemModelList);

PricingState _locationSelectAction(
        PricingState state, LocationSelectAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        location: action.location);
// PricingState _locationChangeAction(
//         PricingState state, LocationChangeAction action) =>
//     state.copyWith(
//         loadingStatus: LoadingStatus.success,
//         loadingMessage: "",
//         loadingError: "",
//         selectedLocation: action.selectedLocation);
PricingState _copytoOtherLocationAction(
        PricingState state, CopyToAnotherLocationFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        copyToOtherLocation: action.multipleLocation);
PricingState _brandListAction(
        PricingState state, BrandListFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        brandItems: action.brandList);
PricingState _classificationListAction(
        PricingState state, ClassificationListFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        classificationItems: action.classificationList);
PricingState _itemGrpListAction(
        PricingState state, ItemGroupListFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        itemGroupItems: action.itemGroupList);
PricingState _itemBrandListAction(
        PricingState state, ItemBrandListFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        itemBrandItems: action.itemBrandList);
// StockRequisitionState _saveAction(
//     StockRequisitionState state, RequisitionSaveAction action) {
//   return state.copyWith(
//     saved: true,
//     loadingError: "",
//     loadingMessage: "",
//     loadingStatus: LoadingStatus.success,
//   );
// }

PricingState _disposeAction(PricingState state, OnClearAction action) {
  return PricingState.initial();
}

import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/item_grade_rate_settings/item_grade_rate_settings_action.dart';
import 'package:redstars/src/redux/states/item_grade_rate_settings/item_grade_rate_settings_state.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_sub_model.dart';

final itemGradeRateSettingsReducer = combineReducers<ItemGradeRateState>([
  TypedReducer<ItemGradeRateState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<ItemGradeRateState, ItemGradeRatClearAction>(_disposeAction),
  TypedReducer<ItemGradeRateState, ItemGradeRateSettingsInitalFetchAction>(
      _itemGradeRateFetchAction),
  TypedReducer<ItemGradeRateState, ItemGradeRateLocationChangeAction>(
      _locationChangeAction),
  TypedReducer<ItemGradeRateState, AddNewItemGradeRateAction>(_newItemAction),
  TypedReducer<ItemGradeRateState, RemoveItemGradeRateRequisitionAction>(
      _removeItemAction),
  TypedReducer<ItemGradeRateState, ItemGradeRateSaveAction>(_saveAction),
  TypedReducer<ItemGradeRateState, ChangeDateAction>(_changeDateAction),
  TypedReducer<ItemGradeRateState, ItemRateGradeListFetchAction>(
      _gradeListAction),
  TypedReducer<ItemGradeRateState, ItemGradeRateSettingsViewPageFetchAction>(
      _itemRateViewPageAction),
  TypedReducer<ItemGradeRateState, ItemGradeRateSettingFilterChangeAction>(
      _changeFilterAction),
  TypedReducer<ItemGradeRateState,
          ItemGradeRateSettingsViewDetailPageFetchAction>(
      _itemRateViewDetailPageAction),
  TypedReducer<ItemGradeRateState, ItemsFetchedAction>(
      _itemProductsFetchAction),
  TypedReducer<ItemGradeRateState, ChangeItemsAction>(_itemsChangeAction),
]);

ItemGradeRateState _changeLoadingStatusAction(
    ItemGradeRateState state, LoadingAction action) {
  return state.copyWith(
    loadingStatus: action.status,
    loadingMessage: action.message,
    loadingError: action.message,
  );
}

ItemGradeRateState _itemsChangeAction(
    ItemGradeRateState state, ChangeItemsAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    changedItems: action.itemDatas,
  );
}

ItemGradeRateState _itemRateViewPageAction(
    ItemGradeRateState state, ItemGradeRateSettingsViewPageFetchAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    viewPageModel: action.itemGradeRateSettingsViewPageModel,
  );
}

ItemGradeRateState _changeFilterAction(
    ItemGradeRateState state, ItemGradeRateSettingFilterChangeAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    filterModel: action.filterData,
  );
}

ItemGradeRateState _itemProductsFetchAction(
    ItemGradeRateState state, ItemsFetchedAction action) {
  print("items----${action.products}");

  var items = state.items;
  List<ItemLookupItem> products = [];

  // items.addAll(action.products);
  products.addAll(action.products);
  print("items2----${products?.length}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      items: products,
      productData: products
      // itemSearch: action.searchQuery,
      // eorId: action.sorId,
      // sorId: action.eorId,
      // totalRecords: action.totalRecords,
      // start: state.start + action.limit,
      // scrollPosition: action.scrollPosition,
      );
}

ItemGradeRateState _itemRateViewDetailPageAction(ItemGradeRateState state,
    ItemGradeRateSettingsViewDetailPageFetchAction action) {
  ItemGradeRateSubModel model;
  List<ItemGradeRateSubModel> gradeRateModelList = [];
  StockLocation selectedLoctn;
  state.itemGradeRateLocationObj.forEach((element) {
    if (element.id ==
        action
            .itemGradeRateSettingsViewDetailPageModel
            .itemGradeRateSettingsDetailViewPageList
            .first
            .businessleveltabledataid) {
      //  targetLocation.add(element);
      selectedLoctn = element;
    }
    return selectedLoctn;
  });

  for (int i = 0;
      i <
          action.itemGradeRateSettingsViewDetailPageModel
              .itemGradeRateSettingsDetailViewPageList.first.dtlJson.length;
      i++) {
    model = ItemGradeRateSubModel(
        itemDtlDataId: action.itemGradeRateSettingsViewDetailPageModel
            .itemGradeRateSettingsDetailViewPageList.first.dtlJson[i].id,
        item: ItemLookupItem(
          id: action.itemGradeRateSettingsViewDetailPageModel
              .itemGradeRateSettingsDetailViewPageList.first.dtlJson[i].itemid,
          description: action
              .itemGradeRateSettingsViewDetailPageModel
              .itemGradeRateSettingsDetailViewPageList
              .first
              .dtlJson[i]
              ?.itemname,
          code: action
              .itemGradeRateSettingsViewDetailPageModel
              .itemGradeRateSettingsDetailViewPageList
              .first
              .dtlJson[i]
              ?.itemcode,
        ),
        grade: GradeLookupItem(
            id: action
                .itemGradeRateSettingsViewDetailPageModel
                .itemGradeRateSettingsDetailViewPageList
                .first
                .dtlJson[i]
                .gradeid,
            name: action
                .itemGradeRateSettingsViewDetailPageModel
                .itemGradeRateSettingsDetailViewPageList
                .first
                .dtlJson[i]
                .gradename),
        rate: action.itemGradeRateSettingsViewDetailPageModel
            .itemGradeRateSettingsDetailViewPageList.first.dtlJson[i].rate);
    gradeRateModelList.add(model);
  }

  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      selectedLocation: selectedLoctn,
      itemGradeRateDetailId: 1,
      selectedDate: DateTime.parse(action
          .itemGradeRateSettingsViewDetailPageModel
          .itemGradeRateSettingsDetailViewPageList
          .first
          .pricingwefdate),
      detailPageListModel: action.itemGradeRateSettingsViewDetailPageModel,
      itemGradeRateListData: gradeRateModelList);
}

ItemGradeRateState _changeDateAction(
    ItemGradeRateState state, ChangeDateAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    selectedDate: action.pricingDate,
  );
}

ItemGradeRateState _itemGradeRateFetchAction(
    ItemGradeRateState state, ItemGradeRateSettingsInitalFetchAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    currencyList: action.currencyList,
    businessLevelObj: action.businessLevelObj,
    businessSubLevelObj: action.businessSubLevelObj,
    itemGradeRateLocationObj: action.itemGradeRateLocationObj,
    selectedLocation: action.itemGradeRateLocationObj.firstWhere(
        (location) => location.id == action.businessLevelObj.first.Id,
        orElse: () => null),
  );
}

ItemGradeRateState _newItemAction(
    ItemGradeRateState state, AddNewItemGradeRateAction action) {
  List<ItemGradeRateSubModel> items = state.itemGradeRateListData;
  if (items.contains(action.item)) {
    int index = items.indexOf(action.item);
    var updatedItem = items[index];
    updatedItem.rate = action.item.rate;
    items[index] = updatedItem;
    return state.copyWith(itemGradeRateListData: items);
  } else
    return state.copyWith(itemGradeRateListData: [action.item, ...items]);
}

ItemGradeRateState _removeItemAction(
    ItemGradeRateState state, RemoveItemGradeRateRequisitionAction action) {
  List<ItemGradeRateSubModel> items = state.itemGradeRateListData;

  if (items.contains(action.item)) {
    items.remove(action.item);
    return state.copyWith(itemGradeRateListData: items);
  }
  return state.copyWith();
}

ItemGradeRateState _saveAction(
    ItemGradeRateState state, ItemGradeRateSaveAction action) {
  return state.copyWith(
    saved: true,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

ItemGradeRateState _gradeListAction(
    ItemGradeRateState state, ItemRateGradeListFetchAction action) {
  return state.copyWith(
      loadingMessage: "",
      loadingError: "",
      loadingStatus: LoadingStatus.success,
      gradeListItemRate: action.grades);
}

ItemGradeRateState _disposeAction(
    ItemGradeRateState state, ItemGradeRatClearAction action) {
  return ItemGradeRateState.initial().copyWith(
    saved: false,
  );
}

ItemGradeRateState _locationChangeAction(
    ItemGradeRateState state, ItemGradeRateLocationChangeAction action) {
  return state.copyWith(
    selectedLocation: action.location,
  );
}

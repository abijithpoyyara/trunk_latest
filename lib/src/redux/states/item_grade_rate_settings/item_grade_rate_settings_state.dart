import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_initail_model.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_view_details_page_model.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_view_page_model.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_filter_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_sub_model.dart';

@immutable
class ItemGradeRateState extends BaseState {
  final List<BusinessSubLevelObjModel> businessSubLevelObj;
  final List<StockLocation> itemGradeRateLocationObj;
  final List<BusinessLevelObjModel> businessLevelObj;
  final List<BCCModel> currencyList;
  final List<ItemGradeRateSubModel> itemGradeRateListData;
  final StockLocation selectedLocation;
  final bool saved;
  final List<GradeLookupItem> gradeListItemRate;
  final DateTime selectedDate;
  final ItemGradeRateSettingsFilterModel filterModel;
  final ItemGradeRateSettingsViewDetailPageListModel detailPageListModel;
  final ItemGradeRateSettingsViewPageModel viewPageModel;
  final List<ItemLookupItem> items;
  final double scrollPosition;
  final int optionId;
  final DateTime frmDate;
  final DateTime toDate;
  final List<ItemLookupItem> productData;
  final int itemGradeRateDetailId;
  final List<ItemLookupItem> changedItems;

  ItemGradeRateState({
    this.businessSubLevelObj,
    this.itemGradeRateLocationObj,
    this.businessLevelObj,
    this.currencyList,
    this.itemGradeRateListData,
    this.selectedLocation,
    this.saved,
    this.gradeListItemRate,
    this.selectedDate,
    this.detailPageListModel,
    this.viewPageModel,
    this.filterModel,
    this.items,
    this.scrollPosition,
    this.optionId,
    this.frmDate,
    this.toDate,
    this.productData,
    this.itemGradeRateDetailId,
    this.changedItems,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  ItemGradeRateState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    List<BusinessSubLevelObjModel> businessSubLevelObj,
    List<StockLocation> itemGradeRateLocationObj,
    List<BusinessLevelObjModel> businessLevelObj,
    List<BCCModel> currencyList,
    List<ItemGradeRateSubModel> itemGradeRateListData,
    StockLocation selectedLocation,
    bool saved,
    List<GradeLookupItem> gradeListItemRate,
    DateTime selectedDate,
    ItemGradeRateSettingsFilterModel filterModel,
    ItemGradeRateSettingsViewDetailPageListModel detailPageListModel,
    ItemGradeRateSettingsViewPageModel viewPageModel,
    List<ItemLookupItem> items,
    double scrollPosition,
    int optionId,
    DateTime frmDate,
    DateTime toDate,
    List<ItemLookupItem> productData,
    int itemGradeRateDetailId,
    List<ItemLookupItem> changedItems,
  }) {
    // fb()async{
    //   int branchId = await BasePrefs.getInt(BaseConstants.BRANCH_ID_KEY);
    //   itemGradeRateLocationObj.forEach((element) {
    //     if(element.id==branchId) {
    //      locationObj=element;
    //     }
    //
    //   });
    // }

    return ItemGradeRateState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingError: loadingError ?? this.loadingError,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        itemGradeRateLocationObj:
            itemGradeRateLocationObj ?? this.itemGradeRateLocationObj,
        businessLevelObj: businessLevelObj ?? this.businessLevelObj,
        businessSubLevelObj: businessSubLevelObj ?? this.businessSubLevelObj,
        currencyList: currencyList ?? currencyList ?? this.currencyList,
        gradeListItemRate: gradeListItemRate ?? this.gradeListItemRate,
        productData: productData ?? this.productData,
        changedItems: changedItems ?? this.changedItems,
        itemGradeRateListData:
            itemGradeRateListData ?? this.itemGradeRateListData,
        selectedLocation:
            selectedLocation ?? selectedLocation ?? this.selectedLocation,
        selectedDate: selectedDate ?? this.selectedDate,
        filterModel: filterModel ?? this.filterModel,
        detailPageListModel: detailPageListModel ?? this.detailPageListModel,
        viewPageModel: viewPageModel ?? this.viewPageModel,
        scrollPosition: scrollPosition ?? this.scrollPosition,
        itemGradeRateDetailId:
            itemGradeRateDetailId ?? this.itemGradeRateDetailId,
        frmDate: DateTime.now(),
        toDate: DateTime((DateTime.now()).year, (DateTime.now()).month, 1),
        saved: saved ?? this.saved);
  }

  factory ItemGradeRateState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);

    return ItemGradeRateState(
        loadingStatus: LoadingStatus.success,
        loadingError: "",
        loadingMessage: "",
        selectedLocation: null,
        businessSubLevelObj: [],
        businessLevelObj: [],
        itemGradeRateListData: [],
        itemGradeRateLocationObj: [],
        saved: false,
        scrollPosition: 0.0,
        gradeListItemRate: [],
        productData: List(),
        items: [],
        itemGradeRateDetailId: 0,
        detailPageListModel: null,
        viewPageModel: null,
        changedItems: List(),
        filterModel: ItemGradeRateSettingsFilterModel(
          fromDate: startDate,
          toDate: currentDate,
        ),
        selectedDate: DateTime.now(),
        currencyList: []);
  }
}

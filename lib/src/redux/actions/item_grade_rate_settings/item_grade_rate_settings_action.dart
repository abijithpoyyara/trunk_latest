import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_initail_model.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_view_details_page_model.dart';
import 'package:redstars/src/services/model/response/item_grade_rate_settings/item_grade_rate_settings_view_page_model.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/services/model/response/sales_invoice/sales_product_model.dart';
import 'package:redstars/src/services/repository/item_grade_rate_settings/item_grade_rate_settings_repository.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_filter_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_sub_model.dart';

class AddNewItemGradeRateAction {
  ItemGradeRateSubModel item;

  AddNewItemGradeRateAction(this.item);
}

class ItemRateGradeListFetchAction {
  List<GradeLookupItem> grades;
  ItemRateGradeListFetchAction(this.grades);
}

class ItemGradeRateSettingsInitalFetchAction {
  List<BusinessSubLevelObjModel> businessSubLevelObj;
  List<StockLocation> itemGradeRateLocationObj;
  List<BusinessLevelObjModel> businessLevelObj;
  List<BCCModel> currencyList;

  ItemGradeRateSettingsInitalFetchAction(
      {this.businessLevelObj,
      this.currencyList,
      this.businessSubLevelObj,
      this.itemGradeRateLocationObj});
}

class ItemGradeRateLocationChangeAction {
  StockLocation location;

  ItemGradeRateLocationChangeAction({
    this.location,
  });
}

class RemoveItemGradeRateRequisitionAction {
  ItemGradeRateSubModel item;

  RemoveItemGradeRateRequisitionAction(this.item);
}

class ItemGradeRateSettingsViewPageFetchAction {
  ItemGradeRateSettingsViewPageModel itemGradeRateSettingsViewPageModel;
  ItemGradeRateSettingsViewPageFetchAction(
      this.itemGradeRateSettingsViewPageModel);
}

class ItemGradeRateSettingsViewDetailPageFetchAction {
  ItemGradeRateSettingsViewDetailPageListModel
      itemGradeRateSettingsViewDetailPageModel;
  ItemGradeRateSettingsViewDetailPageFetchAction(
      this.itemGradeRateSettingsViewDetailPageModel);
}

class ItemGradeRateSettingFilterChangeAction {
  ItemGradeRateSettingsFilterModel filterData;
  ItemGradeRateSettingFilterChangeAction(this.filterData);
}

class ChangeItemsAction {
  List<dynamic> itemDatas;
  ChangeItemsAction(this.itemDatas);
}

class ItemsFetchedAction {
  int sorId;
  int eorId;
  int limit;
  int totalRecords;
  List<ProductModel> products;
  String searchQuery;
  double scrollPosition;

  ItemsFetchedAction(
    this.products, {
    this.sorId,
    this.eorId,
    this.limit,
    this.totalRecords,
    this.searchQuery,
    this.scrollPosition,
  });
}

class ChangeDateAction {
  DateTime pricingDate;
  ChangeDateAction(this.pricingDate);
}

class ItemGradeRateSaveAction {}

class ItemGradeRatClearAction {}

ThunkAction fetchItemProducts(
    {String code,
    String name,
    int start,
    int eorId,
    int sorId,
    int totalRecords,
    double scrollPosition}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption?.optionId ?? 0;

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Items ",
      ));

      ItemGradeRateSettingsRepository().getProductList(
          start: start,
          code: code,
          name: name,
          sor_Id: sorId,
          eor_Id: eorId,
          totalRecords: totalRecords,
          onRequestSuccess: (
            products, {
            int sorId,
            int eorId,
            int limit,
            int totalRecords,
          }) {
            store.dispatch(ItemsFetchedAction(
              products,
              sorId: sorId,
              eorId: eorId,
              limit: limit,
              totalRecords: totalRecords,
              scrollPosition: scrollPosition,
            ));
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchItemGradeRateSettingsInitialConfig() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching initial Data ",
      ));

      ItemGradeRateSettingsRepository().getItemGradeRateSettingInitialData(
          onRequestSuccess: ({
            List<BusinessSubLevelObjModel> businessSubLevelObj,
            List<StockLocation> itemGradeRateLocationObj,
            List<BusinessLevelObjModel> businessLevelObj,
            List<BCCModel> currencyList,
          }) =>
              {
                store.dispatch(ItemGradeRateSettingsInitalFetchAction(
                    itemGradeRateLocationObj: itemGradeRateLocationObj,
                    businessSubLevelObj: businessSubLevelObj,
                    businessLevelObj: businessLevelObj,
                    currencyList: currencyList))
              },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchItemGradeRateSettingsViewPageListData(
    {int start,
    int sor_Id,
    int eor_Id,
    int totalRecords,
    int optionId,
    ItemGradeRateSettingsFilterModel filterModel,
    List<ItemGradeRateSettingsViewPageList> listData}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading",
      ));
      ItemGradeRateSettingsRepository().getItemRateViewListDate(
        start: start,
        optionId: optionId,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        itemGradeRateSettingsFilterModel: filterModel,
        onRequestSuccess: (result) {
          sor_Id = result.SOR_Id;
          eor_Id = result.EOR_Id;
          totalRecords = result.TotalRecords;
          listData?.addAll(result.itemGradeRateSettingsViewPage);
          store.dispatch(new ItemGradeRateSettingsViewPageFetchAction(result));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchItemGradeRateViewDetailListData({
  int start,
  int optionId,
  int sor_Id,
  int eor_Id,
  int totalRecords,
  ItemGradeRateSettingsFilterModel filterModel,
  ItemGradeRateSettingsViewPageList valueId,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading",
      ));
      ItemGradeRateSettingsRepository().getItemRateGradeViewDetailsListData(
        start: start,
        optionId: optionId,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        itemGradeRateSettingsFilterModel: filterModel,
        viewPageListId: valueId,
        onRequestSuccess: (itemViewList) {
          sor_Id = itemViewList.SOR_Id;
          eor_Id = itemViewList.EOR_Id;
          totalRecords = itemViewList.TotalRecords;
          store.dispatch(
              new ItemGradeRateSettingsViewDetailPageFetchAction(itemViewList));
        },
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchGrades() {
  return (Store store) async {
    new Future(() async {
      print("hello");
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      ItemGradeRateSettingsRepository().getItemRateGrades(
        onRequestSuccess: (grade) =>
            store.dispatch(new ItemRateGradeListFetchAction(grade)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction saveItemGradeRateSettingsAction({
  List<ItemGradeRateSubModel> itemGradeRateListDataItems,
  int optionId,
  List<BusinessLevelObjModel> businessLevelObj,
  StockLocation sourceLocation,
  DateTime pricingWefdate,
  int itemDtlId,
  ItemGradeRateSettingsViewDetailPageListModel dtlModel,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving ItemGradeRateSettings ",
      ));

      ItemGradeRateSettingsRepository().saveItemGradeRateSettings(
        itemGradeRateListDataItems: itemGradeRateListDataItems,
        optionId: optionId,
        sourceLocation: sourceLocation,
        businessLevelObj: businessLevelObj,
        pricingdate: pricingWefdate,
        dtlModel: dtlModel,
        itemRateGradeDtlId: itemDtlId,
        onRequestSuccess: () => store.dispatch(new ItemGradeRateSaveAction()),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

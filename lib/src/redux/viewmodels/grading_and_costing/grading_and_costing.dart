import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/grading_and_costing/grading_and_costing_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/gin/gin_details.dart';
import 'package:redstars/src/services/model/response/gin/gin_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/currency_exchange_rate_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grade_rate_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_detail_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_process_gin_fill_list.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/process_from_list.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/model/grading_model.dart';

class GradingCostingViewModel extends BaseViewModel {
  final DateTime fromDate;
  final DateTime toDate;
  final double scrollPosition;
  final List<ProcessFromGinList> processGinList;
  final List<ProcessFromGinList> refreshGinList;
  final List<ProcessFillGradingList> gradingList;
  final ProcessFillGradingList gradCostData;
  final List<CurrencyExchange> currencyExchange;
  final bool saveData;

  final SupplierLookupItem selectedSupplier;
  final String searchQuery;

  final SupplierModel supplier;
  final Function(ProcessFromGinList) getGradingCostingData;

  final Future<void> Function() onRefresh;
  final Function(GINFilterModel) onFilter;
  final Function(GINFilterModel) onViewListFilter;
  final Function(double, int) getMoreItem;
  final Function(String searchKey) onSearch;
  final ValueSetter<GINItemModel> updateItem;
  final Function() saveGradingCosting;
  final int qty;
  final double rate;
  final double totalValue;
  final ValueSetter<GradeModel> onRemoveItem;
  final Function(GradeModel) onAdd;
  final GradeModel gradeModel;
  final List<GradeModel> listOfGradeModel;
  final GradingModel gradingModel;
  final List<GradingModel> gradingModelList;
  final List<ItemDetailModel> itemDetailList;
  final VoidCallback onClear;
  final GINFilterModel ginFilterModel;
  final GINFilterModel currentFilters;
  final Function(GINFilterModel result) saveModelVar;
  final Function(GINFilterModel model) saveFilter;
  final DateTime newFromDate;
  final DateTime newToDate;
  final GradingViewListModel gradingViewListModel;
  final GradingCostingViewDetailModel gradingCostingViewDetailModel;
  final List<SourceItemDtlList> sourceItemDtl;
  final List<GradingDtlJsonList> gradingDtlJson;
  final Function(GINFilterModel filterModel) onGetGradingViewList;
  final Function(GINFilterModel result) onSubmitFilter;
  final Function(GINFilterModel result) onSubmit;
  final Function(GradeModel) onEdit;
  final Function(int, int) getItemRate;
  final Function() editSaveGradingCost;
  final GradeRateList gradeListItem;
  final List<GradeRateList> gradeRateList;
  final int option_Id;
  final List<GradeLookupItem> grades;
  final Function(
    GradingViewListModel,
    GardingViewList,
    GINFilterModel,
  ) onGradingCostDetailView;
  final Function(DateTime fdate, DateTime tdate) onViewRefresh;
  final Function(GINFilterModel result, int start, double position,
      List<GardingViewList>) onFilterSubmit;
  List<GradeRateList> ratelist;

  GradingCostingViewModel(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      String loadingError,
      this.grades,
      this.onViewRefresh,
      this.onEdit,
      this.onSubmit,
      this.getItemRate,
      this.gradeListItem,
      this.editSaveGradingCost,
      this.saveFilter,
      this.onFilterSubmit,
      this.option_Id,
      this.currentFilters,
      this.gradingCostingViewDetailModel,
      this.gradingViewListModel,
      this.sourceItemDtl,
      this.gradingDtlJson,
      this.ginFilterModel,
      this.gradeRateList,
      this.onClear,
      this.itemDetailList,
      this.listOfGradeModel,
      this.gradingModelList,
      this.gradingModel,
      this.gradeModel,
      this.onRemoveItem,
      this.onAdd,
      this.rate,
      this.totalValue,
      this.qty,
      this.gradCostData,
      this.getGradingCostingData,
      this.saveGradingCosting,
      this.currencyExchange,
      this.refreshGinList,
      this.gradingList,
      this.saveData,
      this.processGinList,
      this.fromDate,
      this.toDate,
      this.ratelist,
      this.selectedSupplier,
      this.searchQuery,
      this.supplier,
      this.onRefresh,
      this.onFilter,
      this.getMoreItem,
      this.onSearch,
      this.scrollPosition,
      this.updateItem,
      this.saveModelVar,
      this.newFromDate,
      this.newToDate,
      this.onGetGradingViewList,
      this.onViewListFilter,
      this.onGradingCostDetailView,
      this.onSubmitFilter})
      : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  factory GradingCostingViewModel.fromStore(Store<AppState> store) {
    final state = store.state.gradingCostingState;
    final filters = state.filterRange;
    final int optionId = store.state.homeState.selectedOption.optionId;
    double totalValue = 0;
    double rate = 0.0;
    return GradingCostingViewModel(
      loadingStatus: state.loadingStatus,
      loadingMessage: state.loadingMessage,
      loadingError: state.loadingError,
      itemDetailList: state.itemDetailList,
      option_Id: optionId,
      totalValue: totalValue,
      rate: rate,
      ginFilterModel: state.ginFilterModel,
      currentFilters: state.currentFilters,
      toDate: state.toDate,
      gradeListItem: state.gradeListItem,
      fromDate: state.fromDate,
      searchQuery: state.filterRange?.transNo,
      scrollPosition: state.scrollPosition,
      selectedSupplier: state.currentFilters.supplier,
      processGinList: state.processGinList,
      gradingList: state.gradingList,
      saveData: state.saveData,
      gradingModelList: state.gradingModelList,
      gradingModel: state.gradingModel,
      gradeModel: state.gradeModel,
      grades: state.gradeList,
      listOfGradeModel: state.listOfGradeModel,
      currencyExchange: state.currencyExchange,
      refreshGinList: state.refreshGinList,
      gradCostData: state.gradCostData,
      gradingViewListModel: state.gradingViewListModel,
      gradingDtlJson: state.gradingDtlJson,
      gradingCostingViewDetailModel: state.gradingCostingViewDetailModel,
      sourceItemDtl: state.sourceItemDtl,
      getItemRate: (itemId, GradeId) {
        store.dispatch(fetchItemGradeRate(itemId: itemId, gradeId: GradeId));
      },
      gradeRateList: state.gradeRateList,
      ratelist: state.gradeRateList,
      onViewRefresh: (from, todate) {
        store.dispatch(fetchGradingViewList(
            option_Id: optionId,
            start: 0,
            sor_Id: null,
            eor_Id: null,
            listdata: [],
            totalRecords: null,
            ginFilterModel: GINFilterModel(fromDate: from, toDate: todate)));
      },
      onFilterSubmit: (result, start, position, list) {
        print("start---$start");
        store.dispatch(fetchGradingViewList(
            option_Id: optionId,
            listdata: list,
            start: start,
            ginFilterModel: GINFilterModel(
              fromDate: result.fromDate,
              toDate: result.toDate,
              supplier: result.supplier,
              transNo: result.transNo,
            )));
      },
      onSubmitFilter: (result) {
        store.dispatch(GINFilterModelFetchAction(result));
      },
      onGetGradingViewList: (filter) {
        store.dispatch(fetchGradingViewList(
            start: 0,
            sor_Id: null,
            eor_Id: null,
            totalRecords: null,
            ginFilterModel: GINFilterModel(
                fromDate: filters?.fromDate,
                toDate: filters?.toDate,
                dateRange: filters?.dateRange,
                transNo: filters?.transNo,
                supplier: filters?.supplier),
            option_Id: optionId));
      },
      onGradingCostDetailView: (gcViewListModel, gcViewList, filter) {
        store.dispatch(fetchGradingViewListDetail(
            sor_Id: gcViewListModel?.SOR_Id,
            eor_Id: gcViewListModel?.EOR_Id,
            totalRecords: gcViewListModel?.totalRecords,
            //  start: gcViewList.start,
            id: gcViewList,
            option_Id: optionId,
            ginFilterModel: filter));
      },
      onClear: () => store.dispatch(ItemDetailClearAction()),
      supplier: SupplierModel.fromGIN(state.ginDetails),
      onRefresh: () =>
          store.dispatch(fetchRefreshData(filterModel: state.currentFilters)),
      getGradingCostingData: (listData) =>
          store.dispatch(fetchGradingListData(listData.ginid)),
      onFilter: (filterModel) =>
          store.dispatch(fetchInitialData(filterModel: filterModel)),
      onRemoveItem: (item) => store.dispatch(RemoveGradeAction(item)),
      onAdd: (model) => store.dispatch(AddGradeAction(model)),
      saveGradingCosting: () {
        store.dispatch(saveGradingAction(
          gradingList: state.gradingList,
          currencyExchange: state.currencyExchange,
          optionId: optionId,
          itemDtl: state.itemDetailList,
        ));
      },
      editSaveGradingCost: () {
        store.dispatch(editSaveGradingAction(
          gclist: state.gradingCostingViewDetailModel,
          optionId: optionId,
          currencyExchange: state.currencyExchange,
          itemDtl: state.itemDetailList,
        ));
      },
      onEdit: (model) => store.dispatch(EditGradeAction(model)),
      onSubmit: (filter) {
        store.dispatch(fetchGradingViewList(
            option_Id: optionId,
            listdata: [],
            start: 0,
            // sor_id: state.viewListModel.SOR_Id,
            // eor_id: state.viewListModel.EOR_Id,
            // totalrecords: state.viewListModel.totalRecords,
            ginFilterModel: GINFilterModel(
              fromDate: filter?.fromDate,
              toDate: filter?.toDate,
              supplier: filters?.supplier,
              transNo: filters?.transNo,
              // reqNo: filter.reqNo
            )));
      },
      saveFilter: (model) {
        store.dispatch(SavingModelVarAction(filters: model));
        store.dispatch(fetchInitialData(filterModel: model));
      },
      saveModelVar: (result) =>
          store.dispatch(SavingModelVarAction(filters: result)),
      newFromDate: state.currentFilters.fromDate,
      newToDate: state.currentFilters.toDate,
    );
  }

  String validateItems() {
    String message = "";
    bool valid = true;
    listOfGradeModel?.forEach((element) {
      if (valid) {
        if ((element.rate == 0)) {
          message =
              "You are going to save the grade rate of item is zero , Do you really want to continue ?";
          valid = false;
        }
        // else if (element.batchDtl?.nlc == null) {
        //   message = "$item has no nlc";
        //   valid = false;
        // } else if (!(element?.rateDtl?.mrpDtl?.rateInclTax > 0)) {
        //   message = "Rate of $item cannot be zero";
        //   valid = false;
        // } else if ((element.rateDtl == null)) {
        //   message = "MrpDtl called null";
        //   valid = false;
        // }
      }
    });
    return message;
  }
}

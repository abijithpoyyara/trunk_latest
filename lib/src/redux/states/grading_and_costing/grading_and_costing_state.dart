import 'package:base/redux.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/currency_exchange_rate_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grade_rate_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_detail_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_model.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_process_gin_fill_list.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/process_from_list.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/model/grading_model.dart';

class GradingCostingState extends BaseState {
  final GINFilterModel filterRange;
  final DateTime fromDate;
  final DateTime toDate;
  final List<ProcessFromGinList> processGinList;
  final List<ProcessFromGinList> refreshGinList;
  final List<ProcessFillGradingList> gradingList;
  final List<CurrencyExchange> currencyExchange;
  final double scrollPosition;
  final GINModel ginDetails;
  final bool saveData;
  final ProcessFillGradingList gradCostData;
  final int qty;
  final double rate;
  final double totalValue;
  final GradeModel gradeModel;
  final List<GradeModel> listOfGradeModel;
  final GradingModel gradingModel;
  final List<GradingModel> gradingModelList;
  final List<ItemDetailModel> itemDetailList;
  final GINFilterModel ginFilterModel;
  final GINFilterModel currentFilters;
  final GradingViewListModel gradingViewListModel;
  final GradingCostingViewDetailModel gradingCostingViewDetailModel;
  final List<SourceItemDtlList> sourceItemDtl;
  final List<GradingDtlJsonList> gradingDtlJson;
  final List<GradeRateList> gradeRateList;
  final GradeRateList gradeListItem;
  final List<GradeLookupItem> gradeList;
  // final List<GardingViewList> gradingViewList;

  GradingCostingState({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    this.gradeListItem,
    this.gradingCostingViewDetailModel,
    this.gradingViewListModel,
    this.sourceItemDtl,
    this.gradingDtlJson,
    this.fromDate,
    this.toDate,
    this.ginFilterModel,
    this.itemDetailList,
    this.gradingModel,
    this.gradeModel,
    this.gradingModelList,
    this.listOfGradeModel,
    this.totalValue,
    this.qty,
    this.rate,
    this.gradCostData,
    this.currencyExchange,
    this.saveData,
    this.refreshGinList,
    this.filterRange,
    this.processGinList,
    this.gradingList,
    this.scrollPosition,
    this.ginDetails,
    this.currentFilters,
    this.gradeRateList,
    this.gradeList,
    // this.gradingViewList
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  GradingCostingState copyWith({
    GINFilterModel filterRange,
    LoadingStatus loadingStatus,
    double scrollPosition,
    String loadingMessage,
    String loadingError,
    List<CurrencyExchange> currencyExchange,
    List<ProcessFromGinList> processGinList,
    List<ProcessFillGradingList> gradingList,
    List<ProcessFromGinList> refreshGinList,
    bool saveData,
    GINModel ginDetails,
    ProcessFillGradingList gradCostData,
    int qty,
    double rate,
    double totalValue,
    GradeModel gradeModel,
    List<GradeModel> listOfGradeModel,
    GradingModel gradingModel,
    List<GradingModel> gradingModelList,
    List<ItemDetailModel> itemDetailList,
    GINFilterModel ginFilterModel,
    DateTime fromDate,
    DateTime toDate,
    GINFilterModel currentFilters,
    GradingViewListModel gradingViewListModel,
    GradingCostingViewDetailModel gradingCostingViewDetailModel,
    List<SourceItemDtlList> sourceItemDtl,
    List<GradingDtlJsonList> gradingDtlJson,
    List<GardingViewList> gradingViewList,
    List<GradeRateList> gradeRateList,
    GradeRateList gradeListItem,
    List<GradeLookupItem> gradeList,
  }) {
    return GradingCostingState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      filterRange: filterRange ?? this.filterRange,
      loadingMessage: loadingMessage,
      loadingError: loadingError,
      saveData: saveData ?? this.saveData,
      processGinList: processGinList ?? this.processGinList,
      currencyExchange: currencyExchange ?? this.currencyExchange,
      gradingList: gradingList ?? this.gradingList,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      ginDetails: ginDetails ?? this.ginDetails,
      refreshGinList: refreshGinList ?? this.refreshGinList,
      gradCostData: gradCostData ?? this.gradCostData,
      qty: qty ?? this.qty,
      gradeList: gradeList ?? this.gradeList,
      ginFilterModel: ginFilterModel ?? this.ginFilterModel,
      totalValue: totalValue ?? this.totalValue,
      rate: rate ?? this.rate,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      gradeModel: gradeModel ?? this.gradeModel,
      gradingModel: gradingModel ?? this.gradingModel,
      itemDetailList: itemDetailList ?? this.itemDetailList,
      gradingModelList: gradingModelList ?? this.gradingModelList,
      listOfGradeModel: listOfGradeModel ?? this.listOfGradeModel,
      currentFilters: currentFilters ?? this.currentFilters,
      gradeListItem: gradeListItem ?? this.gradeListItem,
      gradeRateList: gradeRateList ?? this.gradeRateList,
      gradingCostingViewDetailModel:
          gradingCostingViewDetailModel ?? this.gradingCostingViewDetailModel,
      gradingDtlJson: gradingDtlJson ?? gradingDtlJson,
      gradingViewListModel: gradingViewListModel ?? this.gradingViewListModel,
      sourceItemDtl: sourceItemDtl ?? this.sourceItemDtl,
      // gradingViewList: gradingViewList ?? this.gradingViewList,
    );
  }

  factory GradingCostingState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    return GradingCostingState(
        ginFilterModel: GINFilterModel(
          fromDate: startDate,
          toDate: currentDate,
          dateRange: DateTimeRange(start: startDate, end: currentDate),
          supplier: null,
          transNo: '',
        ),
        fromDate: DateTime(currentDate.year, currentDate.month, 1),
        toDate: DateTime.now(),
        currentFilters: GINFilterModel(
            fromDate: startDate,
            toDate: currentDate,
            dateRange: DateTimeRange(start: startDate, end: currentDate),
            supplier: null,
            transNo: ''),
        loadingStatus: LoadingStatus.success,
        itemDetailList: List(),
        gradeModel: null,
        gradingModel: null,
        gradingCostingViewDetailModel: null,
        gradingDtlJson: List(),
        sourceItemDtl: [],
        gradingViewListModel: null,
        listOfGradeModel: List(),
        gradingModelList: List(),
        gradCostData: null,
        gradeListItem: null,
        loadingMessage: '',
        gradeRateList: [],
        loadingError: '',
        processGinList: List(),
        gradingList: List(),
        refreshGinList: List(),
        currencyExchange: List(),
        saveData: false,
        scrollPosition: 0.0,
        ginDetails: null,
        rate: 0.0,
        totalValue: 0.0,
        qty: 0);
  }
}

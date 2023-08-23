import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_home_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_analysis_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_branch_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_item_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_salesman_model.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';

class SalesInsightHomeViewModel extends BaseViewModel {
  final LoadingStatus categoryLoadingStatus,
      branchLoadingStatus,
      brandLoadingStatus,
      branchRevenueLoadingStatus,
      salesmanLoadingStatus,
      itemsLoadingStatus;

  final bool margin;
  final bool major;
  final DateTime fromDate;
  final DateTime toDate;
  final double totalSale;
  final double totalMargin;

  final List<RevenueCategoryList> categoryList;
  final List<RevenueBranchList> branchList;
  final List<RevenueBrandList> brandList;
  final List<RevenueBranchItem> branchRevenue;
  final List<RevenueSalesmanItem> salesman;
  final List<RevenueItemList> itemsRevenue;

  final Function(SaleInsightFilterModel model) onFilterHome;
  final Function(SaleInsightFilterModel model) onFilterRevenue;

  SalesInsightHomeViewModel(
      {this.margin,
      this.major,
      this.fromDate,
      this.toDate,
      LoadingStatus loadingStatus,
      String loadingMessage,
      String errorMessage,
      this.totalMargin,
      this.totalSale,
      this.categoryLoadingStatus,
      this.branchLoadingStatus,
      this.brandLoadingStatus,
      this.branchRevenueLoadingStatus,
      this.salesmanLoadingStatus,
      this.itemsLoadingStatus,
      this.categoryList,
      this.branchList,
      this.brandList,
      this.branchRevenue,
      this.salesman,
      this.itemsRevenue,
      this.onFilterHome,
      this.onFilterRevenue})
      : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory SalesInsightHomeViewModel.fromStore(Store<AppState> store) {
    final state = store.state.salesInsightState.salesInsightHomeState;
    double totalSale = 0, totalMargin;
    if (state.margin) totalMargin = 0;
    state.branchList?.forEach((element) {
      totalSale += element.revenue;
      if (state.margin) totalMargin += element.margin;
    });
    return SalesInsightHomeViewModel(
        loadingStatus: state.loadingStatus,
        loadingMessage: state.loadingMessage,
        errorMessage: state.loadingError,
        fromDate: state.fromDate,
        margin: state.margin,
        major: state.major,
        toDate: state.toDate,
        categoryList: state.categoryList,
        branchList: state.branchList,
        brandList: state.brandList,
        branchRevenue: state.branchRevenue,
        salesman: state.salesman,
        categoryLoadingStatus: state.categoryLoadingStatus,
        branchLoadingStatus: state.branchLoadingStatus,
        brandLoadingStatus: state.brandLoadingStatus,
        branchRevenueLoadingStatus: state.branchRevenueLoadingStatus,
        salesmanLoadingStatus: state.salesmanLoadingStatus,
        itemsLoadingStatus: state.itemsLoadingStatus,
        itemsRevenue: state.itemsRevenue,
        totalSale: totalSale,
        totalMargin: totalMargin,
        onFilterHome: (model) => store.dispatch(fetchSummaryList(
            model.fromDate, model.toDate,
            major: model.isMajorCategory, margin: model.isMargin)),
        onFilterRevenue: (model) => store.dispatch(fetchRevenueAnalysisLists(
            state.fromDate, state.toDate,
            major: model.isMajorCategory, margin: model.isMargin)));
  }
}

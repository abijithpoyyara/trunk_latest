import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/customer_analysis_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/sales_insight/customer_analysis.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';
import 'package:base/redux.dart';

class SalesInsightCustomerViewModel extends BaseViewModel {


  final bool margin;
  final bool major;
  final DateTime fromDate;
  final DateTime toDate;

  final int totalCustomers;
  final int repeatCustomers;
  final int onceCustomers;
  final double repeatPercent;
  final double oncePercent;
  final List<CustomerMarginList> marginAnalysis;
  final List<CustomerBranchList> branchAnalysis;

  final Function(SaleInsightFilterModel model) onFilter;

  SalesInsightCustomerViewModel(
      {this.totalCustomers,
      this.repeatCustomers,
      this.onceCustomers,
      this.repeatPercent,
      this.oncePercent,
      this.marginAnalysis,
      this.branchAnalysis,
      LoadingStatus loadingStatus,
      String loadingMessage,
      String errorMessage,
      this.margin,
      this.major,
      this.fromDate,
      this.toDate,
      this.onFilter}): super(
    loadingStatus: loadingStatus,
    loadingMessage: loadingMessage,
    loadingError: errorMessage,
  );

  static SalesInsightCustomerViewModel fromStore(Store<AppState> store) {
    final state = store.state.salesInsightState.salesInsightCustomerState;
    return SalesInsightCustomerViewModel(
      loadingStatus: state.loadingStatus,
      loadingMessage: state.loadingMessage,
      errorMessage: state.loadingError,
      totalCustomers: state.totalCustomers,
      repeatCustomers: state.repeatCustomers,
      onceCustomers: state.onceCustomers,
      repeatPercent: state.repeatPercent,
      oncePercent: state.oncePercent,
      marginAnalysis: state.marginAnalysis,
      branchAnalysis: state.branchAnalysis,
      fromDate: state.fromDate,
      margin: state.margin,
      major: state.major,
      toDate: state.toDate,
      onFilter: (model) => store.dispatch(fetchMarginData(
        model.fromDate,
        model.toDate,
      )),
    );
  }
}

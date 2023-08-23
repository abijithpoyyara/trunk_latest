import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_brand_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/sales_insight/brand_connect_analysis.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';
import 'package:base/redux.dart';

class SalesInsightBrandViewModel extends BaseViewModel {
  final List<BrandConnectList> brandConnectlist;

  final Function(SaleInsightFilterModel model) onFilterBrand;

  final bool margin;
  final bool major;
  final DateTime fromDate;
  final DateTime toDate;
  final int qty;
  final double revenue;
  final String brand;

  SalesInsightBrandViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.brandConnectlist,
    this.toDate,
    this.fromDate,
    this.margin,
    this.major,
    this.onFilterBrand,
    this.brand,
    this.qty,
    this.revenue,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  static SalesInsightBrandViewModel fromStore(Store<AppState> store) {
    final state = store.state.salesInsightState.salesInsightBrandState;
    return SalesInsightBrandViewModel(
        loadingStatus: state.loadingStatus,
        loadingMessage: state.loadingMessage,
        errorMessage: state.loadingError,
        brandConnectlist: state.brandConnectList,
        fromDate: state.fromDate,
        margin: state.margin,
        major: state.major,
        toDate: state.toDate,
        qty: state.qty,
        brand: state.brand,
        revenue: state.revenue,
        onFilterBrand: (model) => store.dispatch(fetchBrandConnectList(
            model.fromDate, model.toDate,
            major: model.isMajorCategory)));
  }
}

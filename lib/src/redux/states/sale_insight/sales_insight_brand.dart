import 'package:base/redux.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_base.dart';
import 'package:redstars/src/services/model/response/sales_insight/brand_connect_analysis.dart';

@immutable
class SalesInsightBrandState extends SalesInsightBaseState {
  final List<BrandConnectList> brandConnectList;
  final int qty;
  final String brand;
  final double revenue;

  SalesInsightBrandState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    bool margin,
    bool major,
    DateTime fromDate,
    DateTime toDate,
    this.brandConnectList,
    this.qty,
    this.revenue,
    this.brand,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage,
            margin: margin,
            major: major,
            fromDate: fromDate,
            toDate: toDate);

  @override
  SalesInsightBrandState copyWith({
    LoadingStatus loadingStatus,
    String loadingMessage,
    DateTime fromDate,
    DateTime toDate,
    bool margin,
    bool major,
    String loadingError,
    List<BrandConnectList> brandConnectList,
    int qty,
    double revenue,
    String brand,
  }) {
    return SalesInsightBrandState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      margin: margin ?? this.margin,
      major: major ?? this.major,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      brandConnectList: brandConnectList ?? this.brandConnectList,
      brand: brand ?? this.brand,
      qty: qty ?? this.qty,
      revenue: revenue ?? this.revenue,
    );
  }

  factory SalesInsightBrandState.initial() {
    return new SalesInsightBrandState(
      loadingStatus: LoadingStatus.success,
      loadingError: "",
      loadingMessage: "",
      margin: false,
      major: true,
      fromDate: DateTime(DateTime.now().year, 1),
      toDate: DateTime.now(),
      brandConnectList: null,
      brand: "",
      qty: 0,
      revenue: 0.0,
    );
  }
}

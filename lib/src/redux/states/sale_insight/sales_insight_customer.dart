import 'package:base/redux.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_base.dart';
import 'package:redstars/src/services/model/response/sales_insight/customer_analysis.dart';

@immutable
class SalesInsightCustomerState extends SalesInsightBaseState {
  final int totalCustomers;
  final int repeatCustomers;
  final int onceCustomers;
  final double repeatPercent;
  final double oncePercent;
  final List<CustomerMarginList> marginAnalysis;
  final List<CustomerBranchList> branchAnalysis;

  SalesInsightCustomerState({
    this.branchAnalysis,
    this.totalCustomers,
    this.repeatCustomers,
    this.onceCustomers,
    this.repeatPercent,
    this.oncePercent,
    this.marginAnalysis,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    bool margin,
    bool major,
    DateTime fromDate,
    DateTime toDate,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage,
            margin: margin,
            major: major,
            fromDate: fromDate,
            toDate: toDate);

  @override
  SalesInsightCustomerState copyWith(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      DateTime fromDate,
      DateTime toDate,
      bool margin,
      bool major,
      String loadingError,
      List<CustomerBranchList> branchAnalysis,
      int totalCustomers,
      int repeatCustomers,
      int onceCustomers,
      double repeatPercent,
      double oncePercent,
      List<CustomerMarginList> marginAnalysis}) {
    return SalesInsightCustomerState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        loadingError: loadingError ?? this.loadingError,
        margin: margin ?? this.margin,
        major: major ?? this.major,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        branchAnalysis: branchAnalysis ?? this.branchAnalysis,
        totalCustomers: totalCustomers ?? this.totalCustomers,
        repeatCustomers: repeatCustomers ?? this.repeatCustomers,
        onceCustomers: onceCustomers ?? this.onceCustomers,
        repeatPercent: repeatPercent ?? this.repeatPercent,
        oncePercent: oncePercent ?? this.oncePercent,
        marginAnalysis: marginAnalysis ?? this.marginAnalysis);
  }

  factory SalesInsightCustomerState.initial() {
    return SalesInsightCustomerState(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      branchAnalysis: null,
      marginAnalysis: null,
      totalCustomers: 0,
      repeatCustomers: 0,
      onceCustomers: 0,
      repeatPercent: 0,
      oncePercent: 0,
      fromDate: DateTime(DateTime.now().year, 1),
      toDate: DateTime.now(),
    );
  }
}

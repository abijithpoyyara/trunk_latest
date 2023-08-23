import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:flutter/widgets.dart';

@immutable
class SalesInsightBaseState extends BaseState {
  final DateTime fromDate;
  final DateTime toDate;
  final bool margin;
  final bool major;

  SalesInsightBaseState(
      {this.fromDate,
      this.toDate,
      LoadingStatus loadingStatus,
      String loadingError,
      String loadingMessage,
      this.margin,
      this.major})
      : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  SalesInsightBaseState copyWith(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      String loadingError,
      DateTime fromDate,
      DateTime toDate,
      bool margin,
      bool major}) {
    return SalesInsightBaseState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        loadingError: loadingError ?? this.loadingError,
        margin: margin ?? this.margin,
        major: major ?? this.major,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate);
  }

  factory SalesInsightBaseState.initial() {
    return SalesInsightBaseState(
        loadingError: "",
        loadingMessage: "",
        loadingStatus: LoadingStatus.success,
        major: true,
        margin: false,
        fromDate: DateTime(DateTime.now().year, 1),
        toDate: DateTime.now());
  }
}

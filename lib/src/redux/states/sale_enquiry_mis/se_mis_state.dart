import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_dtl_model.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_mis_model.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/model/branch_model.dart';

@immutable
class SalesEnquiryMisState extends BaseState {
  final LoadingStatus initialReportStatus;

  final DateTime fromDate;
  final DateTime toDate;
  final List<BCCModel> reportType;
  final List<BranchModel> branches;
  final List<FinYearModel> finYears;
  final List<CalendarModel> calenderMonths;
  final int selectedTab;

  final BCCModel selectedReport;
  final BranchModel selectedBranch;
  final FinYearModel selectedFinYear;
  final CalendarModel selectedMonth;

  final bool isAllBranch;
  final DateTime asOnDate;

  final List<SalesEnquiryMisModel> summaryReport;
  final List<SalesEnquiryDtlModel> detailsReport;
  final SalesEnquiryDtlModel selectedDetailParticular;
  final SalesEnquiryMisModel selectedSummaryItem;

  final SEMISBranchModel selectedParticularBranch;

  SalesEnquiryMisState({
    this.fromDate,
    this.toDate,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.asOnDate,
    this.selectedTab,
    this.branches,
    this.finYears,
    this.isAllBranch,
    this.reportType,
    this.calenderMonths,
    this.selectedBranch,
    this.selectedFinYear,
    this.selectedMonth,
    this.selectedReport,
    this.summaryReport,
    this.detailsReport,
    this.selectedSummaryItem,
    this.selectedDetailParticular,
    this.selectedParticularBranch,
    this.initialReportStatus,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  SalesEnquiryMisState copyWith({
    LoadingStatus loadingStatus,
    LoadingStatus initialReportStatus,
    String loadingMessage,
    String loadingError,
    int selectedTab,
    DateTime fromDate,
    DateTime toDate,
    List<BCCModel> reportType,
    List<BranchModel> branches,
    List<FinYearModel> finYears,
    List<CalendarModel> calenderMonths,
    bool isAllBranch,
    DateTime asOnDate,
    BCCModel selectedReport,
    BranchModel selectedBranch,
    FinYearModel selectedFinYear,
    CalendarModel selectedMonth,
    List<SalesEnquiryMisModel> summaryReport,
    List<SalesEnquiryDtlModel> detailsReport,
    SalesEnquiryMisModel selectedSummaryItem,
    SalesEnquiryDtlModel selectedParticular,
    SEMISBranchModel selectedParticularBranch,
    bool onSummaryFetch = false,
  }) {
    return SalesEnquiryMisState(
      initialReportStatus: initialReportStatus ?? this.initialReportStatus,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      fromDate: fromDate ?? this.fromDate,
      selectedTab: selectedTab ?? this.selectedTab,
      toDate: toDate ?? this.toDate,
      asOnDate: asOnDate ?? this.asOnDate,
      branches: branches ?? this.branches,
      finYears: finYears ?? this.finYears,
      isAllBranch: isAllBranch ?? this.isAllBranch,
      calenderMonths: calenderMonths ?? this.calenderMonths,
      reportType: reportType ?? this.reportType,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedFinYear: selectedFinYear ?? this.selectedFinYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedReport: selectedReport ?? this.selectedReport,
      summaryReport: summaryReport ?? this.summaryReport,
      detailsReport: detailsReport ?? this.detailsReport,
      selectedSummaryItem: onSummaryFetch
          ? selectedSummaryItem
          : selectedSummaryItem ?? this.selectedSummaryItem,
      selectedDetailParticular: onSummaryFetch
          ? selectedParticular
          : selectedParticular ?? this.selectedDetailParticular,
      selectedParticularBranch:
          selectedParticularBranch ?? this.selectedParticularBranch,
    );
  }

  factory SalesEnquiryMisState.initial() {
    return SalesEnquiryMisState(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      initialReportStatus: LoadingStatus.success,
      selectedTab: 1,
      fromDate: DateTime(DateTime.now().year, 1),
      toDate: DateTime.now(),
      asOnDate: DateTime.now(),
      reportType: [],
      calenderMonths: [],
      isAllBranch: true,
      finYears: [],
      branches: [],
      selectedBranch: null,
      selectedFinYear: null,
      selectedMonth: null,
      selectedReport: null,
      summaryReport: [],
      detailsReport: [],
      selectedSummaryItem: null,
      selectedDetailParticular: null,
      selectedParticularBranch: null,
    );
  }
}

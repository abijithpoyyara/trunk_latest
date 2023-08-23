import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/actions/sales_enquiry_mis/sale_enquiry_mis_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_dtl_model.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_mis_model.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/model/branch_model.dart';

class SalesEnquiryMisViewModel extends BaseViewModel {
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
  final SalesEnquiryMisModel selectedSummaryItem;
  final SalesEnquiryDtlModel selectedDetailParticular;
  final List<SEMISBranchModel> selectedBranchWiseGroup;
  final SEMISBranchModel selectedParticularBranch;

  final Function(FinYearModel finyear) onFinYearChanged;
  final VoidCallback getReportOnAsonDate;
  final Function(DateTime fromDate, DateTime, CalendarModel, int)
      getReportOnPeriod;
  final Function(SalesEnquiryMisModel enqItem) getDetailReport;
  final Function(SalesEnquiryMisModel enqItem) collapseItemSummary;
  final Function(SalesEnquiryDtlModel particular) onParticularClicked;
  final Function(SEMISBranchModel particular) onParticularBranchClicked;
  final Function(BCCModel, bool, BranchModel) onChangeFilters;

  SalesEnquiryMisViewModel({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.initialReportStatus,
    this.fromDate,
    this.toDate,
    this.asOnDate,
    this.branches,
    this.selectedTab,
    this.finYears,
    this.isAllBranch,
    this.reportType,
    this.calenderMonths,
    this.selectedBranch,
    this.selectedFinYear,
    this.selectedMonth,
    this.selectedReport,
    this.selectedSummaryItem,
    this.selectedDetailParticular,
    this.selectedBranchWiseGroup,
    this.collapseItemSummary,
    this.detailsReport,
    this.summaryReport,
    this.selectedParticularBranch,
    this.onFinYearChanged,
    this.getReportOnAsonDate,
    this.getReportOnPeriod,
    this.getDetailReport,
    this.onParticularClicked,
    this.onParticularBranchClicked,
    this.onChangeFilters,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        ) {
    selectedBranchWiseGroup
        ?.sort((x, y) => x.branchName.compareTo(y.branchName));
  }

  factory SalesEnquiryMisViewModel.fromStore(Store<AppState> store) {
    final state = store.state.salesEnquiryMisState;

    Map<String, List<MisEnquiryDtl>> branchGroup = state
        .selectedDetailParticular?.details
        ?.groupBy<String>((model) => model.branch);

    return SalesEnquiryMisViewModel(
      loadingError: state.loadingError,
      loadingMessage: state.loadingMessage,
      loadingStatus: state.loadingStatus,
      initialReportStatus: state.initialReportStatus,
      fromDate: state.fromDate,
      toDate: state.toDate,
      selectedTab: state.selectedTab,
      asOnDate: state.asOnDate,
      branches: state.branches,
      finYears: state.finYears,
      isAllBranch: state.isAllBranch,
      reportType: state.reportType,
      calenderMonths: state.calenderMonths,
      selectedBranch: state.selectedBranch,
      selectedFinYear: state.selectedFinYear,
      selectedMonth: state.selectedMonth,
      selectedReport: state.selectedReport,
      detailsReport: state.detailsReport,
      selectedSummaryItem: state.selectedSummaryItem,
      summaryReport: state.summaryReport,
      selectedDetailParticular: state.selectedDetailParticular,
      selectedParticularBranch: state.selectedParticularBranch,
      selectedBranchWiseGroup: branchGroup?.entries
              ?.map((e) => SEMISBranchModel(e.key, e.value))
              ?.toList() ??
          [],
      onFinYearChanged: (finYear) =>
          store.dispatch(getFinYearMonthAction(finYear, 3)),
      onChangeFilters: (reportType, isAllBranch, branch) {
        store.dispatch(getSEMISSummaryReport(
          toDate: state.asOnDate,
          isAsOnDate: true,
          isAllBranch: isAllBranch,
          reportType: reportType.id,
          branch: branch,
        ));
      },
      getReportOnAsonDate: () => store.dispatch(getSEMISSummaryReport(
        toDate: state.asOnDate,
        isAsOnDate: true,
        isAllBranch: state.isAllBranch,
        reportType: state.selectedReport.id,
        selectedTab: 1,
        branch: state.selectedBranch,
      )),
      getReportOnPeriod: (from, to, month, selectedTab) =>
          store.dispatch(getSEMISSummaryReport(
        isAllBranch: state.isAllBranch,
        branch: state.selectedBranch,
        isAsOnDate: false,
        toDate: to,
        fromDate: from,
        reportType: state.selectedReport.id,
        selectedTab: selectedTab,
        selectedMonth: month,
      )),
      getDetailReport: (enqItem) {
        store.dispatch(getSEMISDtlReport(
          toDate: state.toDate,
          fromDate: state.fromDate,
          reportType: state.selectedReport.id,
          isAsOnDate: state.selectedTab == 1,
          summaryItem: enqItem,
          isAllBranch: state.isAllBranch,
          branch: state.selectedBranch,
        ));
      },
      collapseItemSummary: (enquiryItem) =>
          store.dispatch(CollapseItemSummaryAction(enquiryItem)),
      onParticularClicked: (particular) =>
          store.dispatch(OnParticularSelectedAction(particular)),
      onParticularBranchClicked: (branch) =>
          store.dispatch(OnParticularBranchSelectedAction(branch)),
    );
  }

  void onDateChanged({DateTime fromDate, DateTime toDate}) {
    fromDate ??= this.fromDate;
    toDate ??= this.toDate;
    if (!(fromDate != this.fromDate && toDate != this.toDate)) {
      if (fromDate.isBefore(toDate)) {
        getReportOnPeriod(fromDate, toDate, null, 2);
      }
    }
  }

  void getReportOnMonth(CalendarModel month) {
    getReportOnPeriod(DateTime.tryParse(month.startdate),
        DateTime.tryParse(month.enddate), month, 3);
  }

  String getFilterSummary() {
    String summary = "";
    // summary += selectedReport.code;
    summary += 'Showing results from ';
    summary += isAllBranch ? "All Branches" : selectedBranch?.name ?? "";
    return summary;
  }

  void onEnquiryItemClick(SalesEnquiryMisModel enqItem) {
    if (selectedSummaryItem?.itemId == enqItem.itemId)
      collapseItemSummary(enqItem);
    else
      getDetailReport(enqItem);
  }

  List<SalesEnquiryMisModel> getSortedReportSummary() {
    List<SalesEnquiryMisModel> sortedSummaryReport = summaryReport;
    sortedSummaryReport.sort((a, b) {
      if (a.itemId == selectedSummaryItem?.itemId)
        return -1;
      else if (b.itemId == selectedSummaryItem?.itemId)
        return 1;
      else
        return 0;
    });
    return sortedSummaryReport;
  }
}

import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_dtl_model.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_mis_model.dart';
import 'package:redstars/src/services/repository/sales_enquiry_mis/se_mis_repository.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/model/branch_model.dart';

class OptionConfigurationFetchedAction {
  List<FinYearModel> finYears;
  List<BCCModel> reportType;
  List<BranchModel> branches;

  OptionConfigurationFetchedAction(
    this.finYears,
    this.reportType,
    this.branches,
  );
}

class SEMISSummaryFetchedAction {
  final List<SalesEnquiryMisModel> summaryReport;
  final DateTime fromDate;
  final DateTime toDate;
  final int reportType;
  final int selectedTab;
  final bool isAllBranch;
  final bool isAsOnDate;
  final CalendarModel selectedMonth;
  final BranchModel branch;

  SEMISSummaryFetchedAction(
    this.summaryReport, {
    this.selectedMonth,
    this.fromDate,
    this.toDate,
    this.reportType,
    this.isAllBranch,
    this.isAsOnDate,
    this.selectedTab,
    this.branch,
  });
}

class SEMISDtlFetchedAction {
  List<SalesEnquiryDtlModel> dtlReport;
  SalesEnquiryMisModel summaryItem;

  SEMISDtlFetchedAction(this.dtlReport, this.summaryItem);
}

class FinYearMonthFetchedAction {
  final List<CalendarModel> months;
  final int selectedTab;
  final FinYearModel finYear;

  FinYearMonthFetchedAction(this.months, this.finYear, this.selectedTab);
}

class CollapseItemSummaryAction {
  final SalesEnquiryMisModel enquiryItem;

  CollapseItemSummaryAction(this.enquiryItem);
}

class OnParticularSelectedAction {
  SalesEnquiryDtlModel particular;

  OnParticularSelectedAction(this.particular);
}

class OnParticularBranchSelectedAction {
  String branchName;
  List<MisEnquiryDtl> enquiries;
  SEMISBranchModel branch;

  OnParticularBranchSelectedAction(this.branch) {
    branchName = branch.branchName;
    enquiries = branch.enquiryDetails;
  }
}

ThunkAction getSEMISInitialConfigs() {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Initializing Option",
        type: "SaleEnquiryMis",
      ));

      SEMisRepository().getInitialConfigs(
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                type: "SaleEnquiryMis",
              )),
          onRequestSuccess: ({
            List<FinYearModel> finYears,
            List<BCCModel> reportType,
            List<BranchModel> branches,
          }) {
            store.dispatch(OptionConfigurationFetchedAction(
              finYears,
              reportType,
              branches,
            ));

            store.dispatch(getSEMISSummaryReport(
              reportType: reportType.first.id,
              isAllBranch: true,
              isAsOnDate: true,
              fromDate: null,
              toDate: DateTime.now(),
              isInitialFetch: true,
            ));
          });
    });
  };
}

ThunkAction getFinYearMonthAction(
  FinYearModel finYear,
  int selectedTab,
) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting Months",
        type: "SaleEnquiryMis",
      ));

      SEMisRepository().getFinYearMonths(
          finYearId: finYear.id,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                type: "SaleEnquiryMis",
              )),
          onRequestSuccess: (months) {
            store.dispatch(
                FinYearMonthFetchedAction(months, finYear, selectedTab));
          });
    });
  };
}

ThunkAction getSEMISSummaryReport({
  DateTime fromDate,
  DateTime toDate,
  int reportType,
  bool isAllBranch,
  bool isAsOnDate,
  int selectedTab,
  CalendarModel selectedMonth,
  BranchModel branch,
  bool isInitialFetch = false,
}) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Report",
        type: isInitialFetch ? "SaleEnquiryMISReport" : "SaleEnquiryMis",
      ));

      SEMisRepository().getReportSummary(
          allBranch: isAllBranch,
          fromDate: fromDate,
          toDate: toDate,
          onDate: isAsOnDate,
          reportTypeBccId: reportType,
          branch: branch,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                type: "SaleEnquiryMis",
              )),
          onRequestSuccess: (summaryReport) {
            store.dispatch(SEMISSummaryFetchedAction(
              summaryReport,
              isAllBranch: isAllBranch,
              branch: branch,
              fromDate: fromDate,
              toDate: toDate,
              selectedMonth: selectedMonth,
              isAsOnDate: isAsOnDate,
              reportType: reportType,
              selectedTab: selectedTab,
            ));
          });
    });
  };
}

ThunkAction getSEMISDtlReport({
  DateTime fromDate,
  DateTime toDate,
  int reportType,
  bool isAllBranch,
  bool isAsOnDate,
  SalesEnquiryMisModel summaryItem,
  BranchModel branch,
}) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Report",
        type: "SaleEnquiryMis",
      ));

      SEMisRepository().getReportDtl(
          allBranch: isAllBranch,
          fromDate: fromDate,
          toDate: toDate,
          onDate: isAsOnDate,
          reportTypeBccId: reportType,
          branch: branch,
          itemId: summaryItem.itemId,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                type: "SaleEnquiryMis",
              )),
          onRequestSuccess: (dtlReport) {
            store.dispatch(SEMISDtlFetchedAction(dtlReport, summaryItem));
          });
    });
  };
}

import 'dart:ui';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/sales_enquiry_mis/sale_enquiry_mis_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_enquiry_mis/sales_enquiry_mis_viewmodel.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_dtl_model.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_mis_model.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/partials/branch_particulars.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/sales_enquires_view.dart';

class SEMISParticularScreen extends StatelessWidget {
  final SalesEnquiryMisModel enqItem;

  const SEMISParticularScreen({Key key, this.enqItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, SalesEnquiryMisViewModel>(
        init: (store, context) {
          final state = store.state.salesEnquiryMisState;
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
        onInitialBuild: (viewModel) {
          // viewModel.onEnquiryItemClick(enqItem);
        },
        converter: (store) => SalesEnquiryMisViewModel.fromStore(store),
        appBar: BaseAppBar(
          title: Text("Sales Enquiry MIS"),
        ),
        builder: (context, viewModel) {
          return Column(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                scrollDirection: Axis.horizontal,
                child: IntrinsicWidth(
                  child: Row(
                      children: viewModel
                          .getSortedReportSummary()
                          .map((e) => _buildHeaderWidget(
                              selected: e.itemId ==
                                  viewModel.selectedSummaryItem?.itemId,
                              item: e,
                              onTap: () => viewModel.getDetailReport(e)))
                          .toList()),
                ),
              ),
              Expanded(
                child: Container(
                  color: ThemeProvider.of(context).primaryColor,
                  // color: Colors.grey.withOpacity(.4),
                  child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: viewModel.detailsReport?.length ?? 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 4.0,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, pos) {
                        var particular = viewModel.detailsReport[pos];

                        return MISGridTile(
                          position: pos,
                          primaryTitle: "${particular.particulars} ",
                          count: particular.total,
                          primaryIcon: Icons.view_agenda,
                          onClick: particular.total > 0
                              ? () {
                                  viewModel.onParticularClicked(particular);
                                  BaseNavigate(
                                      context,
                                      BranchWiseParticulars(
                                        particular: particular,
                                      ));
                                }
                              : null,
                        );
                      }),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildHeaderWidget({
    bool selected = false,
    SalesEnquiryMisModel item,
    VoidCallback onTap,
  }) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: selected ? null : onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 21),
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: selected
                  ? ThemeProvider.of(context).primaryColor
                  : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                if (selected)
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      offset: Offset(0, 12),
                      blurRadius: 20)
              ]),
          child: DefaultTextStyle(
            style: BaseTheme.of(context)
                .subhead1Semi
                // .subtitle1
                .copyWith(
                    color: selected
                        ? Colors.white
                        : ThemeProvider.of(context).primaryColorDark),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    !selected
                        ? Icons.check_circle_outline_outlined
                        : Icons.check_circle_outline_outlined,
                    color: selected ? Colors.white : null,
                  ),
                  SizedBox(width: 12.5),
                  Text("${BaseStringCase(item.itemName).titleCase}")
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class BranchWiseParticulars extends StatelessWidget {
  final SalesEnquiryDtlModel particular;

  const BranchWiseParticulars({Key key, this.particular}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, SalesEnquiryMisViewModel>(
      converter: (store) => SalesEnquiryMisViewModel.fromStore(store),
      appBar: BaseAppBar(
        title: Text("${particular.particulars}"),
      ),
      builder: (con, viewModel) => Builder(builder: (context) {
        return Container(
          decoration: BoxDecoration(
            // color: Theme.of(context).primaryColor.withOpacity(.6),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(8.0),
          child: BranchListView(
            onTap: (branch) {
              viewModel.onParticularBranchClicked(branch);
              Navigator.push(
                  context,
                  BaseNavigate.slideUp(SalesEnquiryDetailsScreen(
                      title:
                          "${particular.particulars} - ${branch.branchName}")));
            },
          ),
        );
      }),
    );
  }
}

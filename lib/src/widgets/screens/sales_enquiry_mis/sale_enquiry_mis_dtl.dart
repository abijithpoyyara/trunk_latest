import 'dart:ui';

import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_enquiry_mis/sales_enquiry_mis_viewmodel.dart';
import 'package:redstars/src/services/model/response/sale_enquiry_mis/sales_enquiry_mis_model.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/model/branch_model.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/partials/branch_particulars.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/partials/enquiry_item.dart';
import 'package:redstars/src/widgets/screens/sales_enquiry_mis/sales_enquires_view.dart';

class SalesEnquiryMisDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseStore<AppState, SalesEnquiryMisViewModel>(
      converter: (store) => SalesEnquiryMisViewModel.fromStore(store),
      builder: (context, viewModel) => Container(
          padding: EdgeInsets.only(top: 8),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: viewModel.detailsReport?.length ?? 0,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (cont, pos) {
                var particular = viewModel.detailsReport[pos];
                return Column(
                  children: [
                    DocumentTypeTile(
                      // leading: SizedBox(),
                      icon: Icons.view_agenda,
                      title: "${particular.particulars} ",
                      trailing: "${particular.total}",
                      onPressed: particular.total > 0
                          ? () {
                              viewModel.onParticularClicked(particular);
                              showModalBottomSheet(
                                  context: context,
                                  useRootNavigator: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24)),
                                  ),
                                  // backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(24)),
                                        ),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 4,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              24))),
                                              width: 140,
                                            ),
                                            SizedBox(height: 8),
                                            Text("${particular.particulars}"),
                                            SizedBox(height: 8),
                                            Expanded(
                                              child: BranchListView(
                                                onTap: (branch) {
                                                  viewModel
                                                      .onParticularBranchClicked(
                                                          branch);
                                                  Navigator.push(
                                                      context,
                                                      BaseNavigate.slideUp(
                                                          SalesEnquiryDetailsScreen(
                                                              title:
                                                                  "${particular.particulars} - ${branch.branchName}")));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                            }
                          : null,
                    ),
                  ],
                );
              })),
    );
  }
}

class BranchStatusItem extends StatelessWidget {
  final Icon icon;
  final Icon leading;
  final String title;
  final Function() onPressed;

  final SEMISBranchModel branch;

  const BranchStatusItem({
    Key key,
    this.icon,
    this.leading,
    this.title,
    this.onPressed,
    this.branch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    BaseTheme textTheme = BaseTheme.of(context);

    return InkWell(
      onTap: onPressed,
      child: Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(0, 4), blurRadius: 6)
              ]),
          child: IntrinsicHeight(
            child: Row(children: [
              SizedBox(width: 6),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${branch.branchName}',
                      style: textTheme.button,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    Text('${branch.enquiryDetails.length}',
                        style: textTheme.display1Semi
                            .copyWith(color: Colors.black)),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                  flex: 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: branch.statuses.entries
                                  .map((e) => _buildStatus(
                                      count: e.value?.length ?? 0,
                                      status: e.key))
                                  .toList(),
                            ),
                          ),
                        ),
                        Divider(),
                      ])),
              SizedBox(width: 6),
            ]),
          )),
    );
  }

  Widget _buildStatus({int count = 0, String status}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              status,
              style: ThemeData().textTheme.button,
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getIcon(status),
                SizedBox(width: 6),
                Text(
                  '$count',
                  style: ThemeData().textTheme.bodyText1,
                ),
              ],
            ),
            VerticalDivider()
          ],
        ),
      ),
    );
  }

  Icon _getIcon(String status) {
    switch (status) {
      case "PENDING":
        return Icon(
          Icons.hourglass_bottom,
          color: Colors.black,
          size: 16,
        );
      case "APPROVED":
        return Icon(
          Icons.approval,
          color: Colors.green,
          size: 16,
        );
      case "REJECTED":
        return Icon(
          Icons.remove_circle,
          color: Colors.red,
          size: 16,
        );

      default:
        return Icon(Icons.approval);
    }
  }
}

class SEMISDtlScreen extends StatelessWidget {
  final SalesEnquiryMisModel enquiryItem;

  const SEMISDtlScreen({Key key, this.enquiryItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    return Scaffold(
      appBar: BaseAppBar(title: Text("Sale Enquiry Details")),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                  'https://bikeadvice.in/wp-content/uploads/2013/10/TVS-King-Auto-Rickshaw.jpg',
                ),
              )),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          // border: Border.all(color: Colors.red),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                            Colors.grey,
                            Colors.transparent,

                            // Colors.grey,
                          ])),
                      alignment: Alignment.bottomRight,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("TVS KING 400 GS",
                                    textAlign: TextAlign.left,
                                    style: theme.subhead1.copyWith(
                                      color: Colors.white,
                                    )),
                                SizedBox(height: 4),
                                _buildStockDetail(
                                  color: Colors.orange,
                                  title: "Branch Stock",
                                  inStock: 20,
                                  sold: 48,
                                ),
                                SizedBox(height: 12),
                                _buildStockDetail(
                                  color: Colors.red,
                                  title: "Other Branch Stock",
                                  inStock: 44,
                                  sold: 48,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6),
                          IconButton(
                              splashColor: Colors.red,
                              enableFeedback: true,
                              tooltip: "View Branch wise",
                              icon: Icon(
                                Icons.view_list_outlined,
                                size: 24,
                                color: Colors.white,
                              ),
                              onPressed: () {})
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: BaseNestedTabBar(
                isScrollable: true,
                tabs: List.generate(10, (index) {
                  return BaseTabPage(
                      title: "Sales Enquiries Prepared (152)",
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BaseNestedTabBar(
                            color: Colors.white,
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: Colors.redAccent,
                            labelColor: Colors.white,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue),
                            isScrollable: true,
                            tabs: List.generate(
                                10,
                                (index) => BaseTabPage(
                                    title: "Mekele Branch (22)",
                                    body: Scrollbar(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 250,
                                          // physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (cont, pos) {
                                            return SaleEnquiryItem(
                                                branch: "Mekele Branch",
                                                uniqueNo: "473100092/20MEK",
                                                createdDate: "09-09-2020",
                                                enquiryNo: "LSE-00001/20MEK",
                                                status: "PENDING");
                                          }),
                                    )))),
                      ));
                })),
          )
        ],
      ),
    );
  }

  Widget _buildStockDetail({
    String title,
    int inStock,
    int sold,
    Color color,
  }) {
    return Builder(builder: (BuildContext context) {
      BaseTheme textTheme = BaseTheme.of(context);

      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("$title",
                  style: textTheme.bodyBold.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  )),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "$inStock/$sold",
                  style: textTheme.bodyBold.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
        SizedBox(height: 4),
        Padding(
            padding: EdgeInsets.only(left: 6),
            child: LinearProgressIndicator(
              minHeight: 5,
              value: inStock / sold,
              valueColor: AlwaysStoppedAnimation(color),
              backgroundColor: Colors.white.withOpacity(.3),
            ))
      ]);
    });
  }
}

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request_approval/transaction_unblock_request_approval_viewmodel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_head_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_model.dart';

import 'approval_notification_dtl.dart';

class TransactionUnblockApprovalListViewScreen extends StatefulWidget {
  final TransactionUnblockListHeading reportHeader;
  final List<TransactionUnblockListView> reportData;
  final TransactionUnblockReqApprlViewModel viewModel;
  final bool isNotificationView;
  final bool isUserRightToApprove;
  final bool isFromBranchBlock;
  final int transReqOptionId;
  final int notificationOptionId;
  final int reportFormatId;
  final int branchid;
  final int subOptionId;
  final int optionIdFromBranchBlock;
  final bool isAllBranchSelected;
  final bool onUserClickNotification;
  final List<Dtl> header;


  const TransactionUnblockApprovalListViewScreen(
      {Key key,
      this.reportHeader,
      this.reportData,
      this.reportFormatId,
      this.viewModel,
      this.branchid,
      this.subOptionId,
      this.optionIdFromBranchBlock,
      this.transReqOptionId,
      this.notificationOptionId,
      this.isNotificationView = true,
      this.isUserRightToApprove,
      this.isFromBranchBlock,
      this.isAllBranchSelected, 
      this.onUserClickNotification = false,
        this.header,
        })
      : super(key: key);

  @override
  TransactionUnblockApprovalListViewScreenState createState() =>
      TransactionUnblockApprovalListViewScreenState( );
}

class TransactionUnblockApprovalListViewScreenState
    extends State<TransactionUnblockApprovalListViewScreen> {




  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color color;
    return widget.reportData != null
        ? ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics( ),
            itemCount: widget.reportData?.length,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              List<UnreadNotificationListModel> unreadContainsList;
              unreadContainsList = widget.viewModel.unreadList
                  .where((element) =>
                      element.transid ==
                      widget.reportData[index].transunblockrequestid)
                  .toList();
              print(unreadContainsList);
              unreadContainsList.forEach((element) {
                if (element.transid ==
                        widget.reportData[index].transunblockrequestid &&
                    element.readstatusyn == "N") {
                  widget.reportData[index].color =
                      colors.secondaryDark.withOpacity(0.8);
                  color = colors.secondaryDark.withOpacity(0.8);
                } else {
                  widget.reportData[index].color = colors.primaryColor;
                  color = colors.primaryColor;
                }
                return color;
              });

              return GestureDetector(
                  onTap: ( ) {
                    print(widget?.isFromBranchBlock);
                    print(widget?.isUserRightToApprove);
                    print(widget.viewModel.optionId2);
                    if (widget?.isUserRightToApprove ?? true) {
                      BaseNavigate(
                          context,
                          TransUnblockReqApprovalEdit(
                            branchid: widget.branchid,
                            allBranchYN: widget.isAllBranchSelected,
                            id: widget.subOptionId,
                            optionIdFromBranchBlock:
                                widget.optionIdFromBranchBlock,
                            index: index,
                            viewModel: widget.viewModel,
                            reportFormatId: widget.reportFormatId,
                            data: widget.reportData,
                            unblockBranchId:
                              widget.reportData[index].branchid,
                            onUserClickNotification: widget.onUserClickNotification,
                          ));
                    } else if (widget.isNotificationView &&
                        (!widget.isUserRightToApprove) &&
                        (!widget?.isFromBranchBlock ?? false)) {
                      widget.viewModel.setNotificationAsReadFunction(
                        optionId: widget.notificationOptionId,
                        transId:
                            widget.reportData[index].transunblockrequesttableid,
                        transTableId:
                            widget.reportData[index].transunblockrequestid,
                        notificationId: widget.transReqOptionId,
                        branchId: widget.reportData[index].branchid

                      );
                      BaseNavigate(
                          context,
                          TransUnblockReqApprovalEdit(
                            id: widget.subOptionId,
                            allBranchYN: widget.isAllBranchSelected,

                            index: index,
                            branchid: widget.branchid,
                            optionIdFromBranchBlock:
                                widget.optionIdFromBranchBlock,
                            viewModel: widget.viewModel,
                            reportFormatId: widget.reportFormatId,
                            data: widget.reportData,
                            onUserClickNotification: widget.onUserClickNotification,

                          ));
                    }
                    // if (widget?.isUserRightToApprove) if (widget
                    //         .isNotificationView &&
                    //     widget?.isUserRightToApprove) {
                    //   BaseNavigate(
                    //       context,
                    //       TransUnblockReqApprovalEdit(
                    //         index: index,
                    //         viewModel: widget.viewModel,
                    //         data: widget.reportData,
                    //       ));
                    // } else if (widget.viewModel.optionId2 != null &&
                    //     widget.viewModel.optionId2 > 0 &&
                    //     widget.isNotificationView) {
                    //   print(widget?.isUserRightToApprove);
                    //   BaseNavigate(
                    //       context,
                    //       TransUnblockReqApprovalEdit(
                    //         index: index,
                    //         viewModel: widget.viewModel,
                    //         data: widget.reportData,
                    //       ));
                    // } else {
                    //   BaseNavigate(
                    //       context,
                    //       TransUnblockReqApprovalEdit(
                    //         index: index,
                    //         viewModel: widget.viewModel,
                    //         data: widget.reportData,
                    //       ));
                    // }
                  },
              child: Card(
                      color: widget.reportData[index].color ??
                          themeData.primaryColor,
                  // height: height * .4,
                  margin: EdgeInsets.all(10),
                  // padding: EdgeInsets.symmetric(
                  //     horizontal: width * .03, vertical: height * .012),
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(19),
                  //     color: themeData.primaryColor),
                  child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        child: widget.header != null
                            ? Column(
                          children: widget.header?.map<Widget>((mode) {
                                return Column(
//                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                  SizedBox(
                                    height: 2,
                                  ),

                                  Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                          Flexible(
                                            flex: 1,
                                        child: Text(
                                          mode?.header == null
                                              ? '- -'
                                              : '${mode?.header??""}',
                                              // maxLines: 2,
                                          textAlign: TextAlign.start,
                                              // softWrap: true,
                                        ),
                                      ),
//                                       SizedBox(width: 15,),
                                      Flexible(
                                        flex: 2,
                                          child: Text(
                                            mode.formatnumberyn
                                                ? BaseNumberFormat(
                                                        number: num.parse(
                                                            '${widget.reportData[index]?.data[mode?.dataindex] ?? 0}'))
                                                    .formatCurrency()
                                                : '${widget.reportData[index]?.data[mode?.dataindex] ?? "NA"}',
                                             // maxLines: 2,
                                           // softWrap:  true,
                                            textAlign: TextAlign.end,
                                                // overflow: TextOverflow.ellipsis,
                                              style: style.body2Medium),
                                      ),
                                    ]),
                                  ),
//                              ),
//  SizedBox(width: 15,),
                              ]);

//                        );
                              })?.toList())
                            : Center(child: BaseLoadingView(
                                message: "Loading",),),
                  )));
            })
        : (widget.viewModel.statusCode == 1) &&
                (widget.reportData?.isEmpty ?? false)
            ? Center(child: Text("No data"))
            : Center(
                child: BaseLoadingView(
                  message: "Loading",
                ),
              );
  }
}

class _TextWidget extends StatelessWidget {
  final bool isTitle;
  final bool isBold;
  final String header;
  final String value;
  final String last;
  final Color fontColor;

  final TextAlign alignment;

  const _TextWidget(
      {Key key,
      this.header,
      this.isTitle,
      this.value,
      this.last,
      this.fontColor = Colors.white,
      this.isBold = false,
      this.alignment = TextAlign.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    return isTitle ?? false
        ? Text(
            value,
            textAlign: alignment,
            style: style.bodyBold.copyWith(color: Colors.white),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.zero,
                child: Text(
                  "${header ?? ""} : ",
                  style: style.body2Medium.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    value,
                    textAlign: alignment,
                    style: style.body2.copyWith(
                        color: Colors.white, fontWeight: BaseTextStyle.regular
                        // fontWeight:
                        // isBold ? BaseTextStyle.bold : BaseTextStyle.light
                        ),
                  ),
                ),
              )
            ],
          );
  }
}

class _IconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _IconWidget({Key key, this.icon, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: size ?? 22);
  }
}

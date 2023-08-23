import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/grading_and_costing/grading_and_costing_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/grading_and_costing/grading_and_costing.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/process_from_list.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/utility.dart';

import 'helper/grade_filter_view.dart';
import 'model/grading_model.dart';

class GradingCostingDetail extends StatefulWidget {
  final ProcessFromGinList processedData;
  final GradingCostingViewModel viewModel;

  const GradingCostingDetail({Key key, this.processedData, this.viewModel})
      : super(key: key);

  @override
  _GradingCostingDetailState createState() => _GradingCostingDetailState();
}

class _GradingCostingDetailState extends State<GradingCostingDetail> {
  int _currentIndex = 0;
  bool checkRate = false;
  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    int gradeIndex;
    void funData(int index) {
      getTextWidgets(widget.viewModel.itemDetailList[index].gradeModelData);
    }

    return BaseView<AppState, GradingCostingViewModel>(
      init: (store, con) {
        store.dispatch(fetchGradingListData(widget.processedData.ginid));
        store.dispatch(fetchCurrencyExchangeList());
      },
      // onDispose: (store) => store.dispatch(OnClearAction()),
      converter: (store) => GradingCostingViewModel.fromStore(store),
      onDidChange: (viewModel, context) {
        if (viewModel.saveData)
          showSuccessDialog(context, "Saved Successfully", "Success", () {
            viewModel.onClear();
            Navigator.pop(context);
            viewModel.onRefresh();
          });
      },
      builder: (context, viewModel) {
        //  gradeIndex = widget.viewModel.itemDetailList.length;
        List<GradeModel> list = [];
        // var length;
        BaseColors colors = BaseColors.of(context);
        BaseTheme theme = BaseTheme.of(context);
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: BaseAppBar(
            title: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.processedData?.ginno ?? ""),
                  Text(widget.processedData?.gindate ?? "")
                ],
              ),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    bool flag = true;

                    viewModel.listOfGradeModel.forEach((element) {
                      if (!(element?.rate > 0)) {
                        flag = false;
                      }
                      return flag;
                    });
                    if (flag) {
                      viewModel.saveGradingCosting();
                    } else {
                      showAlert(context, viewModel);
                    }
                  })
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  flex: 3,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.gradingList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Card(
                            elevation: 5,
                            color: themedata.primaryColor,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  buildRow(
                                      title: "Purchase Order No",
                                      value: viewModel.gradingList.first
                                              ?.purchaseOderNo ??
                                          ""),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  buildRow(
                                      title: "Purchase Order Date",
                                      value: viewModel.gradingList.first
                                              ?.purchaseOderDate ??
                                          ""),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  buildRow(
                                      title: "Supplier",
                                      value: viewModel.gradingList.first
                                              ?.suppliername ??
                                          ""),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("", textAlign: TextAlign.left),
                                      Text(
                                        viewModel
                                                .gradingList[index]?.address1 ??
                                            "" +
                                                "\n" +
                                                viewModel.gradingList[index]
                                                    ?.address2 ??
                                            "" +
                                                "\n" +
                                                viewModel.gradingList[index]
                                                    ?.address3 ??
                                            "",
                                        textAlign: TextAlign.right,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //  ),
                        );
                      })),
              Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(9),
                          width: width,
                          child: Text("Item Details")),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: viewModel.itemDetailList.length,
                            // shrinkWrap: true,
                            itemBuilder: (
                              context,
                              int pos,
                            ) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    color: themedata.primaryColor,
                                    child: Container(
                                        height: height * .12,
                                        margin: EdgeInsets.only(bottom: 1),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: themedata.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              // border: Border(
                                              //     bottom: BorderSide(
                                              //         color: themedata
                                              //             .primaryColor)
                                              //)),
                                            ),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Flexible(
                                                    child: Row(children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            color: themedata
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: SvgPicture.asset(
                                                          AppVectors.itemBox,
                                                          height: height * .05,
                                                          width: width * .06,
                                                        ),
                                                        // ),
                                                      ),
                                                      SizedBox(width: 15),
                                                      Expanded(
                                                          //flex: 20,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                            Flexible(
                                                              child: Text(
                                                                viewModel
                                                                        .itemDetailList[
                                                                            pos]
                                                                        .itemName ??
                                                                    "",
                                                                style: theme
                                                                    .subhead1Bold,
                                                              ),
                                                            ),
                                                            SizedBox(height: 6),
                                                            Text(
                                                              viewModel
                                                                      .itemDetailList[
                                                                          pos]
                                                                      .itemCode ??
                                                                  "",
                                                              style: theme
                                                                  .smallMedium,
                                                            ),
                                                            SizedBox(height: 6),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Qty :",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: theme
                                                                      .smallMedium,
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  (viewModel
                                                                          .itemDetailList[
                                                                              pos]
                                                                          .qty)
                                                                      .toString(),
                                                                  style: theme
                                                                      .smallMedium,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 6)
                                                          ])),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Container(
                                                            height:
                                                                height * .038,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(colors
                                                                            .secondaryDark),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              // color: themedata.primaryColorDark,
                                                              onPressed: () {
                                                                showItemDetailSelectionSheet(
                                                                    context,
                                                                    pos,
                                                                    itemId: viewModel
                                                                        .itemDetailList[
                                                                            pos]
                                                                        .itemId,
                                                                    viewModel:
                                                                        viewModel);
                                                              },
                                                              child: Text(
                                                                "ADD GRADE",
                                                                style: theme
                                                                    .body2Medium
                                                                    .copyWith(
                                                                        color: themedata
                                                                            .accentColor),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height:
                                                                height * .038,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5),
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(colors
                                                                            .accentColor),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              // color: themedata.primaryColorDark,
                                                              onPressed: () {
                                                                showItemGradeSheet(
                                                                  context,
                                                                  pos,
                                                                  viewModel
                                                                      .itemDetailList[
                                                                          pos]
                                                                      .itemName,
                                                                  viewModel:
                                                                      viewModel,
                                                                );
                                                                // showItemDetailSelectionSheet(
                                                                //     context,
                                                                //     pos,
                                                                //     itemId: viewModel
                                                                //         .itemDetailList[
                                                                //             pos]
                                                                //         .itemId,
                                                                //     viewModel:
                                                                //         viewModel);
                                                              },
                                                              child: Text(
                                                                "VIEW GRADE",
                                                                style: theme
                                                                    .bodyMedium
                                                                    .copyWith(
                                                                        color: themedata
                                                                            .primaryColorDark),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                                  )
                                                ])))),
                              );
                            }
                            //viewModel?.itemDetailList?.length ?? 1,
                            ),
                      ),
                    ],
                  )),
              // Visibility(
              //   visible: viewModel.itemDetailList != null ? true : false,
              //   child: Expanded(
              //     flex: 7,
              //     child: viewModel.itemDetailList != null &&
              //             viewModel.itemDetailList.isNotEmpty
              //         ? ListView.builder(
              //             shrinkWrap: true,
              //             itemCount: widget.viewModel?.itemDetailList?.length,
              //             itemBuilder: (context, int index) {
              //               return viewModel?.itemDetailList[index ?? 0]
              //                           .gradeModelData !=
              //                       null
              //                   ? ListView.builder(
              //                       itemCount: viewModel?.itemDetailList[index]
              //                               ?.gradeModelData?.length ??
              //                           1,
              //                       shrinkWrap: true,
              //                       physics: ScrollPhysics(),
              //                       itemBuilder: (context, int listdata) {
              //                         return viewModel.itemDetailList[index]
              //                                     .gradeModelData !=
              //                                 null
              //                             ?
              //                             // getTextWidgets(widget
              //                             //     .viewModel.itemDetailList[index].gradeModelData),
              //                             Card(
              //                                 elevation: 5,
              //                                 child: Dismissible(
              //                                   key: Key(viewModel
              //                                       .itemDetailList[index]
              //                                       .gradeModelData[listdata]
              //                                       .gradeLookupData
              //                                       .name),
              //                                   onDismissed: (direction) {
              //                                     if (direction ==
              //                                         DismissDirection
              //                                             .endToStart) {
              //                                       setState(() {
              //                                         viewModel
              //                                             .itemDetailList[index]
              //                                             .gradeModelData
              //                                             .removeAt(listdata);
              //                                       });
              //                                       showItemDetailSelectionSheet(
              //                                           context, index,
              //                                           viewModel: viewModel,
              //                                           itemId: viewModel
              //                                               .itemDetailList[
              //                                                   index]
              //                                               .itemId);
              //                                     } else {
              //                                       setState(() {
              //                                         viewModel
              //                                             .itemDetailList[index]
              //                                             .gradeModelData
              //                                             .removeAt(listdata);
              //                                       });
              //                                     }
              //                                   },
              //                                   secondaryBackground: Container(
              //                                       decoration: BoxDecoration(
              //                                           color: Colors.green),
              //                                       child: Row(
              //                                           mainAxisAlignment:
              //                                               MainAxisAlignment
              //                                                   .end,
              //                                           children: <Widget>[
              //                                             Padding(
              //                                                 padding: const EdgeInsets
              //                                                         .symmetric(
              //                                                     horizontal:
              //                                                         8),
              //                                                 child: _buildButton(
              //                                                     theme,
              //                                                     icon: Icons
              //                                                         .add_circle_outline_sharp,
              //                                                     title:
              //                                                         "Edit"))
              //                                           ])),
              //                                   background: Container(
              //                                     decoration: BoxDecoration(
              //                                         color: Colors.red),
              //                                     child: _buildButton(theme),
              //                                   ),
              //                                   confirmDismiss: (direction) {
              //                                     String message = direction ==
              //                                             DismissDirection
              //                                                 .startToEnd
              //                                         ? "Do you want to delete this record"
              //                                         : "Do you want to edit this record  ";
              //                                     return appChoiceDialog(
              //                                         message: message,
              //                                         context: context);
              //                                   },
              //                                   child: Container(
              //                                     //  height: 400,
              //                                     color: themedata.primaryColor,
              //                                     padding: EdgeInsets.all(12),
              //                                     child: Column(
              //                                       crossAxisAlignment:
              //                                           CrossAxisAlignment
              //                                               .start,
              //                                       children: [
              //                                         Container(
              //                                           child: Text(viewModel
              //                                               .itemDetailList[
              //                                                   index]
              //                                               .itemName),
              //                                         ),
              //                                         SizedBox(
              //                                           height: 5,
              //                                         ),
              //                                         Container(
              //                                           padding:
              //                                               EdgeInsets.all(8),
              //                                           width: 100,
              //                                           color: themedata
              //                                               .primaryColorDark,
              //                                           child: Text(viewModel
              //                                                   .itemDetailList[
              //                                                       index]
              //                                                   .gradeModelData[
              //                                                       listdata]
              //                                                   ?.gradeLookupData
              //                                                   ?.name ??
              //                                               ""),
              //                                         ),
              //                                         SizedBox(
              //                                           height: 8,
              //                                         ),
              //
              //                                         Row(
              //                                           mainAxisAlignment:
              //                                               MainAxisAlignment
              //                                                   .spaceBetween,
              //                                           children: [
              //                                             Text(
              //                                               "Qty",
              //                                               textAlign:
              //                                                   TextAlign.left,
              //                                             ),
              //                                             Text(
              //                                               viewModel
              //                                                       .itemDetailList[
              //                                                           index]
              //                                                       .gradeModelData[
              //                                                           listdata]
              //                                                       ?.qty
              //                                                       .toString() ??
              //                                                   "",
              //                                               textAlign:
              //                                                   TextAlign.right,
              //                                             ),
              //                                           ],
              //                                         ),
              //                                         SizedBox(
              //                                           height: 8,
              //                                         ),
              //
              //                                         Row(
              //                                           mainAxisAlignment:
              //                                               MainAxisAlignment
              //                                                   .spaceBetween,
              //                                           children: [
              //                                             Text(
              //                                               "Rate",
              //                                               textAlign:
              //                                                   TextAlign.left,
              //                                             ),
              //                                             Text(
              //                                               (BaseNumberFormat(
              //                                                               number:
              //                                                                   (viewModel.itemDetailList[index].gradeModelData[listdata]?.rate))
              //                                                           .formatCurrency())
              //                                                       .toString() ??
              //                                                   "",
              //                                               textAlign:
              //                                                   TextAlign.right,
              //                                             ),
              //                                           ],
              //                                         ),
              //                                         SizedBox(
              //                                           height: 8,
              //                                         ),
              //
              //                                         Row(
              //                                           mainAxisAlignment:
              //                                               MainAxisAlignment
              //                                                   .spaceBetween,
              //                                           children: [
              //                                             Text(
              //                                               "Total",
              //                                               textAlign:
              //                                                   TextAlign.left,
              //                                             ),
              //                                             Text(
              //                                               (BaseNumberFormat(
              //                                                           number: ((viewModel.itemDetailList[index].gradeModelData[listdata]?.qty ??
              //                                                                   0) *
              //                                                               ((viewModel.itemDetailList[index].gradeModelData[listdata]?.rate ?? 0).toInt() ??
              //                                                                   0)))
              //                                                       .formatCurrency())
              //                                                   .toString(),
              //                                               textAlign:
              //                                                   TextAlign.right,
              //                                             ),
              //                                           ],
              //                                         ),
              //                                         // Text(widget.viewModel.itemDetailList[index].gradeModelData[index].qty.toString())
              //                                       ],
              //                                     ),
              //                                   ),
              //                                 ),
              //                               )
              //                             : Text("");
              //                       })
              //                   : Container(
              //                       color: themedata.scaffoldBackgroundColor,
              //                     );
              //             })
              //         : Container(
              //             color: themedata.scaffoldBackgroundColor,
              //           ),
              //   ),
              // )
            ],
          ),

          // : EmptyResultView(),
        );
      },
    );
  }

  Widget _buildButton(BaseTheme theme,
      {bool reverse = false, IconData icon, String title}) {
    return Row(
      textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
      children: <Widget>[
        Icon(icon ?? Icons.delete_sweep, color: Colors.white),
        SizedBox(width: 15),
        Text(
          title ?? "Delete",
          style: theme.title.copyWith(color: Colors.white),
        )
      ],
    );
  }

  Widget getTextWidgets(List<GradeModel> listData) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    return listData != null
        ? ListView(
            shrinkWrap: true,
            children: listData
                .map((item) => new Container(
                      color: themeData.primaryColor,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            width: 100,
                            color: themeData.primaryColorDark,
                            child: Text(item?.gradeLookupData?.name ?? ""),
                          ),
                          SizedBox(
                            height: 8,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Qty",
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                item?.qty.toString() ?? "",
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rate",
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                item?.rate.toString() ?? "",
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                ((item?.qty ?? 0) * (item?.rate ?? 0))
                                    .toString(),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          // Text(widget.viewModel.itemDetailList[index].gradeModelData[index].qty.toString())
                        ],
                      ),
                    ))
                .toList(),
          )
        : Container(
            color: themeData.primaryColor,
          );
  }

  Widget buildGrade(List<GradeModel> list) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData style = ThemeProvider.of(context);
    return ListView.builder(itemBuilder: (context, int index) {
      return list != null
          ? Container(
              color: style.primaryColor,
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: Text(
                          widget.viewModel.itemDetailList[index].itemName)),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 100,
                    color: style.primaryColorDark,
                    child: Text(list[index].gradeLookupData?.name),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Qty",
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        list[index]?.qty.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rate",
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        list[index]?.rate.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        ((list[index]?.qty) * (list[index]?.rate)).toString(),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  // Text(widget.viewModel.itemDetailList[index].gradeModelData[index].qty.toString())
                ],
              ),
            )
          : Container(
              color: theme.colors.secondaryColor,
            );
    });
  }
}

Widget _buildDeleteButton(BaseTheme theme, {bool reverse = false}) {
  return Row(
    textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
    children: <Widget>[
      Icon(Icons.delete_sweep, color: Colors.white),
      SizedBox(width: 15),
      Text(
        "Delete",
        style: theme.title.copyWith(color: Colors.white),
      )
    ],
  );
}

Row buildRow({String title, String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, textAlign: TextAlign.left),
      Text(
        value,
        textAlign: TextAlign.right,
      )
    ],
  );
}

void showItemDetailSelectionSheet(BuildContext context, int index,
    {GradingCostingViewModel viewModel, GradeModel selected, int itemId}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_context) => ItemDetailView<GradeModel>(
        index: index,
        itemId: itemId,
        onViewDetails: (selected) {},
        viewModel: viewModel,
        selected: selected),
  );
}

void showItemGradeSheet(
  BuildContext context,
  int index,
  String itemName, {
  GradingCostingViewModel viewModel,
}) {
  viewModel.itemDetailList[index].gradeModelData != null
      ? showModalBottomSheet<void>(
          context: context,
          isScrollControlled: false,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          builder: (_context) => GradeDetail(
            itemName: itemName,
            viewModel: viewModel,
          ),
        )
      : showModalBottomSheet<void>(
          context: context,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          builder: (BuildContext context) {
            ThemeData themedata = ThemeProvider.of(context);
            BaseTheme theme = BaseTheme.of(context);
            return Container(
              color: themedata.primaryColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('No grade is added'),
                  ],
                ),
              ),
            );
          },
        );
}

class GradeDetail extends StatefulWidget {
  final GradingCostingViewModel viewModel;
  final String itemName;

  const GradeDetail({Key key, this.viewModel, this.itemName}) : super(key: key);

  @override
  _GradeDetailState createState() => _GradeDetailState();
}

class _GradeDetailState extends State<GradeDetail> {
  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);
    return widget.viewModel.itemDetailList != null
        ? widget.viewModel.itemDetailList != null &&
                widget.viewModel.itemDetailList.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                    color: themedata.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: themedata.primaryColorDark,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Row(children: [
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text("Grade  Details",
                                      style: theme.appBarTitle))),
                          SizedBox(width: 20),
                          IconButton(
                              icon: Icon(
                                Icons.close,
                                color: themedata.secondaryHeaderColor,
                              ),
                              onPressed: () => Navigator.pop(context))
                        ])),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.viewModel?.itemDetailList?.length,
                          itemBuilder: (context, int index) {
                            return widget.viewModel?.itemDetailList[index ?? 0]
                                        .gradeModelData !=
                                    null
                                ? ListView.builder(
                                    itemCount: widget
                                            .viewModel
                                            ?.itemDetailList[index]
                                            ?.gradeModelData
                                            ?.length ??
                                        1,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, int listdata) {
                                      return widget
                                                  .viewModel
                                                  .itemDetailList[index]
                                                  .gradeModelData !=
                                              null
                                          ? Visibility(
                                              visible: widget.itemName ==
                                                      widget
                                                          .viewModel
                                                          .itemDetailList[index]
                                                          .itemName
                                                  ? true
                                                  : false,
                                              child: Card(
                                                elevation: 5,
                                                child: Dismissible(
                                                  key: Key(listdata.toString()),
                                                  onDismissed: (direction) {
                                                    if (direction ==
                                                        DismissDirection
                                                            .endToStart) {
                                                      setState(() {
                                                        widget
                                                            .viewModel
                                                            .itemDetailList[
                                                                index]
                                                            .gradeModelData
                                                            .removeAt(listdata);
                                                      });
                                                      showItemDetailSelectionSheet(
                                                          context, index,
                                                          viewModel:
                                                              widget.viewModel,
                                                          itemId: widget
                                                              .viewModel
                                                              .itemDetailList[
                                                                  index]
                                                              .itemId);
                                                    } else {
                                                      setState(() {
                                                        widget
                                                            .viewModel
                                                            .itemDetailList[
                                                                index]
                                                            .gradeModelData
                                                            .removeAt(listdata);
                                                      });
                                                    }
                                                  },
                                                  secondaryBackground:
                                                      Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .green),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8),
                                                                    child: _buildButton(
                                                                        theme,
                                                                        icon: Icons
                                                                            .add_circle_outline_sharp,
                                                                        title:
                                                                            "Edit"))
                                                              ])),
                                                  background: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.red),
                                                    child: _buildButton(theme),
                                                  ),
                                                  confirmDismiss: (direction) {
                                                    String message = direction ==
                                                            DismissDirection
                                                                .startToEnd
                                                        ? "Do you want to delete this record"
                                                        : "Do you want to edit this record  ";
                                                    return appChoiceDialog(
                                                        message: message,
                                                        context: context);
                                                  },
                                                  child: Container(
                                                    //  height: 400,
                                                    color:
                                                        themedata.primaryColor,
                                                    padding: EdgeInsets.all(12),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(widget
                                                              .viewModel
                                                              .itemDetailList[
                                                                  index]
                                                              .itemName),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          width: 100,
                                                          color: themedata
                                                              .primaryColorDark,
                                                          child: Text(widget
                                                                  .viewModel
                                                                  .itemDetailList[
                                                                      index]
                                                                  .gradeModelData[
                                                                      listdata]
                                                                  ?.gradeLookupData
                                                                  ?.name ??
                                                              ""),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),

                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Qty",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Text(
                                                              BaseNumberFormat(
                                                                          number: widget
                                                                              .viewModel
                                                                              .itemDetailList[index]
                                                                              .gradeModelData[listdata]
                                                                              ?.qty)
                                                                      .formatCurrency()
                                                                      .toString() ??
                                                                  "",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),

                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Rate",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Text(
                                                              BaseNumberFormat(
                                                                          number: widget
                                                                              .viewModel
                                                                              .itemDetailList[index]
                                                                              .gradeModelData[listdata]
                                                                              ?.rate)
                                                                      .formatRate()
                                                                      .toString() ??
                                                                  "",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),

                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Total",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            Text(
                                                              BaseNumberFormat(
                                                                      number: ((widget.viewModel.itemDetailList[index].gradeModelData[listdata]?.qty ??
                                                                              0) *
                                                                          (widget.viewModel.itemDetailList[index].gradeModelData[listdata]?.rate ??
                                                                              0)))
                                                                  .formatTotal()
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ],
                                                        ),
                                                        // Text(widget.viewModel.itemDetailList[index].gradeModelData[index].qty.toString())
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Text("No Data to show");
                                    })
                                : Container(
                                    color: themedata.scaffoldBackgroundColor,
                                  );
                          }),
                    ),
                  ],
                ),
              )
            : Container(
                color: themedata.scaffoldBackgroundColor,
              )
        : Scaffold(body: Text("No data to show"));
  }

  Widget _buildButton(BaseTheme theme,
      {bool reverse = false, IconData icon, String title}) {
    return Row(
      textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
      children: <Widget>[
        Icon(icon ?? Icons.delete_sweep, color: Colors.white),
        SizedBox(width: 15),
        Text(
          title ?? "Delete",
          style: theme.title.copyWith(color: Colors.white),
        )
      ],
    );
  }
}

class ListItem<T extends GradeModel> extends StatelessWidget {
  final GradeModel gradeModel;
  final ValueSetter<T> onClick;
  final GradingCostingViewModel viewModel;

  const ListItem({Key key, this.gradeModel, this.onClick, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themedata = ThemeProvider.of(context);
    return Column(
      children: [
        Container(
          color: themedata.primaryColor,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
                color: themedata.primaryColor,
                border: Border(
                    bottom: BaseBorderSide(color: theme.colors.primaryColor))),
            child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 12),
              // onPressed: () => onClick(gradeModel),
              child: IntrinsicHeight(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(gradeModel.gradeLookupData.name,
                            style: theme.subhead1
                                .copyWith(fontWeight: FontWeight.w500)),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0, left: 8.0),
                          child: Text(gradeModel.qty.toString(),
                              style: theme.body),
                        ),
                      ],
                    )),
                    SizedBox(width: 22),
                    Column(
                      children: <Widget>[
                        Text(
                          gradeModel.rate.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0, left: 8.0),
                          child: Text(gradeModel.total.toString(),
                              style: theme.body),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        //  SizedBox(height: 10),
      ],
    );
  }
}

showAlert(BuildContext context, GradingCostingViewModel viewModel) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final _colors = BaseColors.of(context);
      ThemeData themeData = ThemeProvider.of(context);
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;

      return AlertDialog(
          backgroundColor: themeData.scaffoldBackgroundColor,
          title: Center(child: Text("Alert")),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          content: Container(
              height: height * .25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(
                            Icons.announcement,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                            child: Text(
                              "You are going to save the grade rate of item is zero , Do you really want to continue ?",
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: height * .07,
                        width: width * .3,
                        child: BaseClearButton(
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: themeData.primaryColorDark,
                          color: _colors.white.withOpacity(.70),
                          child: const Text("OK"),
                          onPressed: () {
                            viewModel.saveGradingCosting();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        height: height * .07,
                        width: width * .3,
                        child: BaseClearButton(
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: _colors.white,
                          color: themeData.primaryColorDark,
                          child: const Text("CANCEL"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  )
                ],
              )));
    },
  );
}

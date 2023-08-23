import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/grading_and_costing/grading_and_costing_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/grading_and_costing/grading_and_costing.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_costing_view_list_model.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/helper/edit_grade.dart';
import 'package:redstars/utility.dart';

import 'model/grading_model.dart';

class GradingCostingDetailView extends StatefulWidget {
  final GardingViewList processedData;
  final GradingCostingViewModel viewModel;

  const GradingCostingDetailView({Key key, this.viewModel, this.processedData})
      : super(key: key);
  @override
  _GradingCostingDetailState createState() => _GradingCostingDetailState();
}

class _GradingCostingDetailState extends State<GradingCostingDetailView> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    int gradeIndex;
    // return Container(
    //   child: Text("Hello"),
    // );
    void funData(int index) {
      getTextWidgets(widget.viewModel.itemDetailList[index].gradeModelData);
    }

    return BaseView<AppState, GradingCostingViewModel>(
      init: (store, con) {
        final state = store.state.gradingCostingState;
        store.dispatch(fetchInitialData(filterModel: state.currentFilters));
        store.dispatch(fetchRefreshData(filterModel: state.currentFilters));
        // store.dispatch(fetchGradingListData(widget.processedData.ginno));
        // store.dispatch(fetchCurrencyExchangeList());
      },
      // onDispose: (store) => store.dispatch(OnClearAction()),
      converter: (store) => GradingCostingViewModel.fromStore(store),
      onDidChange: (viewModel, context) {
        if (viewModel.saveData)
          showSuccessDialog(context, "Saved Successfully", "Success", () {
            viewModel.onClear();
            Navigator.pop(context);
            // Navigator.pop(context);
            viewModel.onViewRefresh(viewModel.fromDate, viewModel.toDate);
          });
      },
      builder: (context, viewModel) {
        //  gradeIndex = widget.viewModel.itemDetailList.length;
        List<GradeModel> list = [];
        // var length;
        BaseColors colors = BaseColors.of(context);
        BaseTheme theme = BaseTheme.of(context);
        double height = MediaQuery.of(context).size.height;
        // viewModel.itemDetailList.clear();
        // viewModel.gradingList.forEach((element) {
        //   viewModel.itemDetailList.addAll(element.itemDtl);
        //   print("987====${widget.viewModel?.itemDetailList?.length}");
        //   return length;
        // });

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
              // Visibility(
              //   visible: widget.viewModel.gradingViewListModel?.gradingViewList
              //               ?.first?.status !=
              //           "Approved" ||
              //       widget.processedData.status == 'Pending',
              //   child: IconButton(
              //       icon: Icon(Icons.check),
              //       onPressed: () {
              //         for (int i = 0;
              //             i <
              //                 viewModel.gradingCostingViewDetailModel
              //                     .gradingDetailViewList.length;
              //             i++) {
              //           if (!(viewModel
              //                   .gradingCostingViewDetailModel
              //                   .gradingDetailViewList
              //                   .first
              //                   .gradingDtlJson[i]
              //                   .rate >
              //               0)) {
              //             showEditAlert(context, viewModel);
              //           } else {
              //             viewModel.editSaveGradingCost();
              //           }
              //         }
              //       }),
              // )
            ],
          ),
          body: Column(
            children: [
              // Text(viewModel.gradingCostingViewDetailModel.gradingDetailViewList.last.),
              Flexible(
                  flex: 2,
                  child: viewModel.gradingCostingViewDetailModel
                              ?.gradingDetailViewList !=
                          null
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.gradingCostingViewDetailModel
                              .gradingDetailViewList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 2),
                              child: Card(
                                elevation: 0,
                                color: themedata.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 18,
                                      ),
                                      buildRow(
                                          title: "Purchase Order No.",
                                          value: viewModel
                                                  .gradingCostingViewDetailModel
                                                  .gradingDetailViewList[index]
                                                  ?.pono ??
                                              ""),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      buildRow(
                                          title: "Purchase Order Date:",
                                          value: viewModel
                                                  .gradingCostingViewDetailModel
                                                  .gradingDetailViewList[index]
                                                  ?.podate ??
                                              ""),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      buildRow(
                                          title: "Supplier:",
                                          value: viewModel
                                                  .gradingCostingViewDetailModel
                                                  .gradingDetailViewList[index]
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
                                                    .gradingCostingViewDetailModel
                                                    .gradingDetailViewList[
                                                        index]
                                                    ?.address1 ??
                                                "" +
                                                    "\n" +
                                                    viewModel
                                                        .gradingCostingViewDetailModel
                                                        .gradingDetailViewList[
                                                            index]
                                                        ?.address2 ??
                                                "" +
                                                    "\n" +
                                                    viewModel
                                                        .gradingCostingViewDetailModel
                                                        .gradingDetailViewList[
                                                            index]
                                                        ?.address3 ??
                                                "",
                                            textAlign: TextAlign.right,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: Text("No data to show"),
                        )),
              Row(
                children: [
                  SizedBox(width: 25),
                  Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.all(2),
                    //EdgeInsets.all(5),
                    // decoration: BoxDecoration(
                    //     color: themedata.primaryColor,
                    //     borderRadius:
                    //     BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        AppVectors.itemBox,
                      ),
                    ),
                  ),
                  Text("Item Details: ")
                ],
              ),
              SizedBox(height: 5),
              Expanded(
                flex: 4,
                child: viewModel?.gradingCostingViewDetailModel != null
                    ? ListView.builder(
                        // scrollDirection: Axis.horizontal,
                        itemCount: viewModel
                            .gradingCostingViewDetailModel
                            ?.gradingDetailViewList
                            ?.first
                            ?.sourceItemDtl
                            ?.length,
                        // shrinkWrap: true,
                        itemBuilder: (context, int realIndex) {
                          return Column(
                            children: [
                              Container(
                                  height: height * .13,
                                  margin: EdgeInsets.only(bottom: 1),
                                  child: Column(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: themedata.primaryColor,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: themedata
                                                        .primaryColor))),
                                        child: Column(children: [
                                          Row(children: [
                                            // Container(
                                            //   height: 78.2,
                                            //   width: 70,
                                            //   margin: EdgeInsets.all(2),
                                            //   //EdgeInsets.all(5),
                                            //   decoration: BoxDecoration(
                                            //       color: themedata.primaryColor,
                                            //       borderRadius:
                                            //       BorderRadius.circular(10)),
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.all(12.0),
                                            //     child: SvgPicture.asset(
                                            //       AppVectors.itemBox,
                                            //     ),
                                            //   ),
                                            // ),
                                            SizedBox(width: 10),
                                            Expanded(
                                                flex: 20,
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 6),
                                                      Text(
                                                        viewModel
                                                            .gradingCostingViewDetailModel
                                                            ?.gradingDetailViewList
                                                            .first
                                                            .sourceItemDtl[
                                                                realIndex]
                                                            .description,
                                                        style:
                                                            theme.subhead1Bold,
                                                      ),
                                                      Text((viewModel
                                                              .gradingCostingViewDetailModel
                                                              .gradingDetailViewList
                                                              .first
                                                              .sourceItemDtl[
                                                                  realIndex]
                                                              .code)
                                                          .toString()),
                                                      SizedBox(height: 16),
                                                      Row(
                                                        children: [
                                                          Text("Qty:"),
                                                          Text(
                                                            BaseNumberFormat(
                                                                    number: (viewModel
                                                                        .gradingCostingViewDetailModel
                                                                        .gradingDetailViewList
                                                                        .first
                                                                        .sourceItemDtl[
                                                                            realIndex]
                                                                        .qty))
                                                                .formatCurrency()
                                                                .toString(),
                                                            style: theme
                                                                .subhead1Bold,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                    ])),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          colors.secondaryDark),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {});
                                                  //TODO: View Grade
                                                  showItemDetailGradeSelectionSheet(
                                                      context,
                                                      widget
                                                          .processedData.status,
                                                      viewModel: viewModel,
                                                      realIndex: realIndex);
                                                },
                                                child: Text(
                                                  "View Grade",
                                                  style: theme.subhead1Bold
                                                      .copyWith(
                                                          color: themedata
                                                              .accentColor),
                                                ),
                                              ),
                                            ),
                                          ])
                                        ]))
                                  ])),
                            ],
                          );
                        }
                        //viewModel?.itemDetailList?.length ?? 1,
                        )
                    : Text("no data"),
              ),
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
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
                        ((list[index].qty) * (list[index]?.rate)).toString(),
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
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, textAlign: TextAlign.left),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
        ),
      )
    ],
  );
}

void showItemDetailSelectionSheet(
  BuildContext context,
  int index,
  int itemId, {
  GradingCostingViewModel viewModel,
  GradeModel selected,
  int listdata,
  int editId = 0,
}) {
  print("$editId 1");
  BaseNavigate(
      context,
      EditGradeView<GradeModel>(
        index: index,
        listdata: listdata,
        itemId: itemId,
        onViewDetails: (selected) {},
        viewModel: viewModel,
        selected: selected,
      ));
}

void showItemDetailGradeSelectionSheet(BuildContext context, String status,
    {GradingCostingViewModel viewModel, GradeModel selected, int realIndex}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    builder: (_context) => GradeItemList(
      realIndex: realIndex,
      selectedItemStatus: status,
      viewModel: viewModel,
    ),
  );
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
                        ),
                      ],
                    ),
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

class GradeItemList extends StatefulWidget {
  final GradingCostingViewModel viewModel;
  final String selectedItemStatus;
  final int realIndex;
  GradeItemList(
      {Key key, this.viewModel, this.selectedItemStatus, this.realIndex})
      : super(key: key);

  @override
  _GradeItemListState createState() => _GradeItemListState();
}

class _GradeItemListState extends State<GradeItemList> {
  @override
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData themedata = ThemeProvider.of(context);
    if (widget.viewModel.gradingCostingViewDetailModel.gradingDetailViewList !=
            null &&
        widget.viewModel.gradingCostingViewDetailModel.gradingDetailViewList
            .isNotEmpty)
      return Container(
          decoration: BoxDecoration(
              color: themedata.primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
              Flexible(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.viewModel?.gradingCostingViewDetailModel
                          ?.gradingDetailViewList?.length,
                      itemBuilder: (context, int index) {
                        return widget
                                    .viewModel
                                    ?.gradingCostingViewDetailModel
                                    ?.gradingDetailViewList[index ?? 0]
                                    .gradingDtlJson !=
                                null
                            ? ListView.builder(
                                itemCount: widget
                                        .viewModel
                                        ?.gradingCostingViewDetailModel
                                        ?.gradingDetailViewList[index]
                                        ?.gradingDtlJson
                                        ?.length ??
                                    1,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, int listdata) {
                                  return widget
                                              .viewModel
                                              .gradingCostingViewDetailModel
                                              .gradingDetailViewList[index]
                                              .gradingDtlJson !=
                                          null
                                      ?
                                      // getTextWidgets(widget
                                      //     .viewModel.itemDetailList[index].gradeModelData),
                                      Visibility(
                                          visible: widget
                                                  .viewModel
                                                  .gradingCostingViewDetailModel
                                                  .gradingDetailViewList
                                                  .first
                                                  .sourceItemDtl[
                                                      widget.realIndex]
                                                  .itemid ==
                                              widget
                                                  .viewModel
                                                  .gradingCostingViewDetailModel
                                                  .gradingDetailViewList
                                                  .first
                                                  .gradingDtlJson[listdata]
                                                  .itemid,
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
                                                        .gradingCostingViewDetailModel
                                                        .gradingDetailViewList
                                                        .first
                                                        .gradingDtlJson
                                                        .remove(listdata);
                                                  });
                                                }
                                              },
                                              background: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                  ),
                                                  child: _buildButton(theme)),
                                              confirmDismiss: (direction) {
                                                String message = direction ==
                                                        DismissDirection
                                                            .startToEnd
                                                    ? "Do you want to delete this record"
                                                    : "Do you want to delete this record  ";
                                                return appChoiceDialog(
                                                    message: message,
                                                    context: context);
                                              },
                                              child: Container(
                                                //  height: 400,
                                                color: themedata.primaryColor,
                                                padding: EdgeInsets.all(12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                              widget
                                                                  .viewModel
                                                                  .gradingCostingViewDetailModel
                                                                  ?.gradingDetailViewList[
                                                                      index]
                                                                  .gradingDtlJson[
                                                                      listdata]
                                                                  .itemname,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left),
                                                        ),
                                                        // Visibility(
                                                        //   visible: widget
                                                        //           .selectedItemStatus !=
                                                        //       "Approved",
                                                        //   child: IconButton(
                                                        //       icon: Icon(
                                                        //           Icons.edit),
                                                        //       onPressed: () {
                                                        //         showItemDetailSelectionSheet(
                                                        //           context,
                                                        //           index,
                                                        //           widget
                                                        //               .viewModel
                                                        //               .gradingCostingViewDetailModel
                                                        //               ?.gradingDetailViewList[
                                                        //                   index]
                                                        //               .gradingDtlJson[
                                                        //                   listdata]
                                                        //               .itemid,
                                                        //           listdata:
                                                        //               listdata,
                                                        //           viewModel: widget
                                                        //               .viewModel,
                                                        //         );
                                                        //       },
                                                        //       alignment: Alignment
                                                        //           .centerRight),
                                                        // ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      width: width * 0.2,
                                                      color: themedata
                                                          .primaryColorDark,
                                                      child: Text(widget
                                                          .viewModel
                                                          .gradingCostingViewDetailModel
                                                          ?.gradingDetailViewList[
                                                              index]
                                                          .gradingDtlJson[
                                                              listdata]
                                                          .gradename),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Qty",
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        Text(
                                                          BaseNumberFormat(
                                                                      number: widget
                                                                          .viewModel
                                                                          .gradingCostingViewDetailModel
                                                                          ?.gradingDetailViewList[
                                                                              index]
                                                                          .gradingDtlJson[
                                                                              listdata]
                                                                          .qty)
                                                                  .formatCurrency()
                                                                  .toString() ??
                                                              "",
                                                          textAlign:
                                                              TextAlign.right,
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
                                                              TextAlign.left,
                                                        ),
                                                        Text(
                                                          (BaseNumberFormat(
                                                                      number: widget
                                                                          ?.viewModel
                                                                          ?.gradingCostingViewDetailModel
                                                                          ?.gradingDetailViewList[
                                                                              index]
                                                                          .gradingDtlJson[
                                                                              listdata]
                                                                          .rate)
                                                                  .formatRate()
                                                                  .toString() ??
                                                              widget
                                                                  .viewModel
                                                                  ?.gradeModel
                                                                  ?.rate),
                                                          textAlign:
                                                              TextAlign.right,
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
                                                              TextAlign.left,
                                                        ),
                                                        Text(
                                                          ((BaseNumberFormat(
                                                                  number: (widget
                                                                              .viewModel
                                                                              .gradingCostingViewDetailModel
                                                                              ?.gradingDetailViewList[
                                                                                  index]
                                                                              .gradingDtlJson[
                                                                                  listdata]
                                                                              .qty ??
                                                                          widget
                                                                              .viewModel
                                                                              ?.qty ??
                                                                          0) *
                                                                      (widget
                                                                              .viewModel
                                                                              .gradingCostingViewDetailModel
                                                                              ?.gradingDetailViewList[index]
                                                                              .gradingDtlJson[listdata]
                                                                              .rate ??
                                                                          widget.viewModel?.rate ??
                                                                          0)))
                                                              .formatTotal()
                                                              .toString()),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ],
                                                    ), // Text(widget.viewModel.itemDetailList[index].gradeModelData[index].qty.toString())
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text("");
                                })
                            : Container(
                                color: themedata.scaffoldBackgroundColor,
                              );
                      })),
            ],
          ));
  }
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

showEditAlert(BuildContext context, GradingCostingViewModel viewModel) {
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
                            viewModel.editSaveGradingCost();
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

// class GradeItemList extends StatelessWidget {
//   final GradingCostingViewModel viewModel;
//   const GradeItemList({Key key, this.viewModel}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     BaseTheme theme = BaseTheme.of(context);
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     ThemeData themedata = ThemeProvider.of(context);
//     if( viewModel.gradingCostingViewDetailModel.
//     gradingDetailViewList != null &&
//         viewModel.gradingCostingViewDetailModel.
//         gradingDetailViewList.isNotEmpty)
//     return Container(
//         color: themedata.primaryColorDark,
//         child: Column(
//           children: [
//             Flexible(
//
//               child:
//                   ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: viewModel?.
//                   gradingCostingViewDetailModel?.
//                   gradingDetailViewList?.length,
//                   itemBuilder: (context, int index) {
//                     return viewModel?.
//                     gradingCostingViewDetailModel?.
//                     gradingDetailViewList[index ?? 0]
//                         .gradingDtlJson != null
//                         ? ListView.builder(
//                         itemCount: viewModel?.
//                         gradingCostingViewDetailModel?.
//                         gradingDetailViewList[index]
//                             ?.gradingDtlJson?.length ?? 1,
//                         shrinkWrap: true,
//                         physics: ScrollPhysics(),
//                         itemBuilder: (context, int listdata) {
//                           return viewModel.
//                           gradingCostingViewDetailModel.
//                           gradingDetailViewList[index]
//                               .gradingDtlJson != null ?
//                           // getTextWidgets(widget
//                           //     .viewModel.itemDetailList[index].gradeModelData),
//                           Card(
//                             elevation: 5,
//                               child: Container(
//                                 //  height: 400,
//                                 color: themedata.primaryColor,
//                                 padding: EdgeInsets.all(12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           child: Text(
//                                               viewModel
//                                               .gradingCostingViewDetailModel?.
//                                               gradingDetailViewList[index].
//                                               gradingDtlJson[listdata].itemname,
//                                             textAlign: TextAlign.left
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: width * 0.4,
//                                         ),
//                                         IconButton(icon: Icon(Icons.edit),
//                                             onPressed: () {
//                                              return
//                                                showItemDetailSelectionSheet(
//                                                   context, index,
//                                                   viewModel: viewModel,);
//                                             },
//                                         alignment: Alignment.centerRight,)
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.all(8),
//                                       width: 100,
//                                       color: themedata
//                                           .primaryColorDark,
//                                       child: Text(
//                                           viewModel.gradingCostingViewDetailModel?.
//                                           gradingDetailViewList[index].
//                                           gradingDtlJson[listdata].gradename
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           "Qty",
//                                           textAlign:
//                                           TextAlign.left,
//                                         ),
//                                         Text(viewModel.gradingCostingViewDetailModel?.
//                                         gradingDetailViewList[index].
//                                         gradingDtlJson[listdata].qty
//                                               .toString() ?? "",
//                                       textAlign: TextAlign.right,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           "Rate",
//                                           textAlign:
//                                           TextAlign.left,
//                                         ),
//                                         Text(
//                                           (viewModel?.gradingCostingViewDetailModel?.
//                                           gradingDetailViewList[index].
//                                           gradingDtlJson[listdata].rate).toString() ??
//                                               viewModel?.gradeModel?.rate,
//                                           textAlign:
//                                           TextAlign.right,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment
//                                           .spaceBetween,
//                                       children: [
//                                         Text(
//                                           "Total",
//                                           textAlign:
//                                           TextAlign.left,
//                                         ),
//                                         Text(
//                                           ((
//                                               viewModel.gradingCostingViewDetailModel?.
//                                               gradingDetailViewList[index].
//                                               gradingDtlJson[listdata].qty ?? 0
//                                           ) *
//                                               (
//                                                   viewModel.gradingCostingViewDetailModel?.
//                                                   gradingDetailViewList[index].
//                                                   gradingDtlJson[listdata].rate ?? 0
//                                               ))
//                                               .toString(),
//                                           textAlign:
//                                           TextAlign.right,
//                                         ),
//                                       ],
//                                     ),// Text(widget.viewModel.itemDetailList[index].gradeModelData[index].qty.toString())
//                                   ],
//                                 ),
//                               ),
//                           )
//                               : Text("");
//                         })
//                         : Container(
//                       color: themedata.scaffoldBackgroundColor,
//                     );
//                   })
//
//             ),
//           ],
//         )
//     );
//   }
// }

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/back_dated_entry_permission/back_dated_entry_permission_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/back_dated_entry_permission/back_dated_entry_permission_viewmodel.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_date_view_model.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';

import 'edit_option_dialog.dart';

class BackDateDetailViewPage extends StatefulWidget {
  final BackDateViewDetails order;
  const BackDateDetailViewPage({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  _BackDateDetailViewPageState createState() => _BackDateDetailViewPageState();
}

class _BackDateDetailViewPageState extends State<BackDateDetailViewPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData themeData = ThemeProvider.of(context);
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    // print(currentDate);
    String tempDateYear = widget.order.periodfrom.substring(6, 10);
    String tempDateMonth = widget.order.periodfrom.substring(3, 5);
    String tempDateDay = widget.order.periodfrom.substring(0, 2);
    String tempDateYearto = widget.order.periodto.substring(6, 10);
    String tempDateMonthto = widget.order.periodto.substring(3, 5);
    String tempDateDayto = widget.order.periodto.substring(0, 2);
    String tempDateYearV = widget.order.validupto.substring(6, 10);
    String tempDateMonthtoV = widget.order.validupto.substring(3, 5);
    String tempDateDaytoV = widget.order.validupto.substring(0, 2);
    String tempDateto =
        "$tempDateYearto-$tempDateMonthto-$tempDateDayto 00:00:00.00000";
    String tempDateV =
        "$tempDateYearV-$tempDateMonthtoV-$tempDateDaytoV 00:00:00.00000";
    String tempDate =
        "$tempDateYear-$tempDateMonth-$tempDateDay 00:00:00.00000";
    DateTime tempPeriodF = DateTime.parse(tempDate);
    DateTime tempPeriodT = DateTime.parse(tempDateto);
    DateTime tempPeriodV = DateTime.parse(tempDateV);
    // print(tempPeriodF);
    BaseTheme theme = BaseTheme.of(context);
    // String periodFrom = DateFormat.yMMMMd().format(tempPeriodF);
    return BaseView<AppState, BackDatedEntryViewModel>(
        init: (store, context) {
          store.dispatch(fetchBackDetailView(
            dtl: widget.order,
          ));
          store.dispatch(ChangePeriodFrom(tempPeriodF));
          store.dispatch(ChangePeriodTo(tempPeriodT));
          store.dispatch(ChangeValidUpto(tempPeriodV));
        },
        converter: (store) => BackDatedEntryViewModel.fromStore(store),
        builder: (context, viewModel) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: themeData.primaryColor,
                size: 34,
              ),
              onPressed: () {
                showDialog(
                  viewModel: viewModel,
                );
              },
            ),
            appBar: BaseAppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      return appShowChildDialog(
                          context: context,
                          child: showAlertEditSave(context, viewModel,
                              tempPeriodF, tempPeriodT, tempPeriodV));
                    },
                    icon: Icon(Icons.check))
              ],
              title:
                  Text(widget?.order?.transno ?? "Back Date Entry Permission"),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: themeData.primaryColor,
                    child: Column(
                      children: [
                        Container(
                            width: width * 1000,
                            decoration: BoxDecoration(
                              color: themeData.primaryColorDark,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Sanctioned Back Dated Entry Period",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width / 3,
                                child: AbsorbPointer(
                                  absorbing: false,
                                  child: BaseDatePicker(
                                    displayTitle: "Period From :",
                                    isVector: true,
                                    icon: Icons.date_range,
                                    initialValue: tempPeriodF,
                                    onChanged: (val) {
                                      tempPeriodF = val;
                                      viewModel?.onChangePeriodFrom(val);
                                    },
                                    onSaved: (val) {},
                                    disableFutureDate: true,
                                  ),
                                ),
                              ),
                              Container(
                                width: width / 3,
                                child: AbsorbPointer(
                                  absorbing: false,
                                  child: BaseDatePicker(
                                    displayTitle: "Period To :",
                                    isVector: true,
                                    icon: Icons.date_range,
                                    initialValue: tempPeriodT,
                                    onChanged: (val) {
                                      tempPeriodT = val;
                                      viewModel?.onChangePeriodTo(val);
                                    },
                                    onSaved: (val) {},
                                    disableFutureDate: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: width / 3,
                                child: AbsorbPointer(
                                  absorbing: false,
                                  child: BaseDatePicker(
                                    displayTitle: "Valid Upto :",
                                    isVector: true,
                                    icon: Icons.date_range,
                                    initialValue: tempPeriodV,
                                    onChanged: (val) {
                                      tempPeriodV = val;
                                      viewModel.onChangePeriodValidUpto(val);
                                    },
                                    onSaved: (val) {},
                                    disablePreviousDates: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  "Sanctioned Options :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: viewModel?.dtlModel?.viewList?.length ?? 0,
                      itemBuilder: (context, int index) {
                        return Dismissible(
                          onDismissed: (dir) {
                            if (dir == DismissDirection.endToStart) {
                              viewModel.dtlModel.viewList
                                  .remove(viewModel.dtlModel.viewList[index]);
                            }
                            if (dir == DismissDirection.startToEnd) {
                              viewModel.dtlModel.viewList
                                  .remove(viewModel.dtlModel.viewList[index]);
                            }
                          },
                          background: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                              ),
                              child: _buildButton(theme)),
                          confirmDismiss: (direction) {
                            String message =
                                direction == DismissDirection.startToEnd
                                    ? "Do you want to delete this record"
                                    : "Do you want to delete this record";
                            return appChoiceDialog(
                                message: message, context: context);
                          },
                          key: Key(index.toString()),
                          child: Center(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: themeData.primaryColor,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text("Option :"),
                                              Text(
                                                viewModel
                                                        ?.dtlModel
                                                        ?.viewList[index]
                                                        ?.optionname ??
                                                    "- -",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text("Branch :"),
                                              Text(
                                                viewModel
                                                        ?.dtlModel
                                                        ?.viewList[index]
                                                        ?.branchname ??
                                                    "- -",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3.0, right: 12.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2.0, right: 8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          2.0,
                                          0.0,
                                          8.0,
                                          0.0,
                                        ),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent,
                                          ),
                                          child: ListTileTheme(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            contentPadding: EdgeInsets.fromLTRB(
                                              15.0,
                                              0.0,
                                              0.0,
                                              0.0,
                                            ),
                                            dense: true,
                                            horizontalTitleGap: 0.0,
                                            minLeadingWidth: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                child: ExpansionTile(
                                                  backgroundColor:
                                                      themeData.primaryColor,
                                                  collapsedBackgroundColor:
                                                      themeData.primaryColor,
                                                  maintainState: true,
                                                  trailing: Icon(
                                                    Icons.expand_more,
                                                    size: 36,
                                                  ),
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Card(
                                                          elevation: 0,
                                                          color: themeData
                                                              .scaffoldBackgroundColor,
                                                          child: ListTileTheme(
                                                            child: ListTile(
                                                              tileColor: themeData
                                                                  .primaryColor,
                                                              title: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Wrap(
                                                                    children: List.generate(
                                                                        viewModel?.dtlModel?.viewList[index]?.userList?.length ??
                                                                            0,
                                                                        (ind) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            4.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Chip(
                                                                          elevation:
                                                                              0,
                                                                          backgroundColor:
                                                                              themeData.primaryColorDark,
                                                                          label:
                                                                              Text(
                                                                            viewModel?.dtlModel?.viewList[index]?.userList[ind]?.name ??
                                                                                "User",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                  title: Text(
                                                    "User List :",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        });
  }

  Widget _buildButton(BaseTheme theme,
      {bool reverse = false, IconData icon, String title}) {
    return Row(
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

  showDialog({
    BackDatedEntryViewModel viewModel,
  }) {
    appShowChildDialog(
        context: context,
        child: EditOptionDialog(
          viewModel: viewModel,
        ));
  }

  showAlertEditSave(
    BuildContext context,
    BackDatedEntryViewModel viewModel,
    DateTime periodFrom,
    DateTime periodTo,
    DateTime validTo,
  ) {
    final _colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String tempDateYear = widget.order.periodfrom.substring(6, 10);
    String tempDateMonth = widget.order.periodfrom.substring(3, 5);
    String tempDateDay = widget.order.periodfrom.substring(0, 2);
    String tempDateYearto = widget.order.periodto.substring(6, 10);
    String tempDateMonthto = widget.order.periodto.substring(3, 5);
    String tempDateDayto = widget.order.periodto.substring(0, 2);
    String tempDateYearV = widget.order.validupto.substring(6, 10);
    String tempDateMonthtoV = widget.order.validupto.substring(3, 5);
    String tempDateDaytoV = widget.order.validupto.substring(0, 2);
    String tempDateto =
        "$tempDateYearto-$tempDateMonthto-$tempDateDayto 00:00:00.00000";
    String tempDateV =
        "$tempDateYearV-$tempDateMonthtoV-$tempDateDaytoV 00:00:00.00000";
    String tempDate =
        "$tempDateYear-$tempDateMonth-$tempDateDay 00:00:00.00000";
    DateTime tempPeriodF = DateTime.parse(tempDate);
    DateTime tempPeriodT = DateTime.parse(tempDateto);
    DateTime tempPeriodV = DateTime.parse(tempDateV);
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
                            "You are going to save, Do you want to continue ?",
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
                          viewModel.onEditSave(
                              viewModel,
                              viewModel?.periodFrom ?? tempPeriodF,
                              viewModel?.periodTo ?? tempPeriodT,
                              viewModel?.validUpto ?? tempPeriodV);
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
  }
}

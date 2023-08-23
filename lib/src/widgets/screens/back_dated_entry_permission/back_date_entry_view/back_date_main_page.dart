import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:redstars/resources.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/back_dated_entry_permission/back_dated_entry_permission_action.dart';
import 'package:redstars/src/redux/actions/item_grade_rate_settings/item_grade_rate_settings_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/back_dated_entry_permission/back_dated_entry_permission_viewmodel.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/back_dated_entry_detail_model.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_entry_view/partials/back_date_add_item_sheet.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/back_date_view_page.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/initial_model.dart';

import '../../../../../utility.dart';
import 'model/back_date_sub_model.dart';

var node2;
var node;
var jsRespns2;
var jsRespns;
int selectedBranchId2;
List<AddUserList> finalItems = [];

class BackDatedEntryView extends StatefulWidget {
  final String title;

  const BackDatedEntryView({Key key, this.title}) : super(key: key);
  @override
  _BackDatedEntryViewState createState() => _BackDatedEntryViewState();
}

class _BackDatedEntryViewState extends State<BackDatedEntryView> {
  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return BaseView<AppState, BackDatedEntryViewModel>(
        init: (store, con) {
          final state = store.state.backDatedEntryState;
          store.dispatch(fetchOptions());
          store.dispatch(fetchBranch());
          store.dispatch(fetchBackDateView(
              backDateFilterModel: state.backDateFilterModel));
        },
        onDidChange: (viewModel, context) {
          if (viewModel.isSaved)
            showSuccessDialog(context, "Saved Successfully", "Success", () {
              viewModel.onClear();
              Navigator.pop(context);
            });
        },
        builder: (con, viewModel) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.height;

          return Scaffold(
            // key: _scaffoldKey,
            appBar: BaseAppBar(
              title: viewModel.isEdited == 0
                  ? Text("Back Dated Entry Permission")
                  : Text(widget.title ?? "Back Dated Entry Permission"),
              actions: [
                IconButton(
                    onPressed: () {
                      if (viewModel.periodFrom.compareTo(viewModel.periodTo) >
                          0) {
                        return appShowChildDialog(
                            context: context, child: showAlert2(context));
                      } else if (viewModel
                          .backDatedEntrySanctionedData.isEmpty) {
                        return appShowChildDialog(
                            context: context, child: showAlert3(context));
                      } else {
                        return appShowChildDialog(
                            context: context,
                            child: showAlert(
                                context,
                                viewModel,
                                viewModel.backDateInitialModel.periodFrom,
                                viewModel.backDateInitialModel.periodTo,
                                viewModel.backDateInitialModel.validUpto,
                                viewModel.dtlModel));
                      }
                    },
                    icon: Icon(Icons.check))
              ],
            ),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 15),
                  // if (viewModel.stockReqId == 0)
                  FloatingActionButton(
                      onPressed: () {
                        showItemAddSheet(context, viewModel: viewModel);
                      },
                      heroTag: "items",
                      autofocus: true,
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: themeData.primaryColorDark,
                      ))
                ]),
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              SizedBox(
                height: 12,
              ),
              Center(
                child: BaseRaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("View Saved Backed Dated Entry Permissions"),
                    ),
                    onPressed: () {
                      BaseNavigate(context, BackDateViewScreenPage());
                    }),
              ),
              Flexible(
                flex: (height * .015).toInt(),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    DatePeriodCard(
                      viewModel: viewModel,
                      // sourceLocation: viewModel.selectedLocation,
                      // sourceLocations: viewModel.itemGradeRateLocationObj,
                      // onSourceChange: (location) {
                      //   viewModel.onLocationChange(location);
                      // },
                      onDateChanged: (date) {
                        viewModel.onChangeDates(date);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: height * .014, vertical: 0),
                child: Text("Sanctioned Options :"),
              ),
              Expanded(
                  flex: 18,
                  child: Stack(children: <Widget>[
                    if (viewModel?.backDatedEntrySanctionedData?.isNotEmpty ??
                        false)
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (con, position) {
                          BackDateEntrySubModel object =
                              viewModel.backDatedEntrySanctionedData[position];
                          return Dismissible(
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  viewModel.onRemoveItem(object);
                                } else {
                                  viewModel.onRemoveItem(object);
                                }
                              },
                              background: Container(
                                  decoration: BoxDecoration(color: Colors.red),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: _buildButton(theme))),
                              key: UniqueKey(),
                              confirmDismiss: (direction) {
                                return appChoiceDialog(
                                    message:
                                        "Do you want to delete this record",
                                    context: con);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                child: ListBackDatedPermissionVIew(
                                  backDatedModel: object,
                                  index: position,
                                  onClick: (selected) {
                                    if (selected != null) {
                                      viewModel.getUserList(
                                          selected.branchName.id,
                                          selected.optionName.id);
                                    }
                                    showItemAddSheet(con,
                                        selected: selected,
                                        viewModel: viewModel,
                                        finalItems: finalItems,
                                        index: position);
                                  },
                                  isClicked: true,
                                ),
                              ));
                        },
                        itemCount:
                            viewModel.backDatedEntrySanctionedData?.length ?? 0,
                      )
                    else
                      Center(
                        child: EmptyResultView(
                          message: "No Data Found",
                        ),
                      )
                  ])),
              SizedBox(
                height: 10,
              ),
            ]),
          );
        },
        converter: (store) => BackDatedEntryViewModel.fromStore(store),
        onDispose: (store) {
          // store.dispatch(OnClearAction());
          store.dispatch(ItemGradeRatClearAction());
        });
  }

  Future fetchUserList1(int branchId, int optionId) async {
    print("working");
    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.acceptCharsetHeader: "UTF-8",
      HttpHeaders.cookieHeader:
          await BasePrefs.getString(BaseConstants.COOKIE_KEY)
    };
    String clientId = await BasePrefs.getString(BaseConstants.CLIENTID_KEY);
    int userId = await BasePrefs.getInt(BaseConstants.USERID_KEY);
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
    print('$jSessionId::::::::::: $ssnId');
    var body = {
      "url": "/security/controller/cmn/getdropdownlist",
      "jsonArr": '[{\"flag\":\"ALL\",\"start\":\"0\",\"limit\":\"1000\",\"value\":\"0\",\"colName\":\"name\",'
          '\"params\":[{\"column\":\"BranchId\",\"value\":\"$branchId\"},{\"column\":\"OptionId\",\"value\":\"$optionId\"}],'
          '\"dropDownParams\":[{\"list\":\"LOCATION_MULTI_SEL\",\"key\":\"resultObject\",'
          '\"procName\":\"BackDatedEntryListproc\",'
          '\"actionFlag\":\"LIST\",\"subActionFlag\":\"USER\",'
          '}]}]',
      'ssnidn': '$ssnId'
    };
    print(body);
    String url = Connections().generateUri() + 'getdata';
    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.body.contains("No Error")) {
      print("response ----- ${response.body}");
      var jsonResponse = json.decode(response.body);
      print("yolo");
      node = jsonResponse;
      jsRespns = jsonResponse;
      var result = node['resultObject'];
      var jsResult = jsonEncode(result);
      log(jsResult);
      Iterable k = json.decode(jsResult);
      finalItems = k != null
          ? List<AddUserList>.of(k.map((model) => AddUserList.fromJson(model)))
          : null;
      // if (mounted)
      setState(() {
        // widget.viewModel.userList.addUserList = ds;
        // ds.forEach((element) {
        //   users.add(element);
        // });
      });

      print(node);
      return jsRespns;
    } else if (response.body.isEmpty) {
      // showLoaderDialog(context);
    }
  }

  void showItemAddSheet(BuildContext context,
      {BackDatedEntryViewModel viewModel,
      BackDateEntrySubModel selected,
      List<AddUserList> finalItems,
      int index}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_context) => SetBranchOptions<BackDateEntrySubModel>(
          index: index,
          viewModel: viewModel,
          finalItems: finalItems ?? [],
          onNewItem: (reqItem, index) => viewModel.onAdd(
              BackDateEntrySubModel.fromRequisitionModel(reqItem), index),
          selected: selected),
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

  Widget emptyView(BaseTheme theme, BaseColors colors, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Center(
        child: Container(
          height: height / 4.5,
          width: width / 2,
          child: Stack(children: [
            Positioned.fill(
              // top: MediaQuery.of(context).size.height * .14,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(AppVectors.emptyBox
                    // color: Colors.black,
                    ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // void _awaitReturnStatus(
  //     BuildContext context, ItemGradeRateViewModel viewModel) async {
  //   final result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ItemGradeRateSetViewPage(
  //           viewModel: viewModel,
  //         ),
  //       ));
  //   // setState(() {
  //   approvalStatus = result;
  //   print("status------${result}");
  // }
}

showAlert(
    BuildContext context,
    BackDatedEntryViewModel viewModel,
    DateTime periodFrom,
    DateTime periodTo,
    DateTime validTo,
    BackDateEntryDetailModel detail) {
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
                        print(viewModel?.periodFrom);
                        viewModel.onSave(
                            viewModel, periodFrom, periodTo, validTo, detail);
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

showAlert2(
  BuildContext context,
) {
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
                          "Period From cannot be greater than Period To",
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
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          )));
}

showAlert3(BuildContext context) {
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
                          "No Items to Approve",
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
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          )));
}

class DatePeriodCard extends StatefulWidget {
  final BackDatedEntryViewModel viewModel;
  final Function(BackDateInitialModel) onDateChanged;

  const DatePeriodCard({Key key, this.viewModel, this.onDateChanged})
      : super(key: key);
  @override
  _DatePeriodCardState createState() => _DatePeriodCardState();
}

class _DatePeriodCardState extends State<DatePeriodCard> {
  DateTime periodFrom;
  DateTime periodTo;
  DateTime validTo;
  BackDateInitialModel dateModel;
  @override
  void initState() {
    dateModel =
        widget.viewModel?.backDateInitialModel ?? BackDateInitialModel();
    // periodFrom = widget.viewModel.periodFrom;
    // periodTo = widget.viewModel.periodTo;
    // validTo = widget.viewModel.validUpto;
    periodFrom = dateModel.periodFrom;
    periodTo = dateModel.periodTo;
    validTo = dateModel.validUpto;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: themeData.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
            child: IntrinsicHeight(
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: width / 3,
                                      child: BaseDatePicker(
                                        displayTitle: "Period From :",
                                        isVector: true,
                                        icon: Icons.date_range,
                                        initialValue: periodFrom,
                                        // initialValue: viewModel
                                        //         ?.backDateInitialModel
                                        //         ?.periodFrom ??
                                        //     currentDate.subtract(
                                        //         Duration(days: 1)),
                                        onChanged: (val) {
                                          widget.viewModel
                                              ?.onChangePeriodFrom(val);
                                          widget.onDateChanged(
                                              BackDateInitialModel(
                                                  periodFrom: val,
                                                  periodTo: periodTo,
                                                  validUpto: validTo));

                                          periodFrom = val;
                                        },
                                        onSaved: (val) {},
                                        disableFutureDate: true,
                                      ),
                                    ),
                                    Container(
                                      width: width / 3,
                                      child: BaseDatePicker(
                                        displayTitle: "Period To :",
                                        isVector: true,
                                        icon: Icons.date_range,
                                        initialValue: periodTo,
                                        // initialValue: viewModel?.periodTo ??
                                        //     currentDate.subtract(
                                        //         Duration(days: 1)),
                                        onChanged: (val) {
                                          widget.viewModel
                                              ?.onChangePeriodTo(val);

                                          widget.onDateChanged(
                                              BackDateInitialModel(
                                                  periodFrom: periodFrom,
                                                  periodTo: val,
                                                  validUpto: validTo));
                                          dateModel.periodTo = val;
                                          periodTo = val;
                                        },
                                        onSaved: (val) {
                                          periodTo = val;
                                        },
                                        disableFutureDate: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: width / 3,
                                      child: BaseDatePicker(
                                        displayTitle: "Valid Upto :",
                                        isVector: true,
                                        icon: Icons.date_range,
                                        // initialValue: dateModel.validUpto,
                                        initialValue: validTo,
                                        onChanged: (val) {
                                          widget.viewModel
                                              .onChangePeriodValidUpto(val);

                                          widget.onDateChanged(
                                              BackDateInitialModel(
                                                  periodFrom: periodFrom,
                                                  periodTo: periodTo,
                                                  validUpto: val));
                                          dateModel.validUpto = val;
                                          validTo = val;
                                          print(periodFrom.toString() +
                                              "\n" +
                                              periodTo.toString() +
                                              "\n" +
                                              validTo.toString());
                                        },

                                        disablePreviousDates: true,
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
                        height: 20,
                      )
                    ],
                  ),
                ),
              ]),
        )),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/grading_and_costing/grading_and_costing.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_process_gin_fill_list.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/widgets/partials/lookup/grading_lookup_field.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/model/grading_model.dart';

import '../../../../../utility.dart';

List<GradeModel> itemData = [];

class EditGradeView<T extends GradeModel> extends StatefulWidget {
  final Function(GradingModel pricingModel) onViewDetails;
  final GradingCostingViewModel viewModel;
  final T selected;
  final int index;
  final int editId;
  final int listdata;
  final int itemId;

  const EditGradeView({
    Key key,
    this.onViewDetails,
    this.selected,
    this.viewModel,
    this.index,
    this.editId,
    this.listdata,
    this.itemId,
  }) : super(key: key);

  @override
  _EditGradeViewState createState() => _EditGradeViewState();
}

class _EditGradeViewState extends State<EditGradeView> {
  GradeModel model;
  GradeLookupItem gradeData;
  ProcessFillGINListModel dataMode;
  int editId = 1;
  List<GradeModel> tempGradeList = new List<GradeModel>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController rateController = TextEditingController(text: "");
  final TextEditingController Controller = TextEditingController();
  double rate = 0;
  var node;

  @override
  void initState() {
    gradeData = model?.gradeLookupData;
    model = widget.viewModel?.gradeModel ?? GradeModel();
    editId = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("model-----${model}");
    ThemeData themedata = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double qty = 0.0;
    double totalvalue = 0;
    double result = 0;
    print("$editId 2");
    return BaseView<AppState, GradingCostingViewModel>(
      converter: (store) => GradingCostingViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Scaffold(
          body: Container(
            color: themedata.primaryColor,
            child: Column(
              children: [
                Expanded(
                    flex: 50,
                    child: new AnimatedPadding(
                      padding: EdgeInsets.only(top: height * 0.038),
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.decelerate,
                      child: new Container(
                        color: themedata.primaryColor.withOpacity(.6),
                        height: height * 1,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                flex: 3,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: themedata.primaryColorDark,
                                  child: Row(children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(
                                      width: width * .03,
                                    ),
                                    Text("Grading Entry ",
                                        style: theme.subhead1Bold.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                  ]),
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: ListView.builder(
                                  itemCount: widget
                                      ?.viewModel
                                      ?.gradingCostingViewDetailModel
                                      ?.gradingDetailViewList
                                      ?.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return widget
                                                .viewModel
                                                .gradingCostingViewDetailModel
                                                .gradingDetailViewList[index]
                                                .gradingDtlJson !=
                                            null
                                        ? Column(
                                            children: [
//                                               Container(
//                                                 padding: EdgeInsets.only(
//                                                     left: 8,
//                                                     right: 8,
//                                                     top: 3,
//                                                     bottom: 3),
//                                                 child: BaseDialogField<
//                                                     GradeLookupItem>(
//                                                   // isChangeHeight: false,
//                                                   vector:
//                                                       AppVectors.transaction,
//                                                   hint: "Tap select data",
//                                                   displayTitle: "Grades",
//                                                   // icon: icon ?? Icons.dashboard,
//                                                   list: widget.viewModel.grades,
//                                                   initialValue:
//                                                       model?.gradeLookupData,
//                                                   isEnabled: true,
//                                                   listBuilder: (val, pos) =>
//                                                       DocumentTypeTile(
//                                                     selected: true,
//                                                     subTitle: val.code,
//                                                     //isVector: true,,
//                                                     // vector: vector,
//                                                     icon: Icons.list,
//                                                     title: val.name,
//                                                     vector:
//                                                         AppVectors.transaction,
//                                                     onPressed: () =>
//                                                         Navigator.pop(
//                                                             context, val),
//                                                   ),
//                                                   fieldBuilder: (selected) =>
//                                                       Text(
//                                                     selected?.name ?? "",
//                                                     style: BaseTheme.of(context)
//                                                         .textfield,
//                                                     textAlign: TextAlign.start,
//                                                   ),
//                                                   onBeforeChanged: (value) {
//                                                     bool isValid = true;
//
//                                                    widget. viewModel?.gradingCostingViewDetailModel?.gradingDetailViewList[widget.index].gradingDtlJson.first.
//                                                     if (widget.viewModel
//                                                                 .itemDetailList[
//                                                             widget.index] !=
//                                                         null) {
//                                                       widget
//                                                           .viewModel
//                                                           ?.itemDetailList[
//                                                               widget.index]
//                                                           ?.gradeModelData
//                                                           ?.forEach((element) {
//                                                         if (element
//                                                                 .gradeLookupData ==
//                                                             value) {
//                                                           showInformation(
//                                                               context,
//                                                               widget.viewModel,
//                                                               value);
//                                                           isValid = false;
//                                                           // setState(() {});
//                                                         }
//                                                       });
//                                                       return isValid;
//                                                     }
//                                                     return isValid;
//                                                   },
//                                                   onChanged: (value) {
//                                                     print(widget.itemId);
//                                                     print(value.id);
//                                                     costApi(widget.itemId,
//                                                         value.id);
//
//                                                     model?.gradeLookupData =
//                                                         value;
//                                                     setState(() {
//                                                       raController.clear();
//                                                       model.total = null;
//                                                     });
//
//                                                     print(model?.gradeLookupData
//                                                         ?.name);
//                                                   },
//                                                   onSaved: (value) {
//                                                     model?.gradeLookupData =
//                                                         value;
//                                                   },
//                                                   // validator: (val) =>
//                                                   // (isMandatory && val == null) ? "Please select $title " : null,
//                                                   // displayTitle: title + (isMandatory ? " * " : ""),
//                                                   //
//                                                   // onSaved: onSaved,
//                                                   // onChanged: onChanged,
// //          onSaved: (val) {}
//                                                 ),
//
//                                                 // GradingLookupTextField(
//                                                 //   //initialValue: "",
//                                                 //   vector: AppVectors.transaction,
//                                                 //   flag: 0,
//                                                 //   hint: "Tap select data",
//                                                 //   displayTitle: "Grade",
//                                                 //   onChanged: (value) {
//                                                 //     widget.viewModel.listOfGradeModel
//                                                 //         .forEach((element) {
//                                                 //       if (element.gradeLookupData ==
//                                                 //           value) {
//                                                 //         showInformation(context,
//                                                 //             widget.viewModel, value);
//                                                 //         setState(() {});
//                                                 //       }
//                                                 //     });
//                                                 //     // if (widget
//                                                 //     //         .viewModel.listOfGradeModel
//                                                 //     //         .contains(value) ==
//                                                 //     //     true) {
//                                                 //     //
//                                                 //     // }
//                                                 //     print(widget.itemId);
//                                                 //     print(value.id);
//                                                 //     costApi(widget.itemId, value.id);
//                                                 //
//                                                 //     model?.gradeLookupData = value;
//                                                 //     setState(() {
//                                                 //       raController.clear();
//                                                 //       model.total = null;
//                                                 //     });
//                                                 //
//                                                 //     print(model?.gradeLookupData?.name);
//                                                 //   },
//                                                 //   onSaved: (value) {
//                                                 //     model?.gradeLookupData = value;
//                                                 //   },
//                                                 // )
//                                               ),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 8,
                                                      right: 8,
                                                      // top: 3,
                                                      bottom: 3),
                                                  child: GradingLookupTextField(
                                                    vector:
                                                        AppVectors.transaction,
                                                    flag: 0,
                                                    hint: "Tap select data",
                                                    displayTitle: "Grade",
                                                    onChanged: (value) {
                                                      costApi(widget.itemId,
                                                          value.id);
                                                      model?.gradeLookupData =
                                                          value;
                                                      setState(() {
                                                        rateController.clear();
                                                        model.total = null;
                                                      });

                                                      print(model
                                                          ?.gradeLookupData
                                                          ?.name);
                                                      // gradeData = value;
                                                    },
                                                    onSaved: (val) {
                                                      model.gradeLookupData =
                                                          val;
                                                    },
                                                  )),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 3,
                                                    bottom: 3),
                                                child: BaseTextField(
                                                  displayTitle: "Qty",
                                                  vector: AppVectors.direct,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d+\.?\d{0,3}'))
                                                  ],
                                                  //initialValue: "",
                                                  controller: rateController,
                                                  isNumberField: true,
                                                  onTap: () {
                                                    rateController.clear();
                                                  },
                                                  onChanged: (val) {
                                                    qty = double.parse(val);
                                                    print("enter value $val");
                                                    model?.qty = qty;

                                                    //   addedTotalQty = qty;
                                                    //   print("neenu--$addedTotalQty");
                                                    //   checkingQty = qty;
                                                    //   var remains =    widget
                                                    //               .viewModel
                                                    //           .gradingCostingViewDetailModel
                                                    //        ?.gradingDetailViewList[ widget.index]
                                                    //                         .gradingDtlJson[widget.listdata]
                                                    //                         .qty -
                                                    //       qty;
                                                    //   if (!(   widget
                                                    //                      .viewModel
                                                    //                .gradingCostingViewDetailModel
                                                    //                     ?.gradingDetailViewList[
                                                    //                              index]
                                                    //                   .gradingDtlJson[
                                                    //                 widget. listdata]
                                                    //                       .qty >=
                                                    //       (addedTotalQty ?? 0.0))) {
                                                    //     showSuccessDialog(context, "",
                                                    //         " Alert\n Qty exceeded\n Maximum Qty is ${widget.viewModel.itemDetailList[widget.index].qty} \n Ramaining Qty is ${remains}",
                                                    //             () {
                                                    //           raController.clear();
                                                    //         });
                                                    //   }
                                                    // }
                                                    print(
                                                        "enter value${model?.qty}");
                                                    model.rate = node != null &&
                                                            (node["resultObject"]
                                                                    ?.isNotEmpty ??
                                                                false)
                                                        ? (node["resultObject"]
                                                                [0]["rate"])
                                                            .toDouble()
                                                        : 0;
                                                    setState(() {
                                                      model.total = model.rate *
                                                          model.qty;
                                                    });

                                                    print(
                                                        "model.rate ----${model?.rate}");
                                                  },
                                                  validator: (val) {
                                                    return (val == null
                                                        ? "Please Enter a qty"
                                                        : null);
                                                  },
                                                  onSaved: (value) {},
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 18, right: 0),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 18, right: 0),
                                                  decoration: BoxDecoration(
                                                      color: themedata
                                                          .primaryColor,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: themedata
                                                                  .accentColor))),
                                                  padding: EdgeInsets.only(
                                                      right: 15,
                                                      left: 0,
                                                      top: 15,
                                                      bottom: 8),
                                                  child: Row(
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
                                                        node != null &&
                                                                (node["resultObject"]
                                                                        ?.isNotEmpty ??
                                                                    false)
                                                            ? BaseNumberFormat(
                                                                    number: node[
                                                                            "resultObject"][0]
                                                                        [
                                                                        "rate"])
                                                                .formatRate()
                                                                .toString()
                                                            : "0.00000",
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 18, right: 0),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 18, right: 0),
                                                  decoration: BoxDecoration(
                                                      color: themedata
                                                          .primaryColor,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: themedata
                                                                  .accentColor))),
                                                  padding: EdgeInsets.only(
                                                      right: 15,
                                                      left: 0,
                                                      top: 15,
                                                      bottom: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Total Value",
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        BaseNumberFormat(
                                                                number: (model
                                                                    .total))
                                                            .formatTotal()
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text("");
                                  },
                                ),
                              ),
                              //SizedBox(height: height * .08),
                            ],
                          ),
                        ),
                      ),
                    )),
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          width: MediaQuery.of(context).size.width,
                          child: BaseRaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            backgroundColor: themedata.primaryColorDark,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                widget.viewModel.onAdd(model);

                                print("index -- ${widget?.index ?? 3}");
                                print("listdata -- ${widget?.listdata ?? 3}");
                                print(model?.gradeLookupData?.name);
                                print(
                                    "listofList${widget.viewModel.listOfGradeModel.length}");
                                print("Added data");
                                print(" ==================");
                                print(model?.gradeLookupData?.name);
                                print(model?.rate);
                                print(model?.qty);
                                print(" ==================");
                                if (editId == 1) {
                                  // var flag = widget.viewModel
                                  //     .itemDetailList[widget.index].gradeModelData
                                  //     .contains(model);
                                  print("afterinitialdata");
                                  // if (!flag) {
                                  var k = widget
                                      .viewModel
                                      ?.gradingCostingViewDetailModel
                                      ?.gradingDetailViewList[widget.index]
                                      .gradingDtlJson[widget.listdata]
                                      ?.qty;
                                  //     model.qty;
                                  //   return k;
                                  // }
                                  widget
                                      .viewModel
                                      ?.gradingCostingViewDetailModel
                                      ?.gradingDetailViewList[widget.index]
                                      .gradingDtlJson[widget.listdata]
                                      ?.qty = model.qty;

                                  widget
                                      .viewModel
                                      ?.gradingCostingViewDetailModel
                                      ?.gradingDetailViewList[widget.index]
                                      .gradingDtlJson[widget.listdata]
                                      ?.rate = (model?.rate ?? 0).toDouble();

                                  widget
                                      .viewModel
                                      ?.gradingCostingViewDetailModel
                                      ?.gradingDetailViewList[widget.index]
                                      .gradingDtlJson[widget.listdata]
                                      ?.gradename = model.gradeLookupData.name;

                                  print(
                                      "update ${widget.viewModel?.gradingCostingViewDetailModel?.gradingDetailViewList[widget.index].gradingDtlJson[widget.listdata]?.qty}");
                                  print(itemData.length);
                                  setState(() {
                                    Navigator.pop(context, model);
                                    Navigator.pop(context);
                                  });

                                  return k;
                                } else {
                                  tempGradeList?.add(model);
                                }
                              }
                            },
                            child: Text("ADD"),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> costApi(itemId, gradeId) async {
    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.acceptCharsetHeader: "UTF-8",
      HttpHeaders.cookieHeader:
          await BasePrefs.getString(BaseConstants.COOKIE_KEY)
    };
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    String jSessionId = await BasePrefs.getString(BaseConstants.COOKIE_KEY);
    print('$jSessionId::::::::::: $ssnId');
    var body = {
      "url": "/purchase/controller/cmn/getdropdownlist",
      "jsonArr": '[{\"dropDownParams\":[{\"list\":\"EXEC-PROC\",'
          '\"key\":\"resultObject\",\"procName\":\"GetItemGradeRateProc\",'
          '\"actionFlag\":\"LIST\",\"subActionFlag\":\"\",'
          '\"xmlStr\":\"<List ItemId  = \\\"$itemId\\\" GradeId = \\\"$gradeId \\\" '
          'Wefdate = \\\"${BaseDates(DateTime.now()).formatDate}\\\"  > </List>\"}]}]',
      'ssnidn': '$ssnId'
    };

    String url = Connections().generateUri() + 'getdata';
    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    print("response ----- ${response.body}");
    print("itemID----$itemId");
    print("gradeId---$gradeId");
    var jsonResponse = json.decode(response.body);

    setState(() {
      node = jsonResponse;
      // resultData =
      //     node != null ? node["resultObject"][0]["rate"].toString() : 0;
    });
  }

  var gradeTotal;

  double findTotalvalue(List<GradeModel> findingList) {
    findingList.forEach((gradeElement) {
      gradeTotal = gradeElement.rate * gradeElement.qty;
      gradeElement.total = gradeTotal;
      print(gradeTotal);
      return gradeElement.total;
    });
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_style.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/viewmodels/grading_and_costing/grading_and_costing.dart';
import 'package:redstars/src/services/model/response/grading_and_costing/grading_process_gin_fill_list.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/model/grading_model.dart';

import '../../../../../utility.dart';

List<GradeModel> itemData = [];

class ItemDetailView<T extends GradeModel> extends StatefulWidget {
  final Function(GradingModel pricingModel) onViewDetails;
  final GradingCostingViewModel viewModel;
  final T selected;
  final int index;
  final int itemId;
  final int listdata;

  const ItemDetailView({
    Key key,
    this.onViewDetails,
    this.selected,
    this.viewModel,
    this.index,
    this.itemId,
    this.listdata,
  }) : super(key: key);

  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  GradeModel model;
  GradeLookupItem gradeData;
  ProcessFillGINListModel dataMode;
  var node;
  String resultData;

  List<GradeModel> tempGradeList = new List<GradeModel>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController raController = TextEditingController(text: "");
  double dataq;

  @override
  void initState() {
    gradeData = model?.gradeLookupData;
    model = widget.viewModel?.gradeModel ?? GradeModel();
    super.initState();
  }

  double allowedQty = 0.0;
  double addedQty = 0;
  double checkingQty;

  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double qty = 0.0;
    int rate = 0;
    double total = 0.0;
    double totalvalue = 0;
    double result = 0;

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
                          SizedBox(
                            height: 3,
                          ),
                          Expanded(
                            flex: 20,
                            child: ListView.builder(
                              itemCount: widget?.viewModel?.gradingList?.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                result = widget?.viewModel?.gradingList[index]
                                        .itemDtl[index].totalValue ??
                                    2;
                                totalvalue = (widget
                                            ?.viewModel
                                            ?.itemDetailList[index]
                                            ?.gradingRate ??
                                        0) *
                                    (widget.viewModel.itemDetailList[index]
                                            .gradingQty ??
                                        0);

                                return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 3, bottom: 3),
                                      child: BaseDialogField<GradeLookupItem>(
                                        // isChangeHeight: false,
                                        vector: AppVectors.transaction,
                                        hint: "Tap select data",
                                        displayTitle: "Grades",
                                        // icon: icon ?? Icons.dashboard,
                                        list: widget.viewModel.grades,
                                        initialValue: model?.gradeLookupData,
                                        isEnabled: true,
                                        listBuilder: (val, pos) =>
                                            DocumentTypeTile(
                                          selected: true,
                                          subTitle: val.code,
                                          //isVector: true,,
                                          // vector: vector,
                                          icon: Icons.list,
                                          title: val.name,
                                          vector: AppVectors.transaction,
                                          onPressed: () =>
                                              Navigator.pop(context, val),
                                        ),
                                        fieldBuilder: (selected) => Text(
                                          selected?.name ?? "",
                                          style:
                                              BaseTheme.of(context).textfield,
                                          textAlign: TextAlign.start,
                                        ),
                                        onBeforeChanged: (value) {
                                          bool isValid = true;
                                          if (widget.viewModel.itemDetailList[
                                                  widget.index] !=
                                              null) {
                                            widget
                                                .viewModel
                                                ?.itemDetailList[widget.index]
                                                ?.gradeModelData
                                                ?.forEach((element) {
                                              if (element.gradeLookupData ==
                                                  value) {
                                                showInformation(context,
                                                    widget.viewModel, value);
                                                isValid = false;
                                                // setState(() {});
                                              }
                                            });
                                            return isValid;
                                          }
                                          return isValid;
                                        },
                                        onChanged: (value) {
                                          print(widget.itemId);
                                          print(value.id);
                                          costApi(widget.itemId, value.id);

                                          model?.gradeLookupData = value;
                                          setState(() {
                                            raController.clear();
                                            model.total = null;
                                          });

                                          print(model?.gradeLookupData?.name);
                                        },
                                        onSaved: (value) {
                                          model?.gradeLookupData = value;
                                        },
                                        // validator: (val) =>
                                        // (isMandatory && val == null) ? "Please select $title " : null,
                                        // displayTitle: title + (isMandatory ? " * " : ""),
                                        //
                                        // onSaved: onSaved,
                                        // onChanged: onChanged,
//          onSaved: (val) {}
                                      ),

                                      // GradingLookupTextField(
                                      //   //initialValue: "",
                                      //   vector: AppVectors.transaction,
                                      //   flag: 0,
                                      //   hint: "Tap select data",
                                      //   displayTitle: "Grade",
                                      //   onChanged: (value) {
                                      //     widget.viewModel.listOfGradeModel
                                      //         .forEach((element) {
                                      //       if (element.gradeLookupData ==
                                      //           value) {
                                      //         showInformation(context,
                                      //             widget.viewModel, value);
                                      //         setState(() {});
                                      //       }
                                      //     });
                                      //     // if (widget
                                      //     //         .viewModel.listOfGradeModel
                                      //     //         .contains(value) ==
                                      //     //     true) {
                                      //     //
                                      //     // }
                                      //     print(widget.itemId);
                                      //     print(value.id);
                                      //     costApi(widget.itemId, value.id);
                                      //
                                      //     model?.gradeLookupData = value;
                                      //     setState(() {
                                      //       raController.clear();
                                      //       model.total = null;
                                      //     });
                                      //
                                      //     print(model?.gradeLookupData?.name);
                                      //   },
                                      //   onSaved: (value) {
                                      //     model?.gradeLookupData = value;
                                      //   },
                                      // )
                                    ),
                                    // Container(
                                    //     padding: EdgeInsets.only(
                                    //         left: 8,
                                    //         right: 8,
                                    //         top: 3,
                                    //         bottom: 3),
                                    //     child: GradingLookupTextField(
                                    //       //initialValue: "",
                                    //       vector: AppVectors.transaction,
                                    //       flag: 0,
                                    //       hint: "Tap select data",
                                    //       displayTitle: "Grade",
                                    //       onChanged: (value) {
                                    //         widget.viewModel.listOfGradeModel
                                    //             .forEach((element) {
                                    //           if (element.gradeLookupData ==
                                    //               value) {
                                    //             showInformation(context,
                                    //                 widget.viewModel, value);
                                    //             setState(() {});
                                    //           }
                                    //         });
                                    //         // if (widget
                                    //         //         .viewModel.listOfGradeModel
                                    //         //         .contains(value) ==
                                    //         //     true) {
                                    //         //
                                    //         // }
                                    //         print(widget.itemId);
                                    //         print(value.id);
                                    //         costApi(widget.itemId, value.id);
                                    //
                                    //         model?.gradeLookupData = value;
                                    //         setState(() {
                                    //           raController.clear();
                                    //           model.total = null;
                                    //         });
                                    //
                                    //         print(model?.gradeLookupData?.name);
                                    //       },
                                    //       onSaved: (value) {
                                    //         model?.gradeLookupData = value;
                                    //       },
                                    //     )),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 3, bottom: 3),
                                      child: BaseTextField(
                                        displayTitle: "Qty",
                                        controller: raController,
                                        vector: AppVectors.direct,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,3}'))
                                        ],
                                        //initialValue: "",
                                        isNumberField: true,
                                        onTap: () {
                                          raController.clear();
                                        },
                                        onChanged: (val) {
                                          var addedTotalQty;
                                          qty = double.parse(val);
                                          print("enter value $val");
                                          model?.qty = qty;
                                          double addedQty;
                                          addedQty = addedQty ?? 0 + qty;
                                          print(addedQty);
                                          if (widget
                                                  .viewModel
                                                  .itemDetailList[widget.index]
                                                  ?.gradeModelData !=
                                              null) {
                                            widget
                                                .viewModel
                                                .itemDetailList[widget.index]
                                                ?.gradeModelData
                                                ?.forEach((element) {
                                              var totalQty = widget
                                                  .viewModel
                                                  .itemDetailList[widget.index]
                                                  .gradeModelData
                                                  .fold(
                                                      0,
                                                      (previousValue,
                                                              element) =>
                                                          previousValue +
                                                          element.qty);

                                              addedQty = totalQty;
                                              var d = totalQty + qty;
                                              print("totalQTY$addedQty");
                                              print("totalQTY$d");
                                              addedTotalQty = d;
                                              return addedQty;
                                            });

                                            print(
                                                "AddedTotalQty $addedTotalQty");
                                            var remainingQty = (widget
                                                        ?.viewModel
                                                        ?.itemDetailList[
                                                            widget.index]
                                                        ?.qty ??
                                                    0.0) -
                                                (addedTotalQty ?? 0.0);
                                            checkingQty = addedTotalQty;
                                            if (!(widget
                                                    .viewModel
                                                    ?.itemDetailList[
                                                        widget.index]
                                                    ?.qty >=
                                                (addedTotalQty ?? 0.0))) {
                                              showSuccessDialog(context, "",
                                                  " Alert\n Qty exceeded\n Maximum Qty is ${widget.viewModel.itemDetailList[widget.index].qty} \n Ramaining Qty is ${remainingQty}",
                                                  () {
                                                raController.clear();
                                              });
                                            }
                                          } else {
                                            addedTotalQty = qty;
                                            print("neenu--$addedTotalQty");
                                            checkingQty = qty;
                                            var remains = widget
                                                    .viewModel
                                                    ?.itemDetailList[
                                                        widget.index]
                                                    ?.qty -
                                                qty;
                                            if (!(widget
                                                    .viewModel
                                                    ?.itemDetailList[
                                                        widget.index]
                                                    ?.qty >=
                                                (addedTotalQty ?? 0.0))) {
                                              showSuccessDialog(context, "",
                                                  " Alert\n Qty exceeded\n Maximum Qty is ${widget.viewModel.itemDetailList[widget.index].qty} \n Ramaining Qty is ${remains}",
                                                  () {
                                                raController.clear();
                                              });
                                            }
                                          }

                                          print("enter value${model?.qty}");
                                          model.rate = node != null &&
                                                  (node["resultObject"]
                                                          ?.isNotEmpty ??
                                                      false)
                                              ? (node["resultObject"][0]
                                                      ["rate"])
                                                  .toDouble()
                                              : 0;
                                          setState(() {
                                            model.total =
                                                (model?.rate ?? 0) * model.qty;
                                          });

                                          print(
                                              "neenu ----${model.rate * qty}");
                                        },
                                        validator: (val) {
                                          return (val == null
                                              ? "Please Enter a qty"
                                              : null);
                                        },
                                        onSaved: (value) {},
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 18, right: 0),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 18, right: 0),
                                        decoration: BoxDecoration(
                                            color: themedata.primaryColor,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Rate",
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              node != null &&
                                                      (node["resultObject"]
                                                              ?.isNotEmpty ??
                                                          false)
                                                  ? BaseNumberFormat(
                                                          number: node[
                                                                  "resultObject"]
                                                              [0]["rate"])
                                                      .formatRate()
                                                      .toString()
                                                  : BaseNumberFormat(number: 0)
                                                      .formatRate(),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 18, right: 0),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 18, right: 0),
                                        decoration: BoxDecoration(
                                            color: themedata.primaryColor,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total Value",
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              (BaseNumberFormat(
                                                          number: (model.total))
                                                      .formatTotal())
                                                  .toString(),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
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
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      width: MediaQuery.of(context).size.width,
                      child: BaseRaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        enabled: ((checkingQty ?? 0.0) <=
                                widget
                                    .viewModel.itemDetailList[widget.index].qty)
                            ? true
                            : false,
                        backgroundColor: themedata.primaryColorDark,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            widget.viewModel.onAdd(model);
                            widget.viewModel.onEdit(model);
                            print(widget.index);

                            print(model?.gradeLookupData?.name);
                            print(
                                "listofList${widget.viewModel.listOfGradeModel.length}");

                            print("Added data");
                            print(" ==================");
                            print(model?.gradeLookupData?.name);
                            print(model?.rate);
                            print(model?.qty);
                            print(" ==================");

                            if (widget.viewModel.itemDetailList[widget.index]
                                    .gradeModelData !=
                                null) {
                              var flag = widget.viewModel
                                  .itemDetailList[widget.index].gradeModelData
                                  .contains(model);
                              print("afterinitaildata");
                              // if (!flag) {

                              // widget
                              //     .viewModel
                              //     .itemDetailList[widget.index]
                              //     ?.gradeModelData
                              //     ?.forEach((element) {
                              //   var totalQty = widget
                              //       .viewModel
                              //       .itemDetailList[widget.index]
                              //       .gradeModelData
                              //       .fold(
                              //       0,
                              //           (previousValue, element) =>
                              //       previousValue +
                              //           element.qty);
                              //   print("totalQTY$totalQty");
                              //   if ((widget
                              //       .viewModel
                              //       .itemDetailList[
                              //   widget.index]
                              //       .qty >
                              //       totalQty)) {
                              //     showSuccessDialog(context,
                              //         "ahdqjeh", "hwj", () {});
                              //   }
                              // });
                              // if(widget.viewModel.itemDetailList[widget.index].qty>)
                              var k = widget.viewModel
                                  ?.itemDetailList[widget.index]?.gradeModelData
                                  ?.add(model);
                              //   return k;
                              // }

                              itemData = widget.viewModel
                                  .itemDetailList[widget.index]?.gradeModelData;

                              widget.viewModel.itemDetailList[widget.index]
                                  ?.gradeModelData
                                  ?.forEach((element) {
                                print(element?.gradeLookupData?.name);
                                print(element?.rate);
                                print(element?.qty);
                                var totalQty = widget.viewModel
                                    .itemDetailList[widget.index].gradeModelData
                                    .fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue + element.qty);
                                print(totalQty);
                                if ((widget.viewModel
                                        .itemDetailList[widget.index].qty ==
                                    totalQty)) {
                                  print(widget.viewModel
                                      .itemDetailList[widget.index].qty);
                                }
                                print(
                                    "length${widget.viewModel.itemDetailList[widget.index].gradeModelData.length}");
                              });

                              Navigator.pop(context, model);
                              return k;
                            } else {
                              tempGradeList?.add(model);
                              print("initaildata");
                              widget.viewModel.itemDetailList[widget.index]
                                  .gradeModelData = tempGradeList;
                            }

                            // widget.viewModel.itemDetailList[widget.index]
                            //     ?.gradeModelData
                            //     ?.forEach((element) {
                            //   print(element?.gradeLookupData?.name);
                            //   print(element?.rate);
                            //   print(element?.qty);
                            // });
                            //
                            // print(
                            //     "length${widget.viewModel.itemDetailList[widget.index].gradeModelData.length}");

                            Navigator.pop(context);
                          }
                        },
                        child: ((checkingQty ?? 0.0) <=
                                widget
                                    .viewModel.itemDetailList[widget.index].qty)
                            ? Text("ADD")
                            : Text(""),
                      ),
                    )),
              ],
            ),
            // Text(itemData.length.toString()),

            // Expanded(
            //   flex: 8,
            //   child: ListView.builder(
            //       shrinkWrap: true,
            //       itemCount: itemData.length,
            //       itemBuilder: (context, int index) {
            //         return Container(
            //             color: Colors.green,
            //             // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //             child: Column(
            //               children: [
            //                 Text("hello"),
            //                 Text(itemData[index]?.gradeLookupData?.name)
            //               ],
            //             ));
            //       }),
            // ),

            //  Text(widget?.viewModel?.gradingModel?.qty.toString() ?? "")
            // Expanded(
            //     flex: 15,
            //     child: ListView.builder(itemBuilder: (context, position) {
            //       return (widget.viewModel.listOfGradeModel?.isNotEmpty &&
            //               widget.viewModel.listOfGradeModel != null)
            //           ? ListView.builder(
            //               shrinkWrap: true,
            //               itemBuilder: (con, position) {
            //                 GradeModel object =
            //                     widget.viewModel.listOfGradeModel[position];
            //                 return Dismissible(
            //                     onDismissed: (direction) {
            //                       widget.viewModel.onRemoveItem(object);
            //                     },
            //                     background: Container(
            //                       decoration: BoxDecoration(color: Colors.red),
            //                       child: Padding(
            //                         padding:
            //                             const EdgeInsets.symmetric(horizontal: 8),
            //                         child: _buildDeleteButton(theme),
            //                       ),
            //                     ),
            //                     secondaryBackground: DecoratedBox(
            //                       decoration: BoxDecoration(color: Colors.red),
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.end,
            //                         children: <Widget>[
            //                           Padding(
            //                             padding: const EdgeInsets.symmetric(
            //                                 horizontal: 8),
            //                             child: _buildDeleteButton(theme),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     key: Key(object.gradeLookupData.code),
            //                     confirmDismiss: (direction) => appChoiceDialog(
            //                         message: "Do you want to delete this record",
            //                         context: con),
            //                     child: ListItem(
            //                       viewModel: widget.viewModel,
            //                       gradeModel: object,
            //                       // onClick: (selected) => showItemAddSheet(
            //                       //   con,
            //                       //   selected: selected,
            //                       //   viewModel: widget.viewModel,
            //                       // ),
            //                     ));
            //               },
            //               itemCount: widget.viewModel.listOfGradeModel?.length ?? 0,
            //             )
            //           : Container(
            //               color: theme.colors.secondaryColor,
            //             );
            //     }))
          ],
        ),
      ),
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

class ListItem<T extends GradeModel> extends StatelessWidget {
  final GradeModel gradeModel;

//  final ValueSetter<T> onClick;
  final GradingCostingViewModel viewModel;

  const ListItem({Key key, this.gradeModel, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);

    return Column(
      children: [
        Container(
          color: theme.colors.secondaryColor,
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
                color: theme.colors.secondaryColor,
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

class GradeItems extends StatelessWidget {
  final GradingCostingViewModel viewModel;

  const GradeItems({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GradeModel> data = [];
    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, position) {
            data = viewModel.itemDetailList[position].gradeModelData;
            return (viewModel.itemDetailList[position].gradeModelData != null &&
                    viewModel
                        .itemDetailList[position].gradeModelData.isNotEmpty)
                ? Container(
                    child: Column(
                      children: [
                        Text(data[position].gradeLookupData.name ?? ""),
                        // Text((viewModel?.itemDetailList[position]
                        //             ?.gradeModelData[position]?.qty)
                        //         .toString() ??
                        //     ""),
                        // Text(viewModel
                        //         .listOfGradeModel[position]?.gradeLookupData?.name ??
                        //     ""),
                        // Text(viewModel.listOfGradeModel[position]?.qty.toString() ??
                        //     ""),
                        // Text(viewModel.listOfGradeModel[position]?.rate.toString() ??
                        //     ""),
                        // Text(((viewModel.listOfGradeModel[position]?.qty ?? 0) *
                        //         (viewModel.listOfGradeModel[position]?.rate ?? 0))
                        //     .toString())
                      ],
                    ),
                  )
                : Container(
                    color: BaseColors.of(context).primaryColor,
                  );
          }),
    );
  }
}

showInformation(BuildContext context, GradingCostingViewModel viewModel,
    GradeLookupItem selectedGrade) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final _colors = BaseColors.of(context);
      ThemeData themeData = ThemeProvider.of(context);
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;

      return AlertDialog(
          backgroundColor: themeData.scaffoldBackgroundColor,
          title: Center(child: Text("Information")),
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
                              "${selectedGrade.name} is already selected",
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
                            // Navigator.pop(context);
                          },
                        ),
                      ),
                      // Container(
                      //   height: height * .07,
                      //   width: width * .3,
                      //   child: BaseClearButton(
                      //     borderRadius: BorderRadius.circular(8),
                      //     backgroundColor: _colors.white,
                      //     color: themeData.primaryColorDark,
                      //     child: const Text("CANCEL"),
                      //     onPressed: () => Navigator.pop(context),
                      //   ),
                      // ),
                    ],
                  )
                ],
              )));
    },
  );
}

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request/transaction_unblock_request_viewmodel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/Action_Taken%20Agst_Whom_Model.dart';

class TransUnblockReqlEdit extends StatefulWidget {
  final int id;

  final int pos;
  final TranUnblockReqViewmodel viewmodel;

  const TransUnblockReqlEdit({Key key, this.id, this.pos, this.viewmodel
//    this.model,this.onSubmit
      })
      : super(key: key);

  @override
  _TransUnblockReqlEditState createState() => _TransUnblockReqlEditState();
}

class _TransUnblockReqlEditState extends State<TransUnblockReqlEdit> {
  List<dynamic> selectedActionWhom = [];
  String ActualBlockReason;
  String ActionTaken;
  String blckdateWithTIme;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  DateFormat _fileDate = new DateFormat('dd-MM-yyyy hh:mm:ss');
  DateTime  datenw = DateTime.now();
  @override
  Widget build(BuildContext context) {
//    if (widget.viewmodel.loading != true)
    ThemeData themeData = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    {
      return BaseView<AppState, TranUnblockReqViewmodel>(
          converter: (store) => TranUnblockReqViewmodel.fromStore(store),
          onDidChange: (viewModel, context) {
            if (viewModel.loading == true) {
          showSuccessDialog(context, "Saved Successfully", "Success", () {
viewModel.restLoading();
                // Navigator.popUntil(
                //     context, (route) => route.settings.name == "/home");
            Navigator.pop(context);
            Navigator.pop(context);
                // Navigator.canPop(context);
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                //   builder: (BuildContext context) {
                //     return HomePage();
                //   },
                // ), (_) => true);
              });
            }
//            Navigator.pop(context);
//            Navigator.pop(context);
//            if (viewModel.loading == true) {
//              showSuccessDialog(context, "Saved Successfully", "Success", () {
//                viewModel.refreshmainscreen();
//                Navigator.pop(context);
//              });
//            }

//
//                usropt = null;
//                branchopt = null;
//                selopt = null;
//                startt = 0;
//                usrNamedisplay = "";
//                brchNamedisplay = "All Branch";

//                Navigator.of(context).popUntil((route) => route.isFirst);
          },
          builder: (context, viewModel) {
            String blckdate = widget.id == 1
                ? viewModel.pendingTransactionDetailList[widget.pos].settledate
                : ((widget.id == 3 || widget.id == 4)
                    ? viewModel.pendingTransactionDetailList[widget.pos].duedate
                    :
//2
                    viewModel.pendingTransactionDetailList[widget.pos].periodto
                        .toString());
            String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
            print(tdata);
            var a="${blckdate} ${tdata}";
            String blckdateWithTIme=a.toString();
//            blckdateWithTIme = convertDateTimePtBR(blckdate).toString();
            print("blckdateWithTIme ${blckdateWithTIme}");

            final _itemGrp = viewModel.actionTakenAgainstwhomlist
                .map((grp) => MultiSelectItem<ActionTakenAgainstwhom>(
                    grp, grp.description))
                .toList();

            return Container(
                height: MediaQuery.of(context).size.height ,
                width: MediaQuery.of(context).size.width,
                child:
//                  padding: EdgeInsets.symmetric(horizontal: 10),
                  Material(
                      color: themeData.primaryColor,
                      borderRadius: BorderRadius.circular(5.0),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Form(
                            key: _formKey,
                            child: ListView(children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("Request Unblock ",
                                      style: BaseTheme.of(context).title),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.all(9),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 10),
                                    height: height * .20,
                                    width: width,
                                    decoration: BoxDecoration(
                                        // color: Colors.red,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible:
                                              widget.id == 3 || widget.id == 4,
                                          child: Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text("Trans No",
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          viewModel
                                                                      .pendingTransactionDetailList[
                                                                          widget
                                                                              .pos]
                                                                      .transno !=
                                                                  null
                                                              ? viewModel
                                                                  .pendingTransactionDetailList[
                                                                      widget
                                                                          .pos]
                                                                  .transno
                                                              : '',
                                                          style: TextStyle(
                                                              fontSize: 15)),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Text("Description",
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          viewModel
                                                                      .pendingTransactionDetailList[
                                                                          widget
                                                                              .pos]
                                                                      .description !=
                                                                  null
                                                              ? viewModel
                                                                  .pendingTransactionDetailList[
                                                                      widget
                                                                          .pos]
                                                                  .description
                                                              : '',
                                                          style: TextStyle(
                                                              fontSize: 15)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: widget.id == 1,
                                          child: Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text("Voucher No",
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          viewModel
                                                                      .pendingTransactionDetailList[
                                                                          widget
                                                                              .pos]
                                                                      .voucherno !=
                                                                  null
                                                              ? viewModel
                                                                  .pendingTransactionDetailList[
                                                                      widget
                                                                          .pos]
                                                                  .voucherno
                                                              : '',
                                                          style: TextStyle(
                                                              fontSize: 15)),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          "Voucher Date",
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          viewModel
                                                                      .pendingTransactionDetailList[
                                                                          widget
                                                                              .pos]
                                                                      .voucherdate !=
                                                                  null
                                                              ? viewModel
                                                                  .pendingTransactionDetailList[
                                                                      widget
                                                                          .pos]
                                                                  .voucherdate
                                                              : '',
//
                                                          style: TextStyle(
                                                              fontSize: 15)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: widget.id == 2,
                                          child: Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          "Account Name",
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          viewModel
                                                                      .pendingTransactionDetailList[
                                                                          widget
                                                                              .pos]
                                                                      .accname !=
                                                                  null
                                                              ? viewModel
                                                                  .pendingTransactionDetailList[
                                                                      widget
                                                                          .pos]
                                                                  .accname
                                                              : '',
                                                          style: TextStyle(
                                                              fontSize: 15)),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          "Account code",
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          viewModel
                                                                      .pendingTransactionDetailList[
                                                                          widget
                                                                              .pos]
                                                                      .acccode !=
                                                                  null
                                                              ? viewModel
                                                                  .pendingTransactionDetailList[
                                                                      widget
                                                                          .pos]
                                                                  .acccode
                                                              : '',
                                                          style: TextStyle(
                                                              fontSize: 15)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                        "Blockage Date ",
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                  ),
                                                  Flexible(
                                                    child: Text(blckdate,
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                        "Requested Person",
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                        viewModel.loginedUser,
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.5,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    "Requested Date & Time ",
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                              ),
                                              Flexible(
                                                child: Text(
                                                    _fileDate.format(datenw),

//                                                    BaseDates(DateTime.now()).dbformatWithTime,
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    //                            color: Colors.deepPurpleAccent,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    //                          child:  Padding(
                                    //                            padding: EdgeInsets.all(0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 2, bottom: 2),
                                          child: Row(
                                                children: [
                                                  Icon(
                                                Icons.people_alt_rounded,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                                  Text("Action Taken Against Whom"),
                                                ],
                                              ),
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: MultiSelectDialogField(
                                                confirmText: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      color: themeData
                                                          .primaryColorDark),
                                                ),
                                                cancelText: Text(
                                                  "CANCEL",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      color: themeData
                                                          .primaryColorDark),
                                                ),
                                                itemsTextStyle: TextStyle(
                                                    color:
                                                        themeData.accentColor),
                                                selectedItemsTextStyle:
                                                    TextStyle(
                                                        color: themeData
                                                            .accentColor),
                                                // unselectedColor: BaseColors.of(context).white,
                                                checkColor:
                                                    themeData.accentColor,
                                                backgroundColor: themeData
                                                    .scaffoldBackgroundColor,
                                                searchable: true,
                                                barrierColor:
                                                    themeData.primaryColorDark,
                                                initialValue:
                                                    selectedActionWhom,
                                                items: _itemGrp,
                                                title: Text(
                                                  "Action Taken Against Whom",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                selectedColor:
                                                    themeData.primaryColorDark,
                                                decoration: BoxDecoration(
                                                  color: themeData.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all(
                                                    color:
                                                        themeData.primaryColor,
                                                    width: 2,
                                                  ),
                                                ),
                                                buttonIcon: Icon(Icons
                                                    .keyboard_arrow_down_sharp),
                                                buttonText: Text(
                                                  "",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onSelectionChanged: (data) {
                                                  selectedActionWhom = data;
                                                  print(
                                                      "selectedActionWhom {selectedActionWhom}");
                                                },
                                                onConfirm: (data) {
                                                  selectedActionWhom = data;
                                                },
                                                validator: (data) {
                                                  if (data == null ||
                                                      data.isEmpty) {
                                                    return "Please select atleast one Name" ;
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

//                                  SizedBox(height: 8),
                                  Flexible(child: _ActionTaken("Action Taken")),
                                  SizedBox(height: 8),
                                  _ActualBlockReason(
                                      "Describe Actual Blocking Reason"),
                                  SizedBox(height: 8),
                                  _buildFilterButton(
                                      viewModel, blckdateWithTIme),
                                ],
                              ),
                            ]),
                          ))),
              );
          });
    }

//    if(widget.viewmodel.loading ==true){
//      showSuccessDialog(context, "Saved Successfully", "Success", () {
//        Navigator.pop(context);
//        Navigator.pop(context);
//      });
//  }
  }

  Widget _ActualBlockReason(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Icon(
              Icons.note_add,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                    labelText: title,
                    labelStyle:TextStyle(color: Colors.white),
                ),
                initialValue: "",
                onChanged: (val) => ActualBlockReason = val,
                onSaved: (val) => ActualBlockReason = val,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Describe Actual Blocking Reason';
                  }
                  return null;
                },
              ),
            ),
          ],
        ));
  }

  Widget _ActionTaken(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: TextFormField(
                maxLines: 2,
//          icon: Icons.warning_amber_outlined,
//         label : title,
              decoration: InputDecoration(
                labelText: title,
                  labelStyle:TextStyle(color: Colors.white),
              ),
                initialValue: "",
                onChanged: (val) => ActionTaken = val,
                onSaved: (val) => ActionTaken = val,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Action Taken';
                  }
                  return null;
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildFilterButton(
      TranUnblockReqViewmodel viewModel, String blckdateWithTIme) {
    ThemeData themedata = ThemeProvider.of(context);
    return Container(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onPressed: () {
          _submitForm(blockeddate: blckdateWithTIme, viewModel: viewModel);
        },
        child: Text(
          'Submit',
          style: BaseTheme.of(context).bodyMedium.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        color: themedata.primaryColorDark,
      ),
    );
  }

//  DateTime convertDateTimePtBR(String validade) {
//    DateTime parsedDate;
//    List<String> validadeSplit = validade.split('-');
//    if (validadeSplit.length > 1) {
//      String day = validadeSplit[0].toString();
//      String month = validadeSplit[1].toString();
//      String year = validadeSplit[2].toString();
//      parsedDate = DateTime.parse('2022-$month-$day');
//    }
//    return parsedDate;
//  }

  void _submitForm({String blockeddate, TranUnblockReqViewmodel viewModel}) {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      print('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      viewModel.onSave(
        actiontaken: ActionTaken,
        blockedreason: ActualBlockReason,
        notificationid:
            viewModel.pendingTransactionDetailList[widget.pos].notificationid,
        reftableid: viewModel.pendingTransactionDetailList[widget.pos].tableid,
        reftabledataid: viewModel.pendingTransactionDetailList[widget.pos].id,
        isblockedyn:
            viewModel.pendingTransactionDetailList[widget.pos].blockedyn,
        data: selectedActionWhom,
        blockeddate: blockeddate,
      );
    }
  }
}

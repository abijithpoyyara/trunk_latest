import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/da_detail_viewmodel.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/document_viewer_viewmodel.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/utils/app_snackbar.dart';
import 'package:redux/src/store.dart';

import '../document_approval_detail.dart';
import '../document_viewer.dart';

List<TransactionDetails> transList = [];
listfunc({TransactionDetails transact, bool select, bool value}) {
  select = value;
  if (value == false) {
    transList.remove(transact);
  } else {
    // transList.add(widget.transaction);
    transList.add(transact);
    return transList;
  }
}

mainTransFunc({bool select, List<TransactionDetails> transactionsList}) {
  if (select == false) {
    select = true;
    // isSelected = false;
    transList.clear();
    transList.addAll(transactionsList);
    // widget.viewModel.addTransList(trans: transactionsList);
  } else if (select = true) {
    transList.clear();
    select = false;
  }
}

class DocumentApprovalListItem extends StatefulWidget {
  const DocumentApprovalListItem({
    Key key,
    this.transaction,
    this.transactionType,
    this.viewModel,
    this.isSelected,
    this.branch,
    this.color,
    this.transactionList,
    this.branchId
  }) : super(key: key);
  final DocumentApprDetailViewModel viewModel;
  final TransactionDetails transaction;
  final TransactionTypes transactionType;
  final BranchList branch;
  final Color color;
  final List<TransactionDetails> transactionList;
  final bool isSelected;
  final int branchId;

  @override
  _DocumentApprovalListItem createState() => _DocumentApprovalListItem();
}

class _DocumentApprovalListItem extends State<DocumentApprovalListItem> {
  final GlobalKey<_DocumentApprovalListItem> dtlState =
      new GlobalKey<_DocumentApprovalListItem>();
  @override
  Widget build(BuildContext context) {
    BaseTheme textTheme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    bool _checked = false;
    bool colorFlag = false;
    Color color;

    @override
    void initState() {
      transList = [];
      super.initState();

    }

    // widget.viewModel.unreadList.forEach((element) {
    //   if (element.transid == widget.transaction.refTableDataId &&
    //       element.readstatusyn == "N") {
    //     color = colors.primaryColor.withOpacity(.4);
    //   }
    //   else {
    //     color = colors.primaryColor;
    //   }
    //   return color;
    // });
    log("Init executed"+widget.branchId.toString());
    return IntrinsicHeight(

        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Expanded(
              child: Card(
                  color: widget.color ?? colors.primaryColor,
                  // padding: EdgeInsets.only(left: 4, right: 4),
                  // margin: EdgeInsets.only(left: 12, right: 12),
                  child: InkWell(
                      onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => DocumentApprovalDetail(
                              branchId:widget.branchId,
                                branch: widget.branch,
                                subtypeId: widget.transactionType.subTypeId,
                                transactionDetails: widget.transaction),
                          ))
                              .then((value) async {
                            widget.viewModel.fetchUnreadList(
                                branchId:widget.branchId,
                                notificationId: widget.transactionType.optionId,
                                subtypeId: widget.transactionType.subTypeId);
                          }),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${widget.transaction.transNo}",
                                        style: textTheme.subhead1.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)) ??
                                    Text(""),
                                CheckBoxW(
                                  // key: dtlState,
                                  transactionList: widget.transactionList,
                                  isSelected: widget.isSelected,
                                  viewModel: widget.viewModel,
                                  transaction: widget.transaction,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                      widget.transaction.reference?.isEmpty ??
                                              true
                                          ? ""
                                          : BaseStringCase(
                                                  widget.transaction.reference)
                                              .sentenceCase,
                                      style: textTheme.subhead1.copyWith(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white)),
                                ),
                                widget.transaction.transDate != null
                                    ? Text(
                                        "${widget.transaction.transDate}",
                                        style: textTheme.subhead1.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),
                                      )
                                    : Text("")
                              ],
                            ),
                            if (widget.transaction.hasAttachments &&
                                (widget.transaction?.docCount ?? -1) > 0)
                              _ViewerButton(transaction: widget.transaction),
                            widget.transaction.hasAttachments &&
                                    (widget.transaction?.docCount ?? -1) > 0
                                ? SizedBox(height: 2.0)
                                : SizedBox(height: 4.0),
                            widget.transaction.hasAttachments &&
                                    (widget.transaction?.docCount ?? -1) > 0
                                ? SizedBox(height: 4.0)
                                : SizedBox(height: 12)
                          ])))),
        ]));
  }
}

@override
class _ViewerButton extends StatelessWidget
    with BaseStoreMixin<AppState, DocumentApprViewerViewModel> {
  final TransactionDetails transaction;

  const _ViewerButton({
    Key key,
    @required this.transaction,
  });

  @override
  Widget childBuilder(
      BuildContext context, DocumentApprViewerViewModel viewModel) {
    BaseColors colors = BaseColors.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          height: height * .06,
          width: width * .25,
          child: FlatButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(height * .25)),
              // padding: EdgeInsets.symmetric(vertical: 6,),
              onPressed: () {
                viewModel.onViewDocuments(transaction);
                BaseNavigate(
                    context,
                    // DocumentPreViewScreen(
                    //   transactionNo: transaction.transNo,
                    //   viewModel: viewModel,
                    // )
                    DocumentViewer(
                      transactionNo: transaction.transNo,
                      viewModel: viewModel,
                    ));
              },
              child: Row(children: <Widget>[
                Icon(
                  Icons.image_rounded,
                  size: 18,
                  color: ThemeProvider.of(context).primaryColorDark,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${transaction.docCount.toString() ?? 0}",
                  style: BaseTheme.of(context).smallMedium.copyWith(
                      color: ThemeProvider.of(context).primaryColorDark),
                )
              ])),
        ),
      ],
    );
  }

  @override
  DocumentApprViewerViewModel converter(Store store) =>
      DocumentApprViewerViewModel.fromStore(store);

  @override
  Widget showLoading({String loadingMessage, TextStyle style}) {
    return null;
  }
}

class CheckBoxW extends StatefulWidget {
  CheckBoxW({
    Key key,
    this.viewModel,
    this.transaction,
    this.isSelected,
    this.transactionList,
  }) : super(key: key);
  final DocumentApprDetailViewModel viewModel;
  final TransactionDetails transaction;
  final List<TransactionDetails> transactionList;
  bool isSelected;
  @override
  State<CheckBoxW> createState() => _CheckBoxWState();
}

class _CheckBoxWState extends State<CheckBoxW> {
  bool isChecked = false;
  bool isChecked2 = true;
  List<dynamic> data = [];
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    BaseColors colors = BaseColors.of(context);
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return themeData.dialogBackgroundColor;
      }
      return themeData.dialogBackgroundColor;
    }

    return
        // widget.isSelected == true ?
        Checkbox(
      checkColor: themeData.primaryColorDark,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.isSelected,
      onChanged: (bool value) {
        setState(() {
          widget.isSelected = value;
          if (value == false) {
            transList.remove(widget.transaction);
          } else {
            transList.add(widget.transaction);
            return transList;
          }
        });
        print("ylo${transList.length}");
        // print("${widget.viewModel.selectAll} select all");
      },
    );
  }
}

class _DAInputForm extends StatefulWidget {
  final DocumentApprDetailViewModel viewModel;
  final Function(ApprovalsTypes type, String remarks) onSaved;
  final TransactionDetails transactionDtl;

  const _DAInputForm(
      {Key key, this.viewModel, this.onSaved, this.transactionDtl})
      : super(key: key);

  @override
  __DAInputFormState createState() => __DAInputFormState();
}

class __DAInputFormState extends State<_DAInputForm> {
  final GlobalKey<FormState> inputFormKey = new GlobalKey<FormState>();

  String _password;
  String _remarks;

  BaseTheme style;

  @override
  Widget build(BuildContext context) {
    style = BaseTheme.of(context);
    return Form(
        key: inputFormKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: ThemeProvider.of(context).primaryColor,
                margin: EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: _TextInputField(
                      displayTitle: "Remarks",
                      hint: "Enter Remarks",
                      icon: Icons.description,
                      onSaved: (data) => _remarks = data),
                ),
              ),
              SizedBox(height: 12),
              Container(
                // padding:
                //     EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 6),
                height: MediaQuery.of(context).size.height * .14,
                color: ThemeProvider.of(context).primaryColor,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: widget.viewModel.approvalTypes.map((e) {
                      final bool reject = e.code == "REJECTED";

                      return Expanded(
                          child: Container(
                        margin: EdgeInsets.all(6),
                        child: _ApprovalButton(
                            color: reject
                                ? Colors.white
                                : ThemeProvider.of(context).primaryColorDark,
                            icon: reject ? Icons.delete_forever : Icons.check,
                            title: reject
                                ? Text(
                                    e.description.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ThemeProvider.of(context)
                                            .primaryColorDark),
                                  )
                                : Text(e.description.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                            onPressed: () {
                              if (performValidation(
                                  widget.viewModel.transList.first.maxLevelId,
                                  e.id)) {
                                widget.onSaved(e, _remarks);
                              } else {
                                AppSnackBar.of(context)
                                    .show("Please enter remarks" ?? "");
                              }
                            }),
                      ));
                    }).toList()),
              )
            ]));
  }

  bool performValidation(int bccId, int buttonId) {
    var form = inputFormKey.currentState;
    if (form.validate()) {
      form.save();
      bool commentMan = widget.viewModel
              .getDocConfigByType(bccId: bccId, approveorrejectid: buttonId)
              ?.isCommentMandatory ??
          false;
      print("commentMandry $bccId");
      return !(commentMan && _remarks.isEmpty);
    }
    return false;
  }
}

class _TextInputField extends StatelessWidget {
  final String initialValue;
  final String hint;
  final String displayTitle;
  final IconData icon;
  final Function(String val) validator;
  final Function(String val) onSaved;
  final bool isPassword;

  _TextInputField(
      {this.initialValue,
      this.hint,
      this.displayTitle,
      this.icon,
      this.isPassword = false,
      this.validator,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    BaseTheme _theme = BaseTheme.of(context);
    return TextFormField(
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        enabled: true,
        obscureText: isPassword,
        textInputAction: TextInputAction.done,
        initialValue: initialValue,
        autovalidate: false,
        validator: validator,
        keyboardType: TextInputType.text,
        minLines: isPassword ? 1 : 2,
        maxLines: isPassword ? 1 : 5,
        showCursor: true,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            hintText: hint,
            border: OutlineInputBorder(borderSide: BaseBorderSide()),
            labelText: displayTitle,
            labelStyle: _theme.textfieldLabel.copyWith(color: Colors.white),
            hintStyle: _theme.smallHint.copyWith(color: Colors.white),
//            icon: Icon(icon, color: kHintColor, size: 18),
            contentPadding: EdgeInsets.symmetric(vertical: 1)),
        onSaved: onSaved);
  }
}

class _ApprovalButton extends StatelessWidget {
  final Widget title;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;
  final TextStyle style;

  const _ApprovalButton(
      {Key key, this.title, this.color, this.icon, this.onPressed, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: color,
        ),
        margin: EdgeInsets.symmetric(horizontal: 2),
        child: FlatButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Icon(icon, color: color),
                  title
                ]),
            onPressed: onPressed,
            padding: EdgeInsets.all(14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BaseBorderSide(color: color)),
            splashColor: color.withOpacity(.4)));
  }
}

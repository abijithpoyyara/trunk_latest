import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_detail_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/da_detail_viewmodel.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/utils/app_snackbar.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/document_approval_model.dart';
import 'package:redstars/src/widgets/screens/document_approval/_partials/alert_message_dialog.dart';
import 'package:redstars/src/widgets/screens/document_approval/_partials/transaction_summary.dart';
import 'package:redstars/src/widgets/screens/document_approval/_views/success_dialog.dart';
import 'package:redstars/src/widgets/screens/document_approval/document_approval_relation.dart';

import '_partials/transaction_dtl.dart';

class DocumentApprovalDetail extends StatelessWidget
    with BaseViewMixin<AppState, DocumentApprDetailViewModel> {
  TransactionDetails transactionDetails;
  final int subtypeId;
  int branchId;
  BranchList branch;


  DocumentApprovalDetail(
      {Key key, @required this.transactionDetails, this.subtypeId,this.branchId,this.branch})
      : super(key: key);

  @override
  void init(Store<AppState> store, BuildContext context) {
    log("branch id at approval screen branchId $branchId");
    super.init(store, context);
    final selected = store.state.docApprovalState.detailState.selectedOption;
    final optionId = store.state.homeState.selectedOption.optionId;
    store.dispatch(setNotificationAsRead(
          branchId:branchId,
        optionId: optionId,
        transTableId: transactionDetails.refTableDataId,
        transId: transactionDetails.refTableId,
        notificationId: transactionDetails.optionId,
        subtypeId: subtypeId));
    if (selected.reportDtlFormat != null)
      store.dispatch(fetchDocumentDetails(
        transactionType: selected,
        transactionDetails: transactionDetails,
      ));
  }

  @override
  DocumentApprDetailViewModel converter(Store store) {
    return DocumentApprDetailViewModel.fromStore(store);
  }

  @override
  void onDidChange(DocumentApprDetailViewModel viewModel, context) {
    super.onDidChange(viewModel, context);
    // log("isTransactionSubmitted :"+viewModel.isTransactionSubmitted.toString());
    // log("documentApprovalFailure :"+viewModel.documentApprovalFailure.toString());
    if (viewModel.isTransactionSubmitted) {
      showSuccessDialog(context, viewModel);
      viewModel.clearState();
    }else if (viewModel.documentApprovalFailure == true){
      ///this dialog is for concurrency solution
      showFailureDialog(context, viewModel);
      viewModel.resetDocumentApprovalFailure();
    }
  }
  @override
  void onDispose(Store store) {
    print("dispose_called");
    store.dispatch(OnDisposeDetails());
    transactionDetails = null;
    // TODO: implement onDispose
    super.onDispose(store);
    }

  showFailureDialog(
      BuildContext context, DocumentApprDetailViewModel viewModel) async {
      await appShowChildDialog<bool>(
          context: context,
          child: AlertMessageDialog(
            title:
                "${viewModel.message.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
            message: "",
          ),
          barrierDismissible: true);

      Navigator.pop(context);

      TransactionTypes type = TransactionTypes(
          optionName: transactionDetails.optionName,
          optionId: transactionDetails.optionId,
          subTypeId: subtypeId,);

      viewModel.refreshPendingList(transactionType: type,branchId: branchId);
  }

  @override
  BaseAppBar appBarBuilder(
    String title,
    BuildContext context,
  ) {
    return BaseAppBar(
        title: Text('${transactionDetails.transNo}'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.access_time),
              tooltip: "View Relations",
              onPressed: () => BaseNavigate(context,
                  DocumentApprovalRelation(transaction: transactionDetails)))
        ]);
  }

  showSuccessDialog(
      BuildContext context, DocumentApprDetailViewModel viewModel) async {
    await appShowChildDialog<bool>(
        context: context,
        child: UpdateSuccessDialog(),
        barrierDismissible: true);
    // viewModel.onClear();
    Navigator.pop(context);

    TransactionTypes type = TransactionTypes(
        optionName: transactionDetails.optionName,
        optionId: transactionDetails.optionId,
        subTypeId: subtypeId);

    viewModel.refreshPendingList(transactionType: type,branchId: branchId);
  }

  @override
  Widget childBuilder(
      BuildContext context, DocumentApprDetailViewModel viewModel) {
    return _DocumentApprovalDtlBody(
        transactionDetails: transactionDetails,
        viewModel: viewModel,
        subtypeId: subtypeId,
        isSummaryApproval: viewModel.isSummaryApproval);
  }
}

class _DocumentApprovalDtlBody extends StatefulWidget {
  final TransactionDetails transactionDetails;
  final bool isSummaryApproval;
  final DocumentApprDetailViewModel viewModel;
  final int subtypeId;

  _DocumentApprovalDtlBody(
      {this.transactionDetails,
      this.viewModel,
      this.isSummaryApproval = true,
      this.subtypeId});

  @override
  _DocumentApprovalDtlBodyState createState() =>
      _DocumentApprovalDtlBodyState();
}

class _DocumentApprovalDtlBodyState extends State<_DocumentApprovalDtlBody> {
  final GlobalKey<TransactionDtlState> dtlState =
      new GlobalKey<TransactionDtlState>();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TransactionSummaryView(
                        reportHeader: widget.viewModel.reportSummaryFormat,
                        details: widget.transactionDetails.data,
                      ),
                      //  if (!widget.isSummaryApproval)
                      if (widget.viewModel.reportDtlFormat != null)
                        TransactionDtl(
                            key: dtlState,
                            reportHeader: widget.viewModel.reportDtlFormat,
                            reportData:
                                widget.viewModel.transactionApprDTL != null
                                    ? widget.viewModel.transactionApprDTL
                                    : List()),
                    ])),
          ),
          _DAInputForm(
              viewModel: widget.viewModel,
              transactionDtl: widget.transactionDetails,
              onSaved: (type, remarks) {
                List selectedDocs;
                if (!widget.isSummaryApproval)
                // if (true)
                {
                  selectedDocs = dtlState?.currentState?.submitData();
                  if (selectedDocs == null) {
                    AppSnackBar.of(context)
                        .show("Select a transaction to continue");
                  } else {
                    DocumentApprovalModel model = DocumentApprovalModel();
                    model.userRemarks = remarks;

                    widget.viewModel.approveDocument(
                        approvalsTypes: type,
                        approvalModel: model,
                        transactionDtl: widget.transactionDetails,
                        approvalStsId: type.id,
                        subtypeId: widget.subtypeId,
                        dtlApprovals: selectedDocs);
                  }
                  widget.viewModel.callWhenApprovedFunction();
                } else {
                  DocumentApprovalModel model = DocumentApprovalModel();
                  model.userRemarks = remarks;

                  widget.viewModel.approveDocument(
                      approvalModel: model,
                      transactionDtl: widget.transactionDetails,
                      approvalStsId: type.id,
                      reportFormatModel: widget.viewModel.reportDtlFormat,
                      subtypeId: widget.subtypeId,
                      dtlAppvl: widget.viewModel.transactionApprDTL,
                      dtlApprovals: selectedDocs);
                }
              })
        ],
      );
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
                                    'reject'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ThemeProvider.of(context)
                                            .primaryColorDark),
                                  )
                                : Text('approve'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                            onPressed: () {
                              if (performValidation(
                                  widget.transactionDtl.maxLevelId, e.id)) {
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

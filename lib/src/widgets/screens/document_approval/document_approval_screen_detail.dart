import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_detail_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/da_detail_viewmodel.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_transaction_dtl.dart';
import 'package:redstars/src/utils/app_snackbar.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/document_approval_model.dart';
import 'package:redstars/src/widgets/screens/document_approval/_partials/alert_message_dialog.dart';
import 'package:redstars/utility.dart';

import '_partials/document_approval_list_item.dart';

class DocumentApprovalScreenDetail extends StatefulWidget {
  final TransactionTypes transaction;
  final BranchList selectedBranch;
  final DocumentApprDetailViewModel viewModel;
  final Icon icon;
  final Widget appBar;
  final TransactionDetails transts;
  final int branchId;

  const DocumentApprovalScreenDetail({
    Key key,
    this.transaction,
    this.selectedBranch,
    this.icon,
    this.viewModel,
    this.appBar,
    this.transts,
    this.branchId
  }) : super(key: key);

  @override
  _DocumentApprovalScreenDetailState createState() =>
      _DocumentApprovalScreenDetailState();
}

class _DocumentApprovalScreenDetailState
    extends State<DocumentApprovalScreenDetail> with FireBaseNotificationMixin {
  FirebaseMessaging firebaseMessaging;


  String isDocInit;
  String doc_key;


  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, DocumentApprDetailViewModel>(
        onDidChange:
            (DocumentApprDetailViewModel viewModel, BuildContext context) {
          if (viewModel.isMultiTransactionSubmitted) {
            showSuccessDialog(context, "Saved Successfully", "Success", () {
              Navigator.pop(context);
            });
            viewModel.clearState();
          } else if (viewModel.documentApprovalFailure == true) {
            ///this dialog is given to solve concurrency issue
            showAlertMessageDialog(context, "",
                "${viewModel.message.replaceFirst("ERROR:", "") ?? "Transaction Already Taken"}",
                () {
              Navigator.of(context).pop();
            });
            viewModel.resetDocumentApprovalFailure();
          }
        },
        init: (store, context) async {
          store.dispatch(fetchPendingDocuments(
              transactionType: widget.transaction,
              branchId: widget.branchId,
              notificationId: widget.transaction.optionId,
              optionId: widget.transaction.optionId,
              subtypeId: widget.transaction.subTypeId));
          // store.dispatch(fetchUnreadNotificationList(
          //   notificationId: widget.transaction.optionId,
          // ));

          await BasePrefs.setString(
              BaseConstants.SCREEN_STATE_KEY, "MOBILE_DOC_APRVL_DETAIL");

          void checkAndAddMessageListener() async {
            print("Document Approval Detail Screen Listener Function.");
            doc_key =
                await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ?? "";
            isDocInit = await BasePrefs.getString('isDocDetailInit') ?? "";

            if (isDocInit == "") {
              await BasePrefs.setString("isDocDetailInit", "true");

              print("Document Approval Detail Screen Listener Initilised");
              FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
                doc_key =
                    await BasePrefs.getString(BaseConstants.SCREEN_STATE_KEY) ??
                        "";

                print(doc_key);

                if (doc_key == "MOBILE_DOC_APRVL_DETAIL") {
                  print("Document Approval Detail Screen Listener Calling.");

                  store.dispatch(fetchPendingDocuments(
                      transactionType: store.state.docApprovalState.detailState.selectedOption,
                      branchId: widget.branchId,
                      notificationId: widget.transaction.optionId,
                      optionId: widget.transaction.optionId,
                      subtypeId: widget.transaction.subTypeId));
                }
              });
            }
          }

          checkAndAddMessageListener();

        },
        converter: (store) => DocumentApprDetailViewModel.fromStore(store),
        builder: (context, viewModel) {
          return WillPopScope(
            onWillPop: popAndClear(),
            child: _PendingApprovalList(
              branchId: widget.branchId,
              branch: widget.selectedBranch,
              transactionType: widget.transaction,
              viewModel: viewModel,
            ),
          );
        },
        onDispose: (store) async{
          await BasePrefs.setString(BaseConstants.SCREEN_STATE_KEY, "MOBILE_DOC_APRVL");
          store.dispatch(OnDispose());

        }
        );
  }
}

popAndClear() {
  transList.clear();
}

class _PendingApprovalList extends StatefulWidget {
  final TransactionTypes transactionType;
  final DocumentApprDetailViewModel viewModel;
  final Icon icon;
  final BranchList branch;
  final Widget appBar;
  final List<TransactionDtlApproval> selectionReportData;
  int branchId;


  _PendingApprovalList({
    Key key,
    @required this.transactionType,
    @required this.viewModel,
    this.icon,
    this.branch,
    this.appBar,
    this.selectionReportData,
    this.branchId
  }) : super(key: key);

  @override
  __PendingApprovalListState createState() => __PendingApprovalListState();
}

class __PendingApprovalListState extends State<_PendingApprovalList>
    with FireBaseNotificationMixin {
  // final GlobalKey<__PendingApprovalListState> dtlState =
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    // registerForCallback();
    log("executed");
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    BaseColors colors = BaseColors.of(context);
    Color color;
    final transactionsList = widget.viewModel.transactionDtl ?? List();
    final header = widget.transactionType.reportSummaryFormat;
    return Scaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text("${widget.transactionType.optionName}"),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  // mainTransFunc(select: isSelected,
                  //   transactionsList: transactionsList
                  // );
                  if (isSelected == false) {
                    isSelected = true;
                    // isSelected = false;
                    transList.clear();
                    transList.addAll(transactionsList);
                    // widget.viewModel.addTransList(trans: transactionsList);
                  } else if (isSelected = true) {
                    transList.clear();
                    isSelected = false;
                  }
                });
              },
                child:
                    Text("Select All", style: TextStyle(color: Colors.white)))
          // IconButton(
          //   disabledColor: Colors.black,
          //   icon: Icon(Icons.search),
          //   onPressed: () {
          //
          //     // showSearch(
          //     //     context: context,
          //     //     delegate: SearchAppBar(widget.viewModel.transactionDtl));
          //   },
          // )  `SSAWS6890-=\7
        ],
      ),
      body: RefreshIndicator(
        color: themeData.primaryColor,
        onRefresh: () async {
          await widget.viewModel
              .refreshPendingList(transactionType: widget.transactionType,branchId: widget.branchId);
        },
            child: transactionsList.isNotEmpty && transactionsList != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: transactionsList.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          print("contains");
                          bool containsInList;
                              List<UnreadNotificationListModel>
                                  unreadContainsList;
                          unreadContainsList = widget.viewModel.unreadList
                              .where((element) =>
                                  element.transid ==
                                  transactionsList[index].refTableDataId)
                              .toList();
                          unreadContainsList.forEach((element) {
                            if (element.transid ==
                                        transactionsList[index]
                                            .refTableDataId &&
                                element.readstatusyn == "N") {
                              color = colors.secondaryDark.withOpacity(0.8);
                              transactionsList[index].color =
                                  colors.secondaryDark.withOpacity(0.8);
                            } else {
                              color = colors.primaryColor;
                              transactionsList[index].color =
                                  colors.primaryColor;
                            }
                            return color;
                          });

                          return DocumentApprovalListItem(
                            branch: widget.branch,
                            branchId: widget.branchId,
                            viewModel: widget.viewModel,
                            transactionList: transactionsList,
                            transaction: transactionsList[index],
                            transactionType: widget.transactionType,
                            isSelected: isSelected,
                            color: transactionsList[index].color,
                          );
                        }),
                  ),
                  _DAInputForm(
                      viewModel: widget.viewModel,
                      transList: widget.viewModel.transList,
                      // transactionDtl: widget.tra,
                      onSaved: (type, remarks) {
                        // if (!widget.isSummaryApproval)
                        if (true) {
                          // transList = dtlState.currentState.submitData();
                          if (transList == []) {
                            AppSnackBar.of(context)
                                .show("Select a transaction to continue");
                          } else {
                            DocumentApprovalModel model =
                                DocumentApprovalModel();
                            model.userRemarks = remarks;

                            transList.forEach((element) {
                                  widget.viewModel
                                      .setNotificationAsReadFunction(
                                      branchId: widget.branchId??widget.branch.id,
                                  optionId: widget.viewModel.optionId,
                                  transTableId: element.refTableDataId,
                                  transId: element.refTableId,
                                  notificationId: element.optionId,
                                          subtypeId:
                                              widget.transactionType.subTypeId);
                            });

                            widget.viewModel.multiApproveDocument(
                              selectionReportData:
                                  widget.viewModel.transactionApprDTL,
                              approvalModel: model,
                              approvalsTypes: type,
                              subTypeId: widget.transactionType.subTypeId,
                              approvalsTypesList:
                                  widget.viewModel.approvalTypes,
                              viewModel: widget.viewModel,
                              // transactionDtl: widget.transactionDetails,
                              approvalStsId: type.id,
                              // dtlApprovals: transList,
                            );
                            widget.viewModel.callWhenApprovedFunction();
                          }
                        } else {
                          /* DocumentApprovalModel model = DocumentApprovalModel();
                        model.userRemarks = remarks;

                        widget.viewModel.approveDocument(
                            approvalModel: model,
                            transactionDtl: widget.transactionDetails,
                            approvalStsId: type.id,
                            reportFormatModel: widget.viewModel.reportDtlFormat,
                            dtlAppvl: widget.viewModel.transactionApprDTL,
                            dtlApprovals: selectedDocs);*/
                        }
                      }),
                ],
              )
                : (transactionsList?.isEmpty ?? false) &&
                        (widget.viewModel.statusCode == 1)
                    ? _EmptyListView(
                message: "All Caught Up",
                icon: Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 50,
                ),
                      )
                    : Center(
                        child: BaseLoadingView(
                          message: "Loading",
              ),
                      )));
  }

  @override
  void onMessage(RemoteMessage message) {
    print("helloofdtrt");
    super.onMessage(message);
    widget.viewModel
        .refreshPendingList(transactionType: widget.transactionType,branchId: widget.branchId??widget.branch.id);
  }
}

class _EmptyListView extends StatelessWidget {
  final String message;
  final Widget icon;

  const _EmptyListView({Key key, this.message, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
                SizedBox(height: 4),
                Text(message,
                    style:
                        BaseTheme.of(context).bodyMedium.copyWith(fontSize: 18))
              ]))
    ]);
  }
}

class SearchAppBar extends SearchDelegate<TransactionDetails> {
  final List<TransactionDetails> transactions;

  SearchAppBar(this.transactions);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: ThemeProvider.of(context).accentColor),
        cursorColor: ThemeProvider.of(context).accentColor,
        inputDecorationTheme: InputDecorationTheme(
            focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: ThemeProvider.of(context).accentColor, width: 2.0)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: ThemeProvider.of(context).accentColor, width: 2.0)),
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: ThemeProvider.of(context).accentColor)),
            errorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: ThemeProvider.of(context).accentColor)),
            hintStyle: new TextStyle(
                fontFamily: 'Roboto', color: Colors.white, fontSize: 16)),
        primaryColor: ThemeProvider.of(context).primaryColor,
        primaryIconTheme: theme.primaryIconTheme
            .copyWith(color: ThemeProvider.of(context).accentColor, size: 12),
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            size: 20,
          ),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, size: 20),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final transactionsList = transactions.where((name) {
      final transNo = name.transNo != null ? name.transNo.toUpperCase() : "";

      final transDate =
          name.transDate != null ? name.transDate.toUpperCase() : "";
      final reference =
          name.reference != null ? name?.reference?.toUpperCase() : "";

      return transNo.contains(query.toUpperCase()) ||
          transDate.contains(query.toUpperCase()) ||
          reference.contains(query.toUpperCase());
    }).toList();
    return transactionsList.isNotEmpty && transactionsList != null
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: transactionsList.length ?? 0,
            itemBuilder: (BuildContext context, int index) =>
                // _PendingApprovalList())
                DocumentApprovalListItem(
                    transaction: transactionsList.elementAt(index)))
        : _EmptyListView(
            message: "No result",
            icon: Icon(Icons.remove_done,
                color: Colors.white.withOpacity(.70), size: 54));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final transactionsList = transactions.where((name) {
      final transNo = name.transNo != null ? name.transNo.toUpperCase() : "";

      final transDate =
          name.transDate != null ? name.transDate.toUpperCase() : "";
      final reference =
          name.reference != null ? name?.reference?.toUpperCase() : "";
      return transNo.contains(query.toUpperCase()) ||
          transDate.contains(query.toUpperCase()) ||
          reference.contains(query.toUpperCase());
    }).toList();

    return transactionsList.isNotEmpty && transactionsList != null
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: transactionsList.length ?? 0,
            itemBuilder: (BuildContext context, int index) =>
                DocumentApprovalListItem(
                    transaction: transactionsList.elementAt(index)))
        : _EmptyListView(
            message: "No result",
            icon: Icon(Icons.remove_done,
                color: Colors.white.withOpacity(.70), size: 54),
          );
  }
}

class _DAInputForm extends StatefulWidget {
  final DocumentApprDetailViewModel viewModel;
  final Function(ApprovalsTypes type, String remarks) onSaved;
  final TransactionDetails transactionDtl;
  final List<TransactionDetails> transList;
  const _DAInputForm(
      {Key key,
      this.viewModel,
      this.onSaved,
      this.transactionDtl,
      this.transList})
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
                              // widget.viewModel.isTransactionSubmitted = true;
                              widget.viewModel.useractionid = e.id;
                              print(e.id);
                              print(widget.viewModel.useractionid);

                              if (performValidation(
                                  transList.first.maxLevelId, e.id)) {
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

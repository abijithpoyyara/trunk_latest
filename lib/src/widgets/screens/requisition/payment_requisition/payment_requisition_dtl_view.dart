import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/res/values.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/actions/requisition/payment_requisition/payment_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/requisition/payment_requisition/payment_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/account_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/partials/lookup/account_lookup_field.dart';
import 'package:redstars/src/widgets/screens/requisition/partials/approval_button.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/partials/total_payables.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/payment_requisition_tax_view.dart';

final keyForm = GlobalKey<ApprovalButtonsState>();

class PaymentRequisitionDtlView extends StatefulWidget {
  final BCCModel transactionType;
  final TransTypeLookupItem transaction;
  final bool hasDtlList;
  final bool hasTaxRights;
  final PaymentRequisitionViewModel viewModel;
  final void Function({String remarks}) onSubmit;

  PaymentRequisitionDtlView(
      {Key key,
      this.transactionType,
      this.transaction,
      this.hasDtlList,
      this.viewModel,
      this.hasTaxRights,
      this.onSubmit})
      : super(key: key);

  @override
  _PaymentRequisitionDtlViewState createState() =>
      _PaymentRequisitionDtlViewState();
}

class _PaymentRequisitionDtlViewState extends State<PaymentRequisitionDtlView> {
  bool isTop = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, PaymentRequisitionViewModel>(
      // appBar: BaseAppBar(title: Text(widget.transactionType.description)),
      init: (store, con) {
        if (widget.transaction != null && widget.hasDtlList)
          store.dispatch(fetchTransactionListDetails(widget.transaction));
      },
      onDidChange: (viewModel, context) {
        print("Changed");
        if (viewModel.loadingStatus == LoadingStatus.error) {
          Future.delayed(
              kThemeAnimationDuration, viewModel.changeLoadingAction());
        }
        if (viewModel.isSaved)
          showSuccessDialog(
              context, "Payment requisition saved" + " successfully", "Success",
              () {
            viewModel.onClear();
            Navigator.pop(context);
          });
      },
      builder: (context, viewModel) {
        BaseTheme theme = BaseTheme.of(context);
        BaseColors colors = BaseColors.of(context);
        ThemeData themeData = ThemeProvider.of(context);

        // bool isTop=false;

        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: BaseAppBar(
            title: Text(widget.transactionType.description),
            actions: [
              if (viewModel.stockId == 0)
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      String message = viewModel.validateSave();
                      if (message != null && message.isEmpty) {
                        keyForm.currentState.onSubmit(context);
                      } else {
                        BaseSnackBar.of(context).show(message);
                      }
                    })
            ],
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
                bottom: isTop == false ? height * 0 : height * .19),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      // setState(() {
                      //   isTop = true;
                      // });
                      String message = viewModel.validateSave();
                      if (message != null && message.isEmpty) {
                        Navigator.push(
                          context,
                          BaseNavigate.slideUp(
                              ItemAttachmentView<AppState, ScanViewModel>(),
                              name: "/scan_view"),
                        );
                      } else {
                        BaseSnackBar.of(context).show(message);
                      }
                    },
                    heroTag: "attachments",
                    autofocus: true,
                    child: SvgPicture.asset(AppVectors.ic_attachment),
                  ),
                  SizedBox(height: 15),
                  if (!widget.hasDtlList && viewModel.stockId == 0)
                    FloatingActionButton(
                        backgroundColor: themeData.primaryColorDark,
                        onPressed: () {
                          // setState(() {
                          //   isTop = true;
                          // });
                          showItemAddSheet(context, viewModel: viewModel);
                        },
                        heroTag: "items",
                        autofocus: true,
                        child: SvgPicture.asset(AppVectors.addnew))
                ]),
          ),
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (viewModel.requisitionItems?.isNotEmpty)
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: viewModel.requisitionItems?.length ?? 0,
                            itemBuilder: (con, position) {
                              PaymentRequisitionDtlModel object =
                                  viewModel.requisitionItems[position];
                              return widget.hasDtlList
                                  ? ListItem(
                                      viewModel: viewModel,
                                      hasTaxRights: widget.hasTaxRights,
                                      requisitionModel: object,
                                      onClick: (selected) {},
                                    )
                                  : Dismissible(
                                      onDismissed: (direction) {
                                        viewModel.onRemoveItem(object);
                                      },
                                      background: Container(
                                        decoration:
                                            BoxDecoration(color: Colors.red),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: _buildDeleteButton(theme),
                                        ),
                                      ),
                                      secondaryBackground: DecoratedBox(
                                          decoration:
                                              BoxDecoration(color: Colors.red),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: _buildDeleteButton(
                                                        theme))
                                              ])),
                                      key: Key(object.ledger.aliasname),
                                      confirmDismiss: (direction) =>
                                          appChoiceDialog(
                                              message:
                                                  "Do you want to delete this record",
                                              context: con),
                                      child: ListItem(
                                          viewModel: viewModel,
                                          hasTaxRights: widget.hasTaxRights,
                                          requisitionModel: object,
                                          onClick: (selected) =>
                                              showItemAddSheet(con,
                                                  selected: selected,
                                                  viewModel: viewModel)));
                            })),
                    SizedBox(
                      height: 10,
                    ),
                    // if (viewModel.stockId != 0)
                    //   Wrap(
                    //     children: [
                    //       Container(
                    //           //  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*.25),
                    //           padding: EdgeInsets.symmetric(
                    //               vertical: 14, horizontal: 16),
                    //           decoration: BoxDecoration(
                    //             color: themeData.primaryColor,
                    //             //  border: Border.all(color: colors.selectedColor),
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               Expanded(
                    //                   //flex: 6,
                    //                   child: TextFormField(
                    //                 minLines:
                    //                     viewModel?.payDtlRemarks?.length > 40
                    //                         ? 3
                    //                         : 1,
                    //                 maxLines:
                    //                     viewModel?.payDtlRemarks.length > 40
                    //                         ? 4
                    //                         : 1,
                    //                 style: theme.body2.copyWith(
                    //                     fontSize: 14,
                    //                     color: themeData.accentColor
                    //                         .withOpacity(.7)),
                    //                 //vector: AppVectors.remarks,
                    //                 decoration: InputDecoration(
                    //                   labelStyle: theme.body2.copyWith(
                    //                       fontSize: 14,
                    //                       color: themeData.accentColor),
                    //                   hintStyle: theme.body2.copyWith(
                    //                       color: themeData.accentColor
                    //                           .withOpacity(.7)),
                    //                   hintText: "Remarks",
                    //                   labelText: "Remarks",
                    //                   icon:
                    //                       SvgPicture.asset(AppVectors.remarks),
                    //                 ),
                    //                 // onSaved: (val) => setState(() => _remarks = val),
                    //                 initialValue:
                    //                     viewModel?.payDtlRemarks ?? "",
                    //               )),
                    //               SizedBox(width: 4),
                    //               // Flexible(
                    //               //     flex: 1,
                    //               //     child: BaseRaisedRoundButton(
                    //               //       child: Icon(
                    //               //         Icons.check,
                    //               //         color: Colors.white,
                    //               //       ),
                    //               //       radius: 22,
                    //               //       backgroundColor: colors.greenColor,
                    //               //       onPressed: () {
                    //               //         onSubmit(context);
                    //               //       },
                    //               //     )),
                    //               SizedBox(width: 4),
                    //             ],
                    //           )),
                    //     ],
                    //   ),
                    if (viewModel.requisitionItems.isNotEmpty
                    // &&
                    // viewModel.payDtlRemarks.isEmpty
                    )
                      ApprovalButtons(
                          id: viewModel.stockId,
                          key: keyForm,
                          onSubmit: ({String remarks}) {
                            viewModel.saveRequisition(remarks: remarks);
                          }),
                  ],
                ),
              )
            else
              Flexible(child: emptyView(theme, colors)),
            if (viewModel.requisitionItems.isNotEmpty)
              Flexible(
                  child: TotalPayableCard(
                hasTax: widget.hasTaxRights,
                totalBudgetBooking:
                    BaseNumberFormat(number: viewModel.totalBooking)
                        .formatCurrency(),
                totalRequestedAmnt:
                    BaseNumberFormat(number: viewModel.totalRequestedAmount)
                        .formatCurrency(),
                vatAmount: BaseNumberFormat(number: viewModel.vatAmount)
                    .formatCurrency(),
                withHoldingTaxAmount:
                    BaseNumberFormat(number: viewModel.withHoldingTaxAmount)
                        .formatCurrency(),
              )),
          ]),
        );
      },
      converter: (store) => PaymentRequisitionViewModel.fromStore(store),
    );
  }

  void showItemAddSheet(BuildContext context,
      {PaymentRequisitionViewModel viewModel,
      PaymentRequisitionDtlModel selected}) {
    showModalBottomSheet<void>(
        context: context,
        builder: (_context) =>
            ItemView(viewModel: viewModel, selected: selected),
        isScrollControlled: true);
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

  Widget emptyView(BaseTheme theme, BaseColors colors) {
    return Align(
      heightFactor: 3.5,
      child: Container(
          child: Column(
        children: <Widget>[
          SvgPicture.asset(AppVectors.emptyBox
              // color: Colors.black,
              ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      )),
    );
  }
}

// class PaymentRequisitionDtlView extends StatelessWidget {
//   final BCCModel transactionType;
//   final TransTypeLookupItem transaction;
//   final bool hasDtlList;
//   final bool hasTaxRights;
//   final bool isTop;
//   final PaymentRequisitionViewModel viewModel;
//
//   const PaymentRequisitionDtlView({
//     Key key,
//     @required this.transactionType,
//     this.transaction,
//     this.viewModel,
//     this.hasDtlList,
//     this.hasTaxRights,
//     this.isTop,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseView<AppState, PaymentRequisitionViewModel>(
//       appBar: BaseAppBar(title: Text(transactionType.description)),
//       // init: (store, con) {
//       //   if (transaction != null && hasDtlList)
//       //     store.dispatch(fetchTransactionListDetails(transaction));
//       // },
//       onDidChange: (viewModel, context) {
//         if (viewModel.loadingStatus == LoadingStatus.error) {
//           Future.delayed(
//               kThemeAnimationDuration, viewModel.changeLoadingAction());
//         }
//         // if
//         // (viewModel.isSaved)
//         // showSuccessDialog(
//         //     context, "Payment requisition saved", "successfully", "Success",
//         //         () {
//         //       viewModel.onClear();
//         //       Navigator.pop(context);
//         //     });
//       },
//       builder: (context, viewModel) {
//         BaseTheme theme = BaseTheme.of(context);
//         BaseColors colors = BaseColors.of(context);
//         // bool isTop=false;
//
//         double height = MediaQuery.of(context).size.height;
//         double width = MediaQuery.of(context).size.width;
//         return Scaffold(
//           // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
//           floatingActionButton: Padding(
//             padding: EdgeInsets.only(bottom: isTop == false ? 0 : height * .19),
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   FloatingActionButton(
//                     onPressed: () {
//                       !isTop;
//                       Navigator.push(
//                         context,
//                         BaseNavigate.slideUp(
//                             ItemAttachmentView<AppState, ScanViewModel>(),
//                             name: "/scan_view"),
//                       );
//                     },
//                     heroTag: "attachments",
//                     autofocus: true,
//                     child: SvgPicture.asset(AppVectors.ic_attachment),
//                   ),
//                   SizedBox(height: 15),
//                   if (!hasDtlList)
//                     FloatingActionButton(
//                         backgroundColor: theme.colors.selectedColor,
//                         onPressed: () {
//                           !isTop;
//                           showItemAddSheet(context, viewModel: viewModel);
//                         },
//                         heroTag: "items",
//                         autofocus: true,
//                         child: SvgPicture.asset(AppVectors.addnew))
//                 ]),
//           ),
//           body:
//               Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//             if (viewModel.requisitionItems?.isNotEmpty)
//               Flexible(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Flexible(
//                         child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: viewModel.requisitionItems?.length ?? 0,
//                             itemBuilder: (con, position) {
//                               PaymentRequisitionDtlModel object =
//                                   viewModel.requisitionItems[position];
//                               return hasDtlList
//                                   ? ListItem(
//                                       viewModel: viewModel,
//                                       hasTaxRights: hasTaxRights,
//                                       requisitionModel: object,
//                                       onClick: (selected) {},
//                                     )
//                                   : Dismissible(
//                                       onDismissed: (direction) {
//                                         viewModel.onRemoveItem(object);
//                                       },
//                                       background: Container(
//                                         decoration:
//                                             BoxDecoration(color: Colors.red),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 8),
//                                           child: _buildDeleteButton(theme),
//                                         ),
//                                       ),
//                                       secondaryBackground: DecoratedBox(
//                                           decoration:
//                                               BoxDecoration(color: Colors.red),
//                                           child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: <Widget>[
//                                                 Padding(
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         horizontal: 8),
//                                                     child: _buildDeleteButton(
//                                                         theme))
//                                               ])),
//                                       key: Key(object.ledger.aliasname),
//                                       confirmDismiss: (direction) =>
//                                           appChoiceDialog(
//                                               message:
//                                                   "Do you want to delete this record",
//                                               context: con),
//                                       child: ListItem(
//                                           viewModel: viewModel,
//                                           hasTaxRights: hasTaxRights,
//                                           requisitionModel: object,
//                                           onClick: (selected) =>
//                                               showItemAddSheet(con,
//                                                   selected: selected,
//                                                   viewModel: viewModel)));
//                             })),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     if (viewModel.requisitionItems.isNotEmpty)
//                       ApprovalButtons(onSubmit: ({String remarks}) {
//                         viewModel.saveRequisition(remarks: remarks);
//                       }),
//                   ],
//                 ),
//               )
//             else
//               emptyView(theme, colors),
//             if (viewModel.requisitionItems.isNotEmpty)
//               TotalPayableCard(
//                 hasTax: hasTaxRights,
//                 totalBudgetBooking:
//                     BaseNumberFormat(number: viewModel.totalBooking)
//                         .formatCurrency(),
//                 totalRequestedAmnt:
//                     BaseNumberFormat(number: viewModel.totalRequestedAmount)
//                         .formatCurrency(),
//                 vatAmount: BaseNumberFormat(number: viewModel.vatAmount)
//                     .formatCurrency(),
//                 withHoldingTaxAmount:
//                     BaseNumberFormat(number: viewModel.withHoldingTaxAmount)
//                         .formatCurrency(),
//               ),
//           ]),
//         );
//       },
//       converter: (store) => PaymentRequisitionViewModel.fromStore(store),
//     );
//   }
//
//   void showItemAddSheet(BuildContext context,
//       {PaymentRequisitionViewModel viewModel,
//       PaymentRequisitionDtlModel selected}) {
//     showModalBottomSheet<void>(
//         context: context,
//         builder: (_context) =>
//             ItemView(viewModel: viewModel, selected: selected),
//         isScrollControlled: true);
//   }
//
//   Widget _buildDeleteButton(BaseTheme theme, {bool reverse = false}) {
//     return Row(
//       textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
//       children: <Widget>[
//         Icon(Icons.delete_sweep, color: Colors.white),
//         SizedBox(width: 15),
//         Text(
//           "Delete",
//           style: theme.title.copyWith(color: Colors.white),
//         )
//       ],
//     );
//   }
//
//   Widget emptyView(BaseTheme theme, BaseColors colors) {
//     return Align(
//       heightFactor: 3.5,
//       child: Container(
//           child: Column(
//         children: <Widget>[
//           SvgPicture.asset(AppVectors.emptyBox
//               // color: Colors.black,
//               ),
//         ],
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//       )),
//     );
//   }
// }

class ListItem extends StatelessWidget {
  final PaymentRequisitionDtlModel requisitionModel;
  final ValueSetter<PaymentRequisitionDtlModel> onClick;
  final bool hasTaxRights;
  final PaymentRequisitionViewModel viewModel;

  const ListItem(
      {Key key,
      this.requisitionModel,
      this.onClick,
      this.hasTaxRights,
      this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: themeData.scaffoldBackgroundColor),
          child: Container(
              // margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: themeData.primaryColor,
                  border: Border(
                      bottom: BaseBorderSide(color: themeData.primaryColor))),
              child: IntrinsicHeight(
                  child: Row(children: [
                Expanded(
                    child: FlatButton(
                        padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                        onPressed: () => onClick(requisitionModel),
                        child: IntrinsicHeight(
                            child: Row(children: <Widget>[
                          Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Text(requisitionModel.ledger.aliasname ?? "",
                                    style: theme.subhead1Bold),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0),
                                    child: Text(
                                        requisitionModel?.ledger?.groupname ??
                                            "",
                                        style: theme.body))
                              ])),
                          SizedBox(width: 22),
                          Column(children: <Widget>[
                            Text("Amount", style: theme.body),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 8.0),
                                child: Text(
                                  BaseNumberFormat(
                                          number: requisitionModel.amount)
                                      .formatCurrency(),
                                  // "${requisitionModel.amount}",
                                  style: theme.subhead1Bold
                                      .copyWith(color: themeData.accentColor),
                                ))
                          ]),
                          SizedBox(width: 4)
                        ])))),
                if (hasTaxRights && viewModel.stockId == 0)
                  Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 12,
                      ),
                      child: BaseRaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor:
                            requisitionModel?.taxes?.isEmpty ?? true
                                ? Colors.green
                                : themeData.primaryColorDark,
                        onPressed: () async {
                          var taxedItem =
                              await Navigator.push<PaymentRequisitionDtlModel>(
                            context,
                            BaseNavigate.slideUp(PaymentRequisitionTaxView(
                                requisitionModel: requisitionModel)),
                          );
                          if (taxedItem != null) viewModel.onAdd(taxedItem);
                        },
                        child: Text(requisitionModel?.taxes?.isEmpty ?? true
                            ? "Add Tax"
                            : "View Tax"),
                      ))
              ]))),
        ),
      ],
    );
  }
}

class ItemView extends StatefulWidget {
  final PaymentRequisitionViewModel viewModel;
  final PaymentRequisitionDtlModel selected;

  const ItemView({
    Key key,
    this.viewModel,
    this.selected,
  }) : super(key: key);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  double amount;
  AccountLookupItem selectedItem;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    amount = widget?.selected?.amount ?? 0;
    selectedItem = widget?.selected?.ledger;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData style = ThemeProvider.of(context);
    BaseTheme theme = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;

    return new AnimatedPadding(
        padding: EdgeInsets.zero,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: new Container(
            height: height * .96,
            color: style.scaffoldBackgroundColor,
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          buildTitleWidget(context, "Add New Item"),
                          _buildItemField(),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: _NumberField(
                                      amount: amount,
                                      onSaved: (val) =>
                                          setState(() => amount = val))),
                            ],
                          ),
                          SizedBox(height: height * .04),
                          Container(
                            height: height * .07,
                            margin:
                                EdgeInsets.only(left: height * .05, right: 8),
                            child: BaseRaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    widget.viewModel
                                        .onAdd(PaymentRequisitionDtlModel(
                                      ledger: selectedItem,
                                      amount: amount,
                                      itemGroup: selectedItem.groupname,
                                    ));
                                    Navigator.pop(context);
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: style.primaryColorDark,
                                child: Text("ADD")),
                          )
                        ])))));
  }

  Widget buildTitleWidget(BuildContext context, String title) {
    final textTitleTheme = BaseTheme.of(context);
    return Container(
        height: MediaQuery.of(context).size.height * .095,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          color: ThemeProvider.of(context).primaryColor,
        ),
        child: Row(children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: BaseColors.of(context).white,
              ),
              iconSize: 22,
              onPressed: () => Navigator.pop(context)),
          Expanded(
              flex: 5,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(title,
                      style: textTitleTheme.subhead1Bold.copyWith(
                          fontSize: 20, fontWeight: FontWeight.w500)))),
        ]));
  }

  Widget _buildItemField() {
    double height = MediaQuery.of(context).size.height;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        // padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(right: height * .02),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: AccountLookupTextField(
                      flag: 0,
                      hint: "Select Items",
                      isVector: true,
                      displayTitle: "Ledger",
                      initialValue: selectedItem,
                      onChanged: (val) {
                        setState(() {
                          selectedItem = val;
                          widget.viewModel.onItemPaymentBudget(val);
                        });
                      }))
            ]));
  }
}

class _NumberField extends StatefulWidget {
  final double amount;
  final ValueSetter<double> onSaved;

  const _NumberField({Key key, this.amount, this.onSaved}) : super(key: key);

  @override
  __NumberFieldState createState() => __NumberFieldState();
}

class __NumberFieldState extends State<_NumberField> {
  double amount;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    amount = widget?.amount ?? 0;
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeProvider.of(context);
    BaseTheme style = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(left: height * .05, right: 8),
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
//            IconButton(
//              color: amount > 0 ? Colors.red : Colors.grey,
//              icon: Icon(Icons.arrow_back_ios),
//              onPressed: () {
//                if (amount > 0)
//                  setState(() {
//                    amount--;
//                    _controller =
//                        TextEditingController(text: amount.toString());
//                  });
//              },
//            ),

            Expanded(
              child: TextFormField(
                  cursorColor: theme.accentColor.withOpacity(.70),
                  decoration: InputDecoration(
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.accentColor.withOpacity(.70))),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.accentColor.withOpacity(.70))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.accentColor.withOpacity(.70))),
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: theme.accentColor.withOpacity(.70))),
                      errorStyle: style.subhead1.copyWith(
                          fontSize: 14,
                          color: theme.accentColor.withOpacity(.70)),
                      labelStyle: style.subhead1Bold
                          .copyWith(color: theme.accentColor.withOpacity(.70)),
                      hintText: "Enter Amount",
                      hintStyle: style.subhead1Bold
                          .copyWith(color: theme.accentColor.withOpacity(.70))),
                  textAlign: TextAlign.left,
                  style: BaseTheme.of(context).subhead1Bold,
                  minLines: 1,
                  controller: _controller,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  validator: (String val) => (val.isEmpty)
                      ? "Please enter amount"
                      : double.parse(val) > 0
                          ? null
                          : "Amount cannot be 0",
                  onChanged: (val) =>
                      setState(() => amount = double.parse(val)),
                  onSaved: (String val) => widget.onSaved(double.parse(val))
//                      setState(() => quantity = int.parse(val))
                  ),
            ),
            SizedBox(width: 8),
//            IconButton(
//              icon: Icon(
//                Icons.arrow_forward_ios,
//                color: Colors.green,
//              ),
//              onPressed: () {
//                setState(() {
//                  amount += 1;
//                  _controller = TextEditingController(text: amount.toString());
//                });
//              },
//            )
          ],
        ));
    ;
  }
}

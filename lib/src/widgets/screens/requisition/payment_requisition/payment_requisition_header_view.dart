import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/requisition/payment_requisition/payment_requisition_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/requisition/payment_requisition/payment_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/widgets/partials/lookup/service_lookup_field.dart';
import 'package:redstars/src/widgets/partials/lookup/trans_type_lookup_field.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/partials/payment_requisition_transaction_list_view.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/payment_requisition_dtl_view.dart';
import 'package:redstars/utility.dart';

class PaymentRequisitionHeaderView extends StatelessWidget {
  const PaymentRequisitionHeaderView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, PaymentRequisitionViewModel>(
      init: (store, _cont) => {store.dispatch(fetchInitialData())},
      converter: (store) => PaymentRequisitionViewModel.fromStore(store),
      builder: (con, viewModel) => Scaffold(
          appBar: BaseAppBar(
            title: Text("Payment Requisition"),
            actions: [
              IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () {
                    BaseNavigate(
                        context,
                        PAYListView(
                          viewmodel: viewModel,
                        ));
                  })
            ],
          ),
          body: PaymentRequisitionHeaderForm(viewModel: viewModel)),
      onDispose: (store) => store.dispatch(OnClearAction()),
    );
  }
}

class PaymentRequisitionHeaderForm extends StatelessWidget {
  final PaymentRequisitionViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PaymentRequisitionHeaderForm({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BCCModel _selectedTransType;
    BCCModel _selectedServiceType;
    bool hasRequestRights, hasDtlRights, hasTaxRights;
    DateTime withinDate;
    TransTypeLookupItem _selectedTransaction;
    PaymentRequisitionHdrModel paymentHdr;
    paymentHdr = viewModel.paymentHdr;
    _selectedTransType = paymentHdr.transactionType;
    _selectedServiceType = paymentHdr.requestFrom;
    withinDate = paymentHdr.settleWithin;
    _selectedTransaction = paymentHdr.transNo;
    if (_selectedTransType != null) {
      List<String> reqRights = viewModel.requestProcessType
              ?.firstWhere((element) {
                return element.code.contains(_selectedTransType.code);
              }, orElse: () => null)
              ?.extra
              ?.split(",") ??
          [];

      hasRequestRights = reqRights != null && reqRights.isNotEmpty
          ? reqRights[1] == "Y"
          : false;
      hasDtlRights = reqRights != null && reqRights.isNotEmpty
          ? reqRights[0] == "N"
          : true;
      hasTaxRights = reqRights != null && reqRights.isNotEmpty
          ? reqRights[2] == "Y"
          : false;
    } else {
      hasRequestRights = false;
      hasDtlRights = true;
//  withinDate = DateTime.now();
    }
    BaseTheme style = BaseTheme.of(context);

    return Container(
      //   color: style.colors.secondaryColor,
      child: Form(
          key: formKey,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Column(children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      _buildDialogFieldWithVectorList(context,
                          vector: AppVectors.transactionType,
                          initialVal: paymentHdr.transactionType,
                          isMandatory: true,
                          title: "Transaction Type",
                          icon: Icons.receipt,
                          list: viewModel.requestTransactionTypes,
                          onChanged: (val) {
                        onValueChange(PaymentRequisitionHdrModel()
                            .copyWith(transactionType: val));
                      }),
                      _buildDateField(
                          initialVal: paymentHdr.transDate,
                          isMandatory: false,
                          title: "Transaction Date",
                          icon: Icons.date_range,
                          isEnabled: !(viewModel.isTransactionSelected &&
                              hasDtlRights),
                          onChanged: (val) => onValueChange(
                              paymentHdr.copyWith(transDate: val))),
                      if (_selectedTransType?.extra?.isNotEmpty ?? false)
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TransTypeLookupTextField(
                                vector: AppVectors.transaction,
                                initialValue: paymentHdr.transNo,
                                flag: _selectedTransType.code,
                                hint: "Tap select data",
                                displayTitle: "Transaction No" + " * ",
                                onChanged: (val) {
                                  onValueChange(
                                      paymentHdr.copyWith(transNo: val));
                                  if (hasDtlRights)
                                    viewModel.getTransactionDetails(val);
                                })),
                      if (!hasRequestRights)
                        _buildTextField(
                          paymentHdr.paidTo,
                          true,
                          "Paid To",
                          Icons.account_circle,
                          isEnabled: !(viewModel.isTransactionSelected &&
                              hasDtlRights),
                          onChanged: (val) =>
                              onValueChange(paymentHdr.copyWith(paidTo: val)),
                          onSaved: (val) =>
                              onValueSave(paymentHdr.copyWith(paidTo: val)),
                        ),
                      if (hasRequestRights)
                        _buildRequestFromDialogField(context,
                            vector: AppVectors.requestFrom,
                            initialVal: paymentHdr.requestFrom,
                            isMandatory: true,
                            isEnabled: !(viewModel.isTransactionSelected &&
                                hasDtlRights),
                            title: "Request From",
                            icon: Icons.person,
                            list: viewModel.requesters, onChanged: (val) {
                          onValueChange(paymentHdr.copyWith(requestFrom: val));
                        }),
                      if (hasRequestRights)
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: ServiceLookupTextField(
                                vector: BaseVectors.appearance,
                                isEnabled: !(viewModel.isTransactionSelected &&
                                        hasDtlRights) &&
                                    _selectedServiceType != null,
                                initialValue: paymentHdr.requestFromName,
                                flag: _selectedServiceType?.id ?? -1,
                                hint: "Tap select data",
                                displayTitle: "Requested Name" + " * ",
                                onChanged: (val) {
                                  onValueChange(paymentHdr.copyWith(
                                      requestFromName: val));
                                })),
                      _buildDialogField(context,
                          initialVal: paymentHdr.paymentType,
                          vector: AppVectors.paymentType,
                          isVector: false,
                          isMandatory: true,
                          title: "Payment Type",
                          icon: Icons.payment,
                          list: viewModel.paymentTypes, onChanged: (val) {
                        var date;
                        var settlement = viewModel.settlements?.first;
                        if (val.code.contains("NORMAL")) {
                          date = DateTime.now()
                              .add(Duration(days: settlement.constantValue));
                        }
                        onValueChange(paymentHdr.copyWith(
                            paymentType: val, settleWithin: date));
                      }),
                      BaseTextField(
                        displayTitle: "Requested Amt.",
                        initialValue:
                            (paymentHdr?.requestAmount ?? 0.00).toString(),
                      ),
                      _buildDateField(
                          initialVal: paymentHdr.settleWithin,
                          isMandatory: false,
                          title: "Settle Within",
                          icon: Icons.date_range,
                          isEnabled: true,
                          onChanged: (val) {
                            onValueChange(
                                paymentHdr.copyWith(settleWithin: val));
                          })
                    ]))),
                _buildButtons(
                    context, viewModel.paymentHdr, hasDtlRights, hasTaxRights),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                )
              ]))),
    );
  }

  void onValueChange(PaymentRequisitionHdrModel model) {
    formKey.currentState?.save();
    viewModel.setField(model);
  }

  void onValueSave(PaymentRequisitionHdrModel model) {
    viewModel.setField(model);
  }

  Widget _buildTextField(
    String initialVal,
    bool isMandatory,
    String title,
    IconData icon, {
    bool isEnabled = true,
    ValueSetter<String> onChanged,
    ValueSetter<String> onSaved,
  }) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: BaseTextField(
        isEnabled: isEnabled,
        onEditingCompleted: onChanged,
        hint: "Type to enter data",
        validator: (String val) =>
            (isMandatory && val.isEmpty) ? "Please enter $title " : null,
        displayTitle: title + (isMandatory ? " * " : ""),
        initialValue: initialVal,
        onSaved: onSaved,
        vector: AppVectors.requestFrom,
//        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDialogField(
    BuildContext context, {
    BCCModel initialVal,
    bool isMandatory,
    bool isEnabled = true,
    String title,
    IconData icon,
    String vector,
    bool isVector,
    List<BCCModel> list,
    ValueSetter<BCCModel> onChanged,
    ValueSetter<BCCModel> onSaved,
    ValueSetter<BCCModel> onValidator,
  }) {
    BaseTheme style = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(top: 10),
      //   color: style.colors.secondaryColor,
      child: BaseDialogField<BCCModel>(
        height: height * .26,
        isChangeHeight: true,
        vector: vector,
        hint: "Tap select data",
        icon: icon ?? Icons.dashboard,
        list: list,
        initialValue: initialVal,
        isEnabled: isEnabled,
        listBuilder: (val, pos) => DocumentTypeTile(
          selected: true,
          //isVector: true,,
          vector: vector,
          icon: Icons.list,
          title: val.description,
          onPressed: () => Navigator.pop(context, val),
        ),
        fieldBuilder: (selected) => Text(
          selected.description,
          style: BaseTheme.of(context).textfield,
          textAlign: TextAlign.start,
        ),
        validator: (val) =>
            (isMandatory && val == null) ? "Please select $title " : null,
        displayTitle: title + (isMandatory ? " * " : ""),

        onSaved: onSaved,
        onChanged: onChanged,
//          onSaved: (val) {}
      ),
    );
  }

  Widget _buildRequestFromDialogField(
    BuildContext context, {
    BCCModel initialVal,
    bool isMandatory,
    bool isEnabled = true,
    String title,
    IconData icon,
    String vector,
    bool isVector,
    List<BCCModel> list,
    ValueSetter<BCCModel> onChanged,
    ValueSetter<BCCModel> onSaved,
    ValueSetter<BCCModel> onValidator,
  }) {
    BaseTheme style = BaseTheme.of(context);
    return Container(
      padding: EdgeInsets.only(top: 10),
      //    color: style.colors.secondaryColor,
      child: BaseDialogField<BCCModel>(
        isChangeHeight: false,
        vector: vector,
        hint: "Tap select data",
        icon: icon ?? Icons.dashboard,
        list: list,
        initialValue: initialVal,
        isEnabled: isEnabled,
        listBuilder: (val, pos) => DocumentTypeTile(
          selected: true,
          //isVector: true,,
          vector: vector,
          icon: Icons.list,
          title: val.description,
          onPressed: () => Navigator.pop(context, val),
        ),
        fieldBuilder: (selected) => Text(
          selected.description,
          style: BaseTheme.of(context).textfield,
          textAlign: TextAlign.start,
        ),
        validator: (val) =>
            (isMandatory && val == null) ? "Please select $title " : null,
        displayTitle: title + (isMandatory ? " * " : ""),

        onSaved: onSaved,
        onChanged: onChanged,
//          onSaved: (val) {}
      ),
    );
  }

  Widget _buildDialogFieldWithVectorList(
    BuildContext context, {
    BCCModel initialVal,
    bool isMandatory,
    bool isEnabled = true,
    String title,
    IconData icon,
    String vector,
    bool isVector,
    List<BCCModel> list,
    ValueSetter<BCCModel> onChanged,
    ValueSetter<BCCModel> onSaved,
    ValueSetter<BCCModel> onValidator,
  }) {
    BaseTheme style = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    List<String> listVectors = [
      AppVectors.localPurchaseOrder,
      AppVectors.importPurchaseOrder,
      AppVectors.direct,
      AppVectors.advance,
      AppVectors.transactionType,
      AppVectors.paymentType,
      AppVectors.transaction
    ];
    return Container(
      padding: EdgeInsets.only(top: 10),
      //   color: style.colors.secondaryColor,
      child: BaseDialogField<BCCModel>(
        height: height * .53,
        isChangeHeight: true,
        vector: vector,
        hint: "Tap select data",
        icon: icon ?? Icons.dashboard,
        list: list,
        initialValue: initialVal,
        isEnabled: isEnabled,
        listBuilder: (val, pos) => DocumentTypeTile(
          selected: true,
          //isVector: true,,
          vector: listVectors[pos],
          icon: Icons.list,
          title: val.description,
          onPressed: () => Navigator.pop(context, val),
        ),
        fieldBuilder: (selected) => Text(
          selected.description,
          style: BaseTheme.of(context).textfield,
          textAlign: TextAlign.start,
        ),
        validator: (val) =>
            (isMandatory && val == null) ? "Please select $title " : null,
        displayTitle: title + (isMandatory ? " * " : ""),

        onSaved: onSaved,
        onChanged: onChanged,
//          onSaved: (val) {}
      ),
    );
  }

  Widget _buildDateField({
    DateTime initialVal,
    bool isMandatory,
    bool isEnabled,
    String title,
    IconData icon,
    ValueSetter<DateTime> onChanged,
    ValueSetter<DateTime> onSaved,
  }) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: BaseDatePicker(
            vector: AppVectors.calenderSettlement,
            isEnabled: isEnabled,
            hint: "Tap to select date",
            initialValue: initialVal ?? DateTime.now(),
            displayTitle: title + (isMandatory ? " * " : ""),
            validator: (val) =>
                (isMandatory && val == null) ? "Please select $title" : null,
            onSaved: (val) => {}));
  }

  Widget _buildButtons(
      BuildContext context,
      PaymentRequisitionHdrModel paymentHdr,
      bool hasDtlRights,
      bool hasTaxRights) {
    return Container(
        height: MediaQuery.of(context).size.height * .07,
        width: MediaQuery.of(context).size.width,
        child: BaseRaisedButton(
          backgroundColor: ThemeProvider.of(context).primaryColorDark,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            final FormState form = formKey.currentState;
            if (form.validate()) {
              form.save();

              BaseNavigate(
                  context,
                  PaymentRequisitionDtlView(
                    viewModel: viewModel,
                    transactionType: paymentHdr.transactionType,
                    transaction: paymentHdr.transNo,
                    hasDtlList: hasDtlRights,
                    hasTaxRights: hasTaxRights,
                  ));
            }
          },
          child: Text(viewModel.stockId == 0 ? 'PROCEED' : 'View List'),
        ));
  }
}

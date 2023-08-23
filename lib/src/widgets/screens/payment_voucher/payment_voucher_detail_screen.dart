import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/payment_voucher/payment_voucher_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/payment_voucher/payment_voucher_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/widgets/partials/lookup/service_lookup_field.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/_model/payment_requisition_model.dart';
import 'package:redstars/src/widgets/screens/requisition/payment_requisition/payment_requisition_dtl_view.dart';
import 'package:redstars/utility.dart';

import 'model/payment_voucher_model.dart';

class PaymentVoucherHeaderView extends StatelessWidget {
  final String title;
  const PaymentVoucherHeaderView({this.title, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, PaymentVoucherViewModel>(
      appBar: BaseAppBar(title: Text(title)),
      init: (store, _cont) {
        store.dispatch(fetchVoucherInitialData());
        // store.dispatch(fetchInitialData());
      },
      converter: (store) => PaymentVoucherViewModel.fromStore(store),
      builder: (con, viewModel) =>
          PaymentRequisitionHeaderForm(viewModel: viewModel),
      // onDispose: (store) => store.dispatch(OnClearAction()),
    );
  }
}

class PaymentRequisitionHeaderForm extends StatelessWidget {
  final PaymentVoucherViewModel viewModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PaymentRequisitionHeaderForm({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BCCModel _selectedTransType;
    BCCModel _selectedServiceType;
    bool hasRequestRights, hasDtlRights, hasTaxRights;
    DateTime withinDate;
    TransTypeLookupItem _selectedTransaction;
    PaymentVoucherHdrModel paymentHdr;
    paymentHdr = viewModel.paymentHdr;
    // _selectedTransType = paymentHdr?.transactionType;
    // _selectedServiceType = paymentHdr?.requestFrom;
    // withinDate = paymentHdr?.settleWithin;
    _selectedTransaction = paymentHdr?.transNo;
//     if (_selectedTransType != null) {
//       List<String> reqRights = viewModel.requestProcessType
//               ?.firstWhere((element) {
//                 return element.code.contains(_selectedTransType.code);
//               }, orElse: () => null)
//               ?.extra
//               ?.split(",") ??
//           [];
//
//       hasRequestRights = reqRights != null && reqRights.isNotEmpty
//           ? reqRights[1] == "Y"
//           : false;
//       hasDtlRights = reqRights != null && reqRights.isNotEmpty
//           ? reqRights[0] == "N"
//           : true;
//       hasTaxRights = reqRights != null && reqRights.isNotEmpty
//           ? reqRights[2] == "Y"
//           : false;
//     } else {
//       hasRequestRights = false;
//       hasDtlRights = true;
// //  withinDate = DateTime.now();
//     }
    BaseTheme style = BaseTheme.of(context);
    //  var flag;
    //  ServiceLookupItem onNameContain(String name)  {
    //  flag=  paymentHdr.names.contains(name) ;
    //  paymentHdr.requestFromName
    // paymentHdr.names.indexOf(name)
    //
    //  }

    return Container(
      color: style.colors.secondaryColor,
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
                      _buildDateField(
                        initialVal: paymentHdr?.insDate,
                        isMandatory: false,
                        isEnabled: false,
                        title: "Date",
                        icon: Icons.date_range,

                        // isEnabled:
                        //     !(viewModel.isTransactionSelected && hasDtlRights),
                        // onChanged: (val) =>
                        // onValueChange(
                        // paymentHdr.copyWith(transDate: val))
                      ),
                      _buildRequestFromDialogField(context,
                          vector: AppVectors.requestFrom,
                          initialVal: paymentHdr?.paymentTypes,
                          isMandatory: true,
                          // isEnabled: !(viewModel.isTransactionSelected &&
                          //     hasDtlRights),
                          title: "Payment Type",
                          icon: Icons.person,
                          list: viewModel?.paymentTypes, onChanged: (val) {
                        onValueChange(paymentHdr.copyWith(paymentTypes: val));
                      }),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        color: style.colors.secondaryColor,
                        child: BaseDialogField<BCCModel>(
                          isChangeHeight: false,
                          vector: AppVectors.transaction,
                          hint: "Tap select data",
                          displayTitle: "Instrument Types",
                          // icon: icon ?? Icons.dashboard,
                          list: viewModel?.instrumentTypes,
                          initialValue: paymentHdr?.instrumentTypes,
                          isEnabled: true,
                          listBuilder: (val, pos) => DocumentTypeTile(
                            selected: true,
                            subTitle: val.code,
                            //isVector: true,,
                            // vector: vector,
                            icon: Icons.list,
                            title: val.name,
                            vector: AppVectors.transaction,
                            onPressed: () => Navigator.pop(context, val),
                          ),
                          fieldBuilder: (selected) => Text(
                            selected.name,
                            style: BaseTheme.of(context).textfield,
                            textAlign: TextAlign.start,
                          ),
                          // validator: (val) =>
                          // (isMandatory && val == null) ? "Please select $title " : null,
                          // displayTitle: title + (isMandatory ? " * " : ""),
                          //
                          // onSaved: onSaved,
                          // onChanged: onChanged,
//          onSaved: (val) {}
                        ),
                      ),
                      // if (hasRequestRights)
                      _buildRequestFromDialogField(
                        context,
                        vector: AppVectors.requestFrom,
                        initialVal: paymentHdr?.voucherTypes,
                        isMandatory: true,
                        // isEnabled:
                        // !(viewModel.isTransactionSelected && hasDtlRights),
                        title: "Paid From",
                        icon: Icons.person,
                        list: viewModel?.voucherTypes,
                        //     onChanged: (val) {
                        //   onValueChange(paymentHdr.copyWith(requestFrom: val));
                        // }
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: ServiceLookupTextField(
                              isEnabled: true,
                              vector: BaseVectors.appearance,
                              // isEnabled: !(viewModel.isTransactionSelected &&
                              //         hasDtlRights) &&
                              //     _selectedServiceType != null,
                              initialValue: paymentHdr?.requestFromName,
                              flag: 20,
                              hint: "Tap select data",
                              displayTitle: "Name" + " * ",
                              onChanged: (val) {
                                onValueChange(
                                    paymentHdr.copyWith(requestFromName: val));
                              })),

                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: ServiceLookupTextField(
                              isEnabled: true,
                              vector: BaseVectors.appearance,
                              // isEnabled: !(viewModel.isTransactionSelected &&
                              //         hasDtlRights) &&
                              //     _selectedServiceType != null,
                              initialValue: paymentHdr?.requestFromName,
                              flag: 10,
                              hint: "Tap select data",
                              displayTitle: "Cashier" + " * ",
                              onChanged: (val) {
                                onValueChange(
                                    paymentHdr.copyWith(requestFromName: val));
                              })),

                      Container(
                        padding: EdgeInsets.only(top: 10),
                        color: style.colors.secondaryColor,
                        child: BaseDialogField<BCCModel>(
                          isChangeHeight: false,
                          vector: AppVectors.transaction,
                          hint: "Tap select data",
                          displayTitle: "pAID",
                          // icon: icon ?? Icons.dashboard,
                          list: viewModel?.requesters,
                          initialValue: paymentHdr?.paidToType,
                          isEnabled: true,
                          listBuilder: (val, pos) => DocumentTypeTile(
                            selected: true,
                            subTitle: val.toString(),
                            //isVector: true,,
                            // vector: vector,
                            icon: Icons.list,
                            title: val.description,
                            vector: AppVectors.transaction,
                            onPressed: () => Navigator.pop(context, val),
                          ),
                          fieldBuilder: (selected) => Text(
                            selected.description,
                            style: BaseTheme.of(context).textfield,
                            textAlign: TextAlign.start,
                          ),
                          // validator: (val) =>
                          // (isMandatory && val == null) ? "Please select $title " : null,
                          // displayTitle: title + (isMandatory ? " * " : ""),
                          //
                          // onSaved: onSaved,
                          // onChanged: onChanged,
//          onSaved: (val) {}
                        ),
                      ),
                      //  if (hasRequestRights)
                      _buildRequestFromDialogField(
                        context,
                        vector: AppVectors.requestFrom,
                        initialVal: paymentHdr?.paidToType,
                        isMandatory: true,
                        // isEnabled: !(view
                        // Model.isTransactionSelected &&
                        // hasDtlRights),
                        title: "PaidTo Type",
                        icon: Icons.person,
                        list: viewModel?.requesters,
                        //     onChanged: (val) {
                        //   onValueChange(paymentHdr.copyWith(requestFrom: val));
                        // }
                      ),

                      _buildTextField(
                        paymentHdr?.referenceNo,
                        true,
                        "Reference No",
                        Icons.account_circle,
                        isEnabled: false,
                        // onChanged: (val) =>
                        //     onValueChange(paymentHdr.copyWith(paidTo: val)),
                        // onSaved: (val) =>
                        //     onValueSave(paymentHdr.copyWith(paidTo: val)),
                      ),
                      _buildTextField(
                        paymentHdr?.referenceNo,
                        true,
                        "Instrument  No",
                        Icons.account_circle,
                        // isEnabled:
                        //  !(viewModel.isTransactionSelected && hasDtlRights),
                        // onChanged: (val) =>
                        //     onValueChange(paymentHdr.copyWith(paidTo: val)),
                        // onSaved: (val) =>
                        //     onValueSave(paymentHdr.copyWith(paidTo: val)),
                      ),
                      _buildTextField(
                        paymentHdr?.referenceNo,
                        true,
                        "Paid To",
                        Icons.account_circle,
                        // isEnabled:
                        //  !(viewModel.isTransactionSelected && hasDtlRights),
                        // onChanged: (val) =>
                        //     onValueChange(paymentHdr.copyWith(paidTo: val)),
                        // onSaved: (val) =>
                        //     onValueSave(paymentHdr.copyWith(paidTo: val)),
                      ),
                      _buildTextField(
                        paymentHdr?.referenceNo,
                        true,
                        "Balance",
                        Icons.account_circle,
                        isEnabled: false,
                        // onChanged: (val) =>
                        //     onValueChange(paymentHdr.copyWith(paidTo: val)),
                        // onSaved: (val) =>
                        //     onValueSave(paymentHdr.copyWith(paidTo: val)),
                      ),
                      _buildTextField(
                        "jhgg",
                        // paymentHdr?.referenceNo,
                        true,
                        "Total Amount",
                        Icons.account_circle,
                        isEnabled: false,
                        // onChanged: (val) =>
                        //     onValueChange(paymentHdr.copyWith(paidTo: val)),
                        // onSaved: (val) =>
                        //     onValueSave(paymentHdr.copyWith(paidTo: val)),
                      ),
                      _buildDateField(
                        initialVal: paymentHdr?.insDate,
                        isMandatory: false,
                        isEnabled: false,
                        title: "Instrument Date",
                        icon: Icons.date_range,
                        // isEnabled:
                        //     !(viewModel.isTransactionSelected && hasDtlRights),
                        // onChanged: (val) =>
                        // onValueChange(
                        // paymentHdr.copyWith(transDate: val))
                      ),
                    ]))),
                // _buildButtons(
                //     context, viewModel.paymentHdr, hasDtlRights, hasTaxRights),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                )
              ]))),
    );
  }

  void onValueChange(PaymentVoucherHdrModel model) {
    formKey.currentState.save();
    viewModel.setField(model);
  }

  // void onValueSave(PaymentRequisitionHdrModel model) {
  //   viewModel.setField(model);
  // }

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
      color: style.colors.secondaryColor,
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
      color: style.colors.secondaryColor,
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
      color: style.colors.secondaryColor,
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
          backgroundColor: BaseColors.of(context).selectedColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            final FormState form = formKey.currentState;
            if (form.validate()) {
              form.save();

              BaseNavigate(
                  context,
                  PaymentRequisitionDtlView(
                    transactionType: paymentHdr?.transactionType,
                    transaction: paymentHdr.transNo,
                    hasDtlList: hasDtlRights,
                    hasTaxRights: hasTaxRights,
                  ));
            }
          },
          child: Text('PROCEED'),
        ));
  }
}

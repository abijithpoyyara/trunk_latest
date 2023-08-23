import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/requisition/payment_requisition/payment_requestion_viewmodel.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';

class PaymentFilterDialog extends StatefulWidget {
  final PaymentRequisitionViewModel viewModel;
  final PVFilterModel model;
  const PaymentFilterDialog({Key key, this.viewModel, this.model})
      : super(key: key);

  @override
  _PaymentFilterDialogState createState() => _PaymentFilterDialogState(model);
}

class _PaymentFilterDialogState extends State<PaymentFilterDialog> {
  PVFilterModel model;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  BCCModel reqstType;

  _PaymentFilterDialogState(this.model);
  @override
  void initState() {
    reqstType = model?.transactionType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<BCCModel> reqstTypeList = widget.viewModel.requestTransactionTypes
        // ignore: unnecessary_statements
        .where((element) => (element?.description == "Local Purchase Order" ||
                element?.description == "Import Purchase Order")
            // element?.typebcccode?.contains("Import Purchase Order" );
            )
        .toList();
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
          color: themedata.primaryColor,
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Filter ", style: BaseTheme.of(context).title),
                      SizedBox(height: 8),
                      _buildDateField("Date From ", model?.fromDate,
                          (val) => model?.fromDate = val),
                      _buildDateField("Date To ", model?.toDate,
                          (val) => model?.toDate = val),
                      _searchField("Req.No."),
                      SizedBox(height: 8),
                      _amtFrom("Amt From"),
                      SizedBox(height: 8),
                      _amtTo("Amt To"),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BaseDialogField<BCCModel>(
                            height: height * .53,
                            displayTitle: "Transaction Types",
                            isChangeHeight: true,
                            // vector: vector,
                            hint: "Tap select data",
                            // icon: icon ?? Icons.dashboard,
                            list: reqstTypeList,
                            initialValue: reqstType,
                            isEnabled: true,
                            listBuilder: (val, pos) => DocumentTypeTile(
                                  selected: true,
                                  //isVector: true,,
                                  // vector: listVectors[pos],
                                  icon: Icons.list,
                                  title: val.description,
                                  onPressed: () => Navigator.pop(context, val),
                                ),
                            fieldBuilder: (selected) => Text(
                                  selected.description,
                                  style: BaseTheme.of(context).textfield,
                                  textAlign: TextAlign.start,
                                ),
                            onSaved: (val) {
                              setState(() {
                                model.transactionType = val;
                              });
                              val = reqstType;
                            },
                            onChanged: (val) {
                              setState(() {
                                model.transactionType = val;
                              });
                              val = reqstType;
                            }
//          onSaved: (val) {}
                            ),
                      ),
                      SizedBox(height: 8),
                      _buildFilterButton(),
                    ],
                  )))),
    ));
  }

  Widget _buildDateField(
      String title, DateTime initialDate, Function(DateTime) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: BaseDatePicker(
        isVector: true,
        hint: title,
        icon: Icons.calendar_today,
        displayTitle: title,
        initialValue: initialDate,
        autovalidate: true,
        onChanged: onChanged,
        validator: (val) => (val == null) ? "Please select date" : null,
      ),
    );
  }

  Widget _searchField(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          displayTitle: title,
          initialValue: "",
          onChanged: (val) => model?.reqNo = val,
          onSaved: (val) => model?.reqNo = val,
          autovalidate: false,
        ));
  }

  Widget _amtFrom(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          icon: Icons.money,
          displayTitle: title,
          initialValue: (model?.amountFrom ?? ""),
          //model?.amountFrom.toString(),
          onChanged: (val) => model?.amountFrom = val,
          onSaved: (val) => model?.amountFrom = val,
          autovalidate: false,
        ));
  }

  Widget _amtTo(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          displayTitle: title,
          icon: Icons.money,
          initialValue: (model?.amountTo ?? ""),
          onChanged: (val) => model?.amountTo = val,
          onSaved: (val) => model?.amountTo = val,
          autovalidate: false,
        ));
  }

  Widget _buildFilterButton() {
    ThemeData themedata = ThemeProvider.of(context);
    return Container(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onPressed: () {
          _submitForm();
        },
        child: Text(
          'Show Result',
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

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      print('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      widget.viewModel.onFilter(model);
      widget.viewModel.onSubmitCall(model);
      print(model);
      Navigator.pop(context, model);
    }
  }
}

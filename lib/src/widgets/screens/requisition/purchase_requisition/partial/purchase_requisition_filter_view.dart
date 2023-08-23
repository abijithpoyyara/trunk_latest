import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/requisition/purchase_requisition/purchase_requestion_viewmodel.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';

class PurchaseFilterDialog extends StatefulWidget {
  final PurchaseRequisitionViewModel viewModel;
  final PVFilterModel model;

  const PurchaseFilterDialog({Key key, this.viewModel, this.model})
      : super(key: key);

  @override
  _PurchaseFilterDialogState createState() => _PurchaseFilterDialogState(model);
}

class _PurchaseFilterDialogState extends State<PurchaseFilterDialog> {
  PVFilterModel model;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _PurchaseFilterDialogState(this.model);

  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
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
                      _buildFilterButton()
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
      widget.viewModel.onSubmit(model);
      Navigator.pop(context, model);
    }
  }
}

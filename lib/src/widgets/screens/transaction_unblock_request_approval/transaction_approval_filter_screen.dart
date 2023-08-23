import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request_approval/transaction_unblock_request_approval_viewmodel.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';

class TransactionReqApprovalFilter extends StatefulWidget {
  final TransactionUnblockReqApprlViewModel viewModel;
  final PVFilterModel model;
  final Function() onSubmit;
  final int reportFormatId;
  final String filterTitle1;
  final int id;
  final int optionIdFromBranchBlock;

  const TransactionReqApprovalFilter(
      {Key key,
      this.viewModel,
      this.model,
      this.onSubmit,
      this.reportFormatId,
      this.filterTitle1,
      this.id,
      this.optionIdFromBranchBlock})
      : super(key: key);

  @override
  _TransactionReqApprovalFilterState createState() =>
      _TransactionReqApprovalFilterState(model);
}

class _TransactionReqApprovalFilterState
    extends State<TransactionReqApprovalFilter> {
  PVFilterModel model;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _TransactionReqApprovalFilterState(this.model);

  @override
  Widget build(BuildContext context) {
    ThemeData themedata = ThemeProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                      _buildDateField("Request Date From ", model?.fromDate,
                          (val) => model?.fromDate = val),
                      _buildDateField("Request Date To ", model?.toDate,
                          (val) => model?.toDate = val),
                      _searchField("Request.No."),
                      SizedBox(height: 8),
                      _transNo(widget.filterTitle1),
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
           initialValue: (model?.reqNo ?? ""),
          onChanged: (val) => model?.reqNo = val,
          onSaved: (val) => model?.reqNo = val,
          autovalidate: false,
        ));
  }

  Widget _transNo(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          initialValue: (model?.transNo ?? ""),
          displayTitle: title,
          icon: Icons.money,
          // initialValue: (model?.transNo ?? ""),
          onChanged: (val) => model?.transNo = val,
          onSaved: (val) => model?.transNo = val,
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
     // widget.viewModel.listByFilter(model, widget.id, widget.reportFormatId);
      print(model);
      Navigator.pop(context, model);
    }
  }
}

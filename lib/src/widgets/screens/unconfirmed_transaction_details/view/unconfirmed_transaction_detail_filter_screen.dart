import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/unconfirmed_transaction_details/unconfirmed_transaction_details_viewmodel.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/model/unconfirmed_filter.dart';

class UnconfirmedTransactionFilter extends StatefulWidget {
  final UnConfirmedTransactionDetailViewModel viewModel;
  final UnConfirmedFilterModel model;
  final Function() onSubmit;
  final int reportFormatId;
  final String filterTitle1;
  final int id;

  const UnconfirmedTransactionFilter(
      {Key key,
      this.viewModel,
      this.model,
      this.onSubmit,
      this.reportFormatId,
      this.filterTitle1,
      this.id})
      : super(key: key);

  @override
  _UnconfirmedTransactionFilterState createState() =>
      _UnconfirmedTransactionFilterState(model);
}

class _UnconfirmedTransactionFilterState
    extends State<UnconfirmedTransactionFilter> {
  UnConfirmedFilterModel model;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _UnconfirmedTransactionFilterState(this.model);

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
                      Visibility(
                        visible: false,
                        child: Container(
                        child: BaseDialogField<BCCModel>(
                          height: height * .53,
                          displayTitle: "Transaction",
                          //vector: vector,
                          hint: "Tap select data",
                          isChangeHeight: true,
                          // icon: icon ?? Icons.dashboard,
                          list: widget.viewModel.transOptionTypes,
                          initialValue: model?.optionCode ??
                              widget.viewModel.transOptionTypes[0],
                          isEnabled: true,
                          listBuilder: (val, pos) => DocumentTypeTile(
                            selected: true,
                            //isVector: true,,
                            //  vector: listVectors[pos],
                            icon: Icons.list,
                            title: val.description,
                            onPressed: () => Navigator.pop(context, val),
                          ),
                          fieldBuilder: (selected) => Text(
                            selected.description,
                            style: BaseTheme.of(context).textfield,
                            textAlign: TextAlign.start,
                          ),
                          autoValidate: true,
                          // validator: (val) => (isMandatory && val == null)
                          //     ? "Please select $title "
                          //     : null,
                          // displayTitle: title + (isMandatory ? " * " : ""),

                          onSaved: (val) {
                            model.optionCode = val;
                          },
                          onChanged: (val) {
                            model.optionCode = val;
                          },
//          onSaved: (val) {}
                        ),
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
      widget.viewModel.onChangeUnconfirmedFilter(model);
      widget.viewModel.onUserSelect(model);
      print(model.fromDate);
      print(model.toDate);
      print(model.optionCode);
      Navigator.pop(context, model);
    }
  }
}

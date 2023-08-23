import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/requisition/stock_requisition/stock_requestion_viewmodel.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/requisition/stock_requisition/model/stock_filter_model.dart';

class SRFilterDialog extends StatefulWidget {
  final StockRequisitionViewModel viewModel;
  final SRFilterModel model;

  const SRFilterDialog({Key key, this.viewModel, this.model}) : super(key: key);

  @override
  _SRFilterDialogState createState() => _SRFilterDialogState(model);
}

class _SRFilterDialogState extends State<SRFilterDialog> {
  SRFilterModel model;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _SRFilterDialogState(this.model);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
          color: themeData.primaryColor,
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
              padding: EdgeInsets.zero,
              //const EdgeInsets.symmetric(vertical: 16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Filter ", style: BaseTheme.of(context).title),
                      SizedBox(height: 8),
                      _buildDateField("Start Date ", model?.fromDate,
                          (val) => model.fromDate = val),
                      _buildDateField("End Date ", model?.toDate,
                          (val) => model?.toDate = val),
                      _buildLocationField(
                        "To Location",
                        model?.locObj,
                      ),
                      SizedBox(
                        height: 8,
                      ),
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
          validator: (val) => (val == null) ? "Please select date" : null),
    );
  }

  Widget _buildLocationField(
    String title,
    StockLocation selectedLocation,
  ) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: BaseDialogField<StockLocation>(
        // height: height * .26,
        // isChangeHeight: true,
        //vector: ,
        hint: "Tap select data",
        icon: Icons.add_location_alt_outlined,
        list: widget.viewModel.destinationLocations,
        initialValue: model?.locObj,
        isEnabled: true,
        listBuilder: (val, pos) => DocumentTypeTile(
          selected: true,
          //isVector: true,,
          // vector: vector,
          icon: Icons.list,
          title: val.name,
          onPressed: () => Navigator.pop(context, val),
        ),
        fieldBuilder: (selected) => Text(
          selected.name,
          style: BaseTheme.of(context).textfield,
          textAlign: TextAlign.start,
        ),
        displayTitle: "Locations",

        onSaved: (val) {
          model.locObj = val;
        },
        onChanged: (val) {
          model.locObj = val;
        },
//          onSaved: (val) {}
      ),
      // LocationLookupTextField(
      //   hint: title,
      //   flag: 0,
      //   displayTitle: title,
      //   initialValue: selectedLocation,
      //   onChanged: (val) => model?.location = val,
      //   vector: AppVectors.requestFrom,
      // ),
    );
  }

  Widget _searchField(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          displayTitle: title,
          initialValue: "",
          onChanged: (value) => model?.transNo = value,
          onSaved: (value) => model?.transNo = value,
          autovalidate: false,
        ));
  }

  Widget _buildFilterButton() {
    ThemeData themeData = ThemeProvider.of(context);
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
                color: themeData.accentColor,
              ),
        ),
        color: themeData.primaryColorDark,
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    // if (!form.validate()) {
    //   print('Form is not valid!  Please review and correct.');
    // } else {
    form.save();
    widget.viewModel?.onSRFilter(model);
    widget.viewModel?.onSubmit(model);
    Navigator.pop(context, model);
  }
}

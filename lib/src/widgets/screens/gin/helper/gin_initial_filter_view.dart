import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/gin/gin_view_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/widgets/partials/lookup/supplier_lookup_field.dart';

class GINInitialFilterDialog extends StatefulWidget {
  final GINViewModel viewModel;
  final GINFilterModel ginInitialModel;

  const GINInitialFilterDialog({Key key, this.viewModel, this.ginInitialModel})
      : super(key: key);

  @override
  _GINInitialFilterDialogState createState() =>
      _GINInitialFilterDialogState(ginInitialModel);
}

class _GINInitialFilterDialogState extends State<GINInitialFilterDialog> {
  GINFilterModel ginInitialModel;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _GINInitialFilterDialogState(this.ginInitialModel);

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
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Filter ", style: BaseTheme.of(context).title),
                      SizedBox(height: 8),
                      _buildDateField("Start Date ", ginInitialModel?.fromDate,
                          (val) => ginInitialModel?.fromDate = val),
                      _buildDateField("End Date ", ginInitialModel?.toDate,
                          (val) => ginInitialModel?.toDate = val),
                      _buildSupplierField(
                        "Supplier",
                        ginInitialModel?.supplier,
                        (val) => ginInitialModel?.supplier = val,
                      ),
                      _searchField("Trans No"),
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

  Widget _buildSupplierField(
    String title,
    SupplierLookupItem selectedSupplier,
    Function(SupplierLookupItem) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SupplierLookupTextField(
        hint: title,
        flag: 0,
        displayTitle: title,
        initialValue: selectedSupplier,
        onChanged: onChanged,
        //   (val) => ginInitialModel?.supplier = val,
        // onSaved: (val) => ginInitialModel?.supplier = val,
        vector: AppVectors.requestFrom,
      ),
    );
  }

  Widget _searchField(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
          displayTitle: title,
          initialValue: ginInitialModel?.transNo ?? "",
          onChanged: (value) => ginInitialModel?.transNo = value,
          onSaved: (value) => ginInitialModel?.transNo = value,
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
    if (!form.validate()) {
      print('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      widget.viewModel.onFilterApply(ginInitialModel);
      widget.viewModel.onChangeGINFilter(ginInitialModel);
      Navigator.pop(context, ginInitialModel);
    }
  }
}

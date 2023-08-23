import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/filter_model.dart';
import 'package:redstars/src/redux/viewmodels/po_acknowledge/po_acknowledge_view_model.dart';
import 'package:redstars/src/services/model/response/lookups/po_ack_supplier_lookup_model.dart';
import 'package:redstars/src/widgets/partials/lookup/po_ack_supplier_lookup_field.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

class FilterDialog extends StatefulWidget {
  final AcknowledgeViewModel viewModel;
  final POFilterModel model;

  const FilterDialog({Key key, this.viewModel, this.model}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState(model);
}

class _FilterDialogState extends State<FilterDialog> {
  POFilterModel model;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _FilterDialogState(this.model);

  @override
  Widget build(BuildContext context) {
    ThemeData themedata =ThemeProvider.of(context);
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
                      SizedBox(
                        height: 8,
                      ),
                      _buildDateField(
                          "Start Date ",
                          model?.fromDate,
                          (val) => model.fromDate = val),
                      _buildDateField(
                          "End Date ",
                          model?.toDate,
                          (value) => model.toDate = value),
                      _buildSupplierField("Supplier", model?.supplier),
                      SizedBox(height: 8),
                      _buildFilterButton()
                    ],
                  )))),
    ));
  }

  Widget _buildDateField(String title, DateTime initialDate,
       Function(DateTime) onChanged) {
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
    POAckSupplierLookupItem selectedSupplier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: POAckSupplierLookupTextField(
          initialValue: selectedSupplier != null ? selectedSupplier : null,
          displayTitle: "Supplier",
          hint: "tap to select",
          onChanged: (val) => model.supplier = val),
    );
  }

  Widget _buildFilterButton() {
    ThemeData themedata =ThemeProvider.of(context);
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
                color:themedata.accentColor,
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
      widget.viewModel.onFilter(POFilterModel(
        dateRange: DateTimeRange(
          start: model.fromDate,
          end: model.toDate,
        ),
        supplier: model.supplier,
      ));
      Navigator.pop(context, model);
    }
  }
}

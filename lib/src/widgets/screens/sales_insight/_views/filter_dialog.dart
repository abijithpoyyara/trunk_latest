import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:base/resources.dart';
import 'package:base/resources.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';

class FilterDialog extends StatefulWidget {
  final bool showMargin;
  final bool showBrandCategory;
  final SaleInsightFilterModel model;

  const FilterDialog(
      {Key key,
      this.showMargin = false,
      this.showBrandCategory = false,
      @required this.model})
      : super(key: key);

  @override
  _BrandCTFilterDialogState createState() => _BrandCTFilterDialogState(model);
}

class _BrandCTFilterDialogState extends State<FilterDialog> {
  SaleInsightFilterModel model;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _BrandCTFilterDialogState(this.model);

  @override
  Widget build(BuildContext context) {
    final textTitleTheme = BaseTheme.of(context).subhead1Bold;

    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
          color:ThemeProvider.of(context).primaryColor,
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
                      _buildDateField("Start Date ", model.fromDate,
                          (val) => setState(() => model.fromDate = val)),
                      _buildDateField("End Date ", model.toDate,
                          (val) => setState(() => model.toDate = val)),
                      if (widget.showBrandCategory)
                        SwitchListTile(
                            value: model.isMajorCategory ?? false,
                            title: Text("Major Category & Brand"),
                            onChanged: (val) =>
                                setState(() => model.isMajorCategory = val)),
                      if (widget.showMargin)
                        SwitchListTile(
                            value: model.isMargin ?? false,
                            title: Text("Show Margin Analysis"),
                            onChanged: (val) =>
                                setState(() => model.isMargin = val)),
                      SizedBox(
                        height: 8,
                      ),
                      _buildFilterButton()
                    ],
                  )))),
    ));
  }

  Widget _buildDateField(
      String title, DateTime initialDate, Function(DateTime) onSaved) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: BaseDatePicker(
        isVector: true,
          hint: title,
          icon: Icons.calendar_today,
          displayTitle: title,
          initialValue: initialDate,
          autovalidate: true,
          validator: (val) => (val == null) ? "Please select date" : null,
          onSaved: onSaved),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      child: MaterialButton(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onPressed: () => _submitForm(),
        child: Text(
          'Show Result',
          style: BaseTheme.of(context).bodyMedium.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        color: ThemeProvider.of(context).primaryColorDark,
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      print('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event
      print('fromDate : ${BaseDates(model.fromDate).dbformat}');
      print('toDate : ${BaseDates(model.toDate).dbformat}');

      print('========================================');
      print('Filtering results...');

      Navigator.pop(context, model);
    }
  }
}

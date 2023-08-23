import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/viewmodels/vehicle_enquiry/vehicle_enquiry_viewmodel.dart';
import 'package:redstars/src/widgets/partials/lookup/vehicle_enquiry/production_lookup_field.dart';

import 'filter_model_vehicle_enquiry.dart';

class FilterVEProductionScreen extends StatefulWidget {
  final VehicleEnquiryProductionDetailViewModel viewModel;
  final VehicleEProductionFilterModel model;
  final Function() onSubmit;
  final int reportFormatId;
  final String filterTitle1;
  final int id;

  const FilterVEProductionScreen(
      {Key key,
      this.viewModel,
      this.model,
      this.onSubmit,
      this.reportFormatId,
      this.filterTitle1,
      this.id})
      : super(key: key);

  @override
  _FilterVEProductionScreenState createState() =>
      _FilterVEProductionScreenState(model);
}

class _FilterVEProductionScreenState extends State<FilterVEProductionScreen> {
  VehicleEProductionFilterModel model;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _FilterVEProductionScreenState(this.model);

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
                      VehicleEnquiryProductionTextField(
                        displayTitle: "Vehicle Details",
                        flag: 1,
                        initialValue: model?.lookupItemVE,
                        onChanged: (val) {
                          model?.lookupItemVE = val;
                          print(model?.lookupItemVE);
                        },
                        onSaved: (val) {
                          model?.lookupItemVE = val;
                          print(model?.lookupItemVE);
                        },
                      ),
                      Container(
                        child: BaseDialogField<FilterDataModel>(
                          height: height * .53,
                          displayTitle: "Transaction",
                          //vector: vector,
                          hint: "Tap select data",
                          isChangeHeight: true,
                          // icon: icon ?? Icons.dashboard,
                          list: FilterData,
                          initialValue: model?.filterData ??
                              FilterDataModel(title: "Customer"),
                          isEnabled: true,
                          listBuilder: (val, pos) => DocumentTypeTile(
                            selected: true,
                            //isVector: true,,
                            //  vector: listVectors[pos],
                            icon: Icons.list,
                            title: val.title,
                            onPressed: () => Navigator.pop(context, val),
                          ),
                          fieldBuilder: (selected) => Text(
                            selected.title,
                            style: BaseTheme.of(context).textfield,
                            textAlign: TextAlign.start,
                          ),
                          autoValidate: true,

                          onSaved: (val) {
                            model?.filterData = val;
                            print(model?.filterData);
                          },
                          onChanged: (val) {
                            model?.filterData = val;
                            print(model?.filterData);
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildFilterButton(),
                    ],
                  )))),
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
    print(_formKey.currentState);
    if (!form.validate()) {
      print('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      widget.viewModel?.onChangeFilter(VehicleEProductionFilterModel(
          filterData: model.filterData, lookupItemVE: model.lookupItemVE));
      widget.viewModel?.onSaveFilter(model);
      print(model?.lookupItemVE);
      print(model?.filterData);
      Navigator.pop(context, model);
    }
  }
}

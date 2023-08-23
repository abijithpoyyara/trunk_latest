//import 'package:animated_theme_switcher/animated_theme_switcher.dart';
//import 'package:base/res/values/base_theme.dart';
//import 'package:base/widgets.dart';
//import 'package:flutter/material.dart';
//import 'package:redstars/res/drawbles/app_vectors.dart';
//import 'package:redstars/src/redux/viewmodels/gin/filter_model.dart';
//import 'package:redstars/src/redux/viewmodels/grading_and_costing/grading_and_costing.dart';
//import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
//import 'package:redstars/src/widgets/partials/lookup/supplier_lookup_field.dart';
//import 'package:redstars/src/widgets/screens/grading_and_costing/grading_list_view.dart';
//
//import '../../../../../utility.dart';
//
//class SubmitRequestDialog extends StatefulWidget {
//  final GradingCostingViewModel viewModel;
//  final GINFilterModel model;
//
//  const SubmitRequestDialog({Key key, this.viewModel, this.model}) : super(key: key);
//
//  @override
//  _SubmitRequestDialogState createState() => _SubmitRequestDialogState(model);
//}
//
//class _SubmitRequestDialogState extends State<SubmitRequestDialog> {
//  GINFilterModel model;
//  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
//
//  _SubmitRequestDialogState(this.model);
//
//  @override
//  Widget build(BuildContext context) {
//    ThemeData themeData = ThemeProvider.of(context);
//    return Center(
//        child: Padding(
//          padding: EdgeInsets.symmetric(horizontal: 20),
//          child: Material(
//              color: themeData.primaryColor,
//              borderRadius: BorderRadius.circular(5.0),
//              child: Padding(
//                  padding: const EdgeInsets.symmetric(vertical: 16.0),
//                  child: Form(
//                      key: _formKey,
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          Text("Filter ", style: BaseTheme.of(context).title),
//                          SizedBox(height: 8),
//                          _buildDateField("Start Date ", model?.fromDate,
//                                  (val) => model.fromDate = val),
//                          _buildDateField("End Date ", model?.toDate,
//                                  (val) => model?.toDate = val),
//                          _buildSupplierField(
//                            "Supplier",
//                            model?.supplier,
//                          ),
//                          _searchField("Trans No"),
//                          SizedBox(
//                            height: 8,
//                          ),
//                          _buildFilterButton()
//
//                        ],
//                      )))),
//        ));
//  }
//
//  Widget _buildDateField(
//      String title, DateTime initialDate, Function(DateTime) onChanged) {
//    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//      child: BaseDatePicker(
//          isVector: true,
//          hint: title,
//          icon: Icons.calendar_today,
//          displayTitle: title,
//          initialValue: initialDate,
//          autovalidate: true,
//          onChanged: onChanged,
//          validator: (val) => (val == null) ? "Please select date" : null),
//    );
//  }
//
//  Widget _buildSupplierField(
//      String title,
//      SupplierLookupItem selectedSupplier,
//      ) {
//    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//      child: SupplierLookupTextField(
//        hint: title,
//        flag: 0,
//        displayTitle: title,
//        initialValue: selectedSupplier,
//        onChanged: (val) => model?.supplier = val,
//        vector: AppVectors.requestFrom,
//      ),
//    );
//  }
//
//  Widget _searchField(String title) {
//    return Container(
//        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//        child: BaseTextField(
//          displayTitle: title,
//          initialValue: "",
//          onChanged: (value) => model?.transNo = value,
//          onSaved: (value) => model?.transNo = value,
//          autovalidate: false,
//        ));
//  }
//
//  Widget _buildFilterButton() {
//    ThemeData themeData = ThemeProvider.of(context);
//    return Container(
//      child: MaterialButton(
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//        onPressed: () {
//          _submitForm();
//        },
//        child: Text(
//          'Show Result',
//          style: BaseTheme.of(context).bodyMedium.copyWith(
//            fontSize: 15,
//            fontWeight: FontWeight.bold,
//            color: themeData.accentColor,
//          ),
//        ),
//        color: themeData.primaryColorDark,
//      ),
//    );
//  }
//  void _submitForm() {
//    final FormState form = _formKey.currentState;
//    if (!form.validate()) {
//      print('Form is not valid!  Please review and correct.');
//    } else {
//      form.save();
//      print("fromdate----${model.fromDate}");
//      print("todate----${model.toDate}");
//      widget.viewModel.saveFilter(model);
//      //  setState(() {
//      Navigator.pop(context, model);
//      // });
//
//    }
//  }
//}

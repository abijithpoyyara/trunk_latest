import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/po_khat/po_khat_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/po_khat/po_khat_filter_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/partials/lookup/supplier_lookup_field.dart';

class POkhatFilterScreen extends StatefulWidget {
  final PokhatViewModel viewModel;
  final FilterModel khatFilterModel;

  const POkhatFilterScreen({Key key, this.viewModel, this.khatFilterModel})
      : super(key: key);

  @override
  _POkhatFilterScreenState createState() =>
      _POkhatFilterScreenState(khatFilterModel);
}

class _POkhatFilterScreenState extends State<POkhatFilterScreen> {
  FilterModel khatFilterModel;
  List<dynamic> suppliers = [];
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _POkhatFilterScreenState(this.khatFilterModel);
  BranchStockLocation loc;
  @override
  void initState() {
    suppliers = khatFilterModel?.suppliers;
    super.initState();
    print("grp====${khatFilterModel.suppliers}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.viewModel.khatLocations.forEach((element) {
      if (element.name == widget.viewModel.locationName) {
        return loc = element;
      }
      return loc;
    });
    final _suppliers = widget.viewModel.khatSupplier
        ?.map((supplier) =>
            MultiSelectItem<SupplierLookupItem>(supplier, supplier.name))
        ?.toList();
    ThemeData themeData = ThemeProvider.of(context);
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
          color: themeData.primaryColor,
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView(shrinkWrap: true, children: [
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Filter ", style: BaseTheme.of(context).title),
                        SizedBox(height: 8),
                        _buildDateField(
                            "Start Date ",
                            khatFilterModel?.fromDate,
                            (val) => khatFilterModel?.fromDate = val),
                        _buildDateField("End Date ", khatFilterModel?.toDate,
                            (val) => khatFilterModel?.toDate = val),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                          child: BaseDialogField<BranchStockLocation>(
                            // height: height * .26,
                            // isChangeHeight: true,
                            //vector: ,
                            isVector: true,
                            hint: "Tap select data",
                            icon: Icons.add_location_alt_outlined,
                            list: widget.viewModel.khatLocations,
                            initialValue: khatFilterModel.loc ?? loc,
                            isEnabled: true,
                            listBuilder: (val, pos) => DocumentTypeTile(
                              selected: true,
                              //isVector: true,,
                              // vector: vector,
                              icon: Icons.location_pin,
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
                              khatFilterModel.loc = val;
                            },
                            onChanged: (val) {
                              khatFilterModel.loc = val;
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
                        ),
                        MultiSelectDialogField(
                          confirmText: Text(
                            "OK",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: themeData.primaryColorDark),
                          ),
                          cancelText: Text(
                            "CANCEL",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: themeData.primaryColorDark),
                          ),
                          itemsTextStyle:
                              TextStyle(color: themeData.accentColor),
                          selectedItemsTextStyle:
                              TextStyle(color: themeData.accentColor),
                          checkColor: themeData.accentColor,
                          backgroundColor: themeData.scaffoldBackgroundColor,
                          searchable: true,
                          barrierColor: themeData.primaryColorDark,
                          initialValue: khatFilterModel.suppliers,
                          items: _suppliers,
                          title: Text("Suppliers"),
                          selectedColor: themeData.primaryColorDark,
                          decoration: BoxDecoration(
                            color: themeData.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: themeData.primaryColor,
                              width: 2,
                            ),
                          ),
                          buttonIcon: Icon(Icons.keyboard_arrow_down_sharp),
                          buttonText: Text(
                            "Supplier",
                            style: TextStyle(
                              color: themeData.accentColor,
                              fontSize: 16,
                            ),
                          ),
                          onSelectionChanged: (data) {
                            widget.viewModel.onChangeSuppliers(data);
                            khatFilterModel.suppliers = data;
                          },
                          onConfirm: (data) {
                            suppliers = data;
                            khatFilterModel.suppliers = data;
                            print("AAA${suppliers.length}");
                          },
                        ),
                        _searchField("Po Number"),
                        SizedBox(
                          height: 8,
                        ),
                        _buildFilterButton()
                      ],
                    )),
              ]))),
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
          initialValue: khatFilterModel?.reqNo ?? "",
          onChanged: (value) => khatFilterModel?.reqNo = value,
          onSaved: (value) => khatFilterModel?.reqNo = value,
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
      // print(khatFilterModel.fromDate);
      // print(khatFilterModel.toDate);
      print(khatFilterModel.loc.name);
      // print(khatFilterModel.suppliers);
      widget.viewModel.onApplyFilter(khatFilterModel);
      Navigator.pop(context, khatFilterModel);
    }
  }
}

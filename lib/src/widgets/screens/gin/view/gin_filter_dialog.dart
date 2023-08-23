import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/gin/gin_view_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/widgets/screens/gin/model/gin_filter_model.dart';

class GinDateFilterDialog extends StatefulWidget {
  final GINViewModel viewModel;
  final GINDateFilterModel model;

  const GinDateFilterDialog({Key key, this.viewModel, this.model})
      : super(key: key);

  @override
  _GinDateFilterDialogState createState() => _GinDateFilterDialogState(model);
}

class _GinDateFilterDialogState extends State<GinDateFilterDialog> {
  GINDateFilterModel model;

  final GlobalKey<FormState> _ginFilterKey = new GlobalKey<FormState>();
  List<dynamic> suppliers = [];

  _GinDateFilterDialogState(this.model);

  // @override
  // void initState() {
  //   DateTime currentDate = DateTime.now();
  //   model = GINDateFilterModel(
  //     toDate: currentDate,
  //     fromDate: DateTime(currentDate.year, currentDate.month, 1),
  //   );
  //   suppliers = model?.suppliers;
  //   //  model.locObj = widget.viewModel.selectedLocation;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // widget.viewModel.itemGradeRateLocationObj.forEach((element) {
    //   if (element.id ==
    //     widget.viewModel.selectedLocation.id) {
    //     //  targetLocation.add(element);
    //     selectedLoctn = element;
    //   }
    //   return selectedLoctn;
    // });
    final _suppliers = widget.viewModel.suppliers
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
              padding: EdgeInsets.zero,
              //const EdgeInsets.symmetric(vertical: 16.0),
              child: Form(
                  key: _ginFilterKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          // color: themeData.primaryColorDark,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Filter ",
                                  style: BaseTheme.of(context).title)
                            ],
                          )),
                      SizedBox(height: 8),
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
                        itemsTextStyle: TextStyle(color: themeData.accentColor),
                        selectedItemsTextStyle:
                            TextStyle(color: themeData.accentColor),
                        checkColor: themeData.accentColor,
                        backgroundColor: themeData.scaffoldBackgroundColor,
                        searchable: true,
                        barrierColor: themeData.primaryColorDark,
                        initialValue: suppliers,
                        items: _suppliers ?? [],
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
                          widget.viewModel.onChangeItems(data);
                          model.datas = data;
                        },
                        onConfirm: (data) {
                          suppliers = data;
                          print("AAA${suppliers.length}");
                        },
                      ),
                      _buildDateField("GIN DateFrom", model?.fromDate, (val) {
                        model?.fromDate = val;
                      }, (val) {
                        print(model?.fromDate);
                        model?.fromDate = val;
                      }),
                      _buildDateField(
                        "GIN DateTo ",
                        model?.toDate,
                        (val) {
                          model?.toDate = val;
                        },
                        (val) {
                          model?.toDate = val;
                        },
                      ),
                      // _buildDateField("PO DateFrom ", model?.poDateFrom,
                      //     (val) => model?.poDateFrom = val),
                      // _buildDateField("PO DateTo", model?.poDateTo,
                      //     (val) => model?.poDateTo = val),
                      // _buildTextField(model?.poNo ?? "", "PO No.",
                      //     (val) => {model?.poNo = val}),
                      // _buildTextField(model?.gINno ?? "", "GIN No.",
                      //     (val) => {model?.gINno = val}),
                      // _buildLocationField(
                      //   "To Location",
                      //   model?.locObj,
                      // ),
                      // _buildTextField(model?.pricingNo ?? "", "Pricing No.",
                      //     (val) => model?.pricingNo = val),
                      SizedBox(
                        height: 8,
                      ),
                      _buildFilterButton()
                    ],
                  )))),
    ));
  }

  Widget _buildDateField(String title, DateTime initialDate,
      Function(DateTime) onChanged, Function(DateTime) onSaved) {
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
          onSaved: onSaved,
          validator: (val) => (val == null) ? "Please select date" : null),
    );
  }

  Widget _buildTextField(
      String initialData, String title, Function(String) onChanged) {
    Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BaseTextField(
            displayTitle: title,
            initialValue: initialData,
            vector: AppVectors.ic_attachment,
            icon: Icons.description,
            onChanged: onChanged));
  }

  Widget _buildFilterButton() {
    ThemeData themeData = ThemeProvider.of(context);
    return Container(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onPressed: () {
          List<ItemLookupItem> finalItemsAry = [];
          // if (items != null && items.isNotEmpty)
          //  finalItemsAry.addAll(items);
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
    final FormState form = _ginFilterKey.currentState;
    if (!form.validate()) {
      print('Form is not valid!  Please review and correct.');
    } else {
      form.save();

      widget.viewModel.updateDate2(model);
      // widget.viewModel?.onFilterChanged(GINDateFilterModel(
      //   fromDate: model.fromDate,
      //   toDate: model.toDate,
      //   poDateTo: model.poDateTo,
      //   poDateFrom: model.poDateFrom,
      //   poNo: model.poNo,
      //   gINno: model.gINno,
      //   datas: model.datas,
      // ));
      print(model?.fromDate.toString() + model.toDate.toString());

      Navigator.pop(context, model);
    }
  }
}

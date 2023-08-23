import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/item_grade_rate_settings/item_grade_rate_settings_viewmodel.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';
import 'package:redstars/src/widgets/screens/item_garde_rate_settings/model/item_grade_rate_filter_model.dart';

class ItemGradeRateFilterDialog extends StatefulWidget {
  final ItemGradeRateViewModel viewModel;
  final ItemGradeRateSettingsFilterModel model;

  const ItemGradeRateFilterDialog({Key key, this.viewModel, this.model})
      : super(key: key);

  @override
  _ItemGradeRateFilterDialogState createState() =>
      _ItemGradeRateFilterDialogState(model);
}

class _ItemGradeRateFilterDialogState extends State<ItemGradeRateFilterDialog> {
  ItemGradeRateSettingsFilterModel model;

  final GlobalKey<FormState> _itemGradeRateFilterKey =
      new GlobalKey<FormState>();
  List<dynamic> items = [];

  _ItemGradeRateFilterDialogState(this.model);

  @override
  void initState() {
    model = ItemGradeRateSettingsFilterModel();
    items = model?.items;
    //  model.locObj = widget.viewModel.selectedLocation;
    super.initState();
  }

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
    final _items = widget.viewModel.listItemData
        ?.map((product) =>
            MultiSelectItem<ItemLookupItem>(product, product.description))
        ?.toList();
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
                  key: _itemGradeRateFilterKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          color: themeData.primaryColorDark,
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
                        initialValue: items,
                        items: _items ?? [],
                        title: Text("Items"),
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
                          "Items",
                          style: TextStyle(
                            color: themeData.accentColor,
                            fontSize: 16,
                          ),
                        ),
                        onSelectionChanged: (data) {
                          widget.viewModel.onChangeItems(data);
                          model.datas = data;

                          //  print("Itemgroup${items?.length}");
                        },
                        onConfirm: (data) {
                          items = data;
                          print("AAA${items.length}");
                        },
                      ),

                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: BaseDialogField<StockLocation>(
                          // height: height * .26,
                          // isChangeHeight: true,
                          //vector: ,
                          hint: "Tap select data",
                          icon: Icons.add_location_alt_outlined,
                          list: widget.viewModel.itemGradeRateLocationObj,
                          initialValue: model?.locObj ??
                              widget.viewModel.selectedLocation,
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
                      ),
                      _buildDateField(
                          "Start Date ",
                          DateTime(
                              DateTime.now().year, DateTime.now().month, 1),
                          (val) => model.fromDate = val),
                      _buildDateField("End Date ", model?.toDate,
                          (val) => model?.toDate = val),
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
        list: widget.viewModel.itemGradeRateLocationObj,
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
    final FormState form = _itemGradeRateFilterKey.currentState;
    if (!form.validate()) {
      print('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      widget.viewModel?.onFilterChange(ItemGradeRateSettingsFilterModel(
          fromDate: model.fromDate,
          toDate: model.toDate,
          pricingNo: model.pricingNo,
          datas: model.datas,
          locObj: model?.locObj ?? widget.viewModel.selectedLocation));
      Navigator.pop(context, model);
    }
  }
}

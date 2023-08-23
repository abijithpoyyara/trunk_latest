import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/back_dated_entry_permission/back_dated_entry_permission_viewmodel.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_branch_model.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_option_model.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/widgets/screens/back_dated_entry_permission/back_date_view/filter_model.dart';


class BackDateFilterDialog extends StatefulWidget {
  final BackDatedEntryViewModel viewModel;
  final BackDateFilterModel model;

  const BackDateFilterDialog({Key key, this.viewModel, this.model})
      : super(key: key);

  @override
  _BackDateFilterDialogState createState() => _BackDateFilterDialogState(model);
}

class _BackDateFilterDialogState extends State<BackDateFilterDialog> {
  BackDateFilterModel model;

  final GlobalKey<FormState> _ginFilterKey = new GlobalKey<FormState>();
  List<dynamic> suppliers = [];

  _BackDateFilterDialogState(this.model);

  // @override
  // void initState() {
  //   DateTime currentDate = DateTime.now();
  //   model = BackDateFilterModel(
  //     toDate: currentDate,
  //     fromDate: DateTime(currentDate.year, currentDate.month, 1),
  //   );
  //   suppliers = model?.suppliers;
  //   //  model.locObj = widget.viewModel.selectedLocation;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
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
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 36, vertical: 1),
                            child: SwitchListTile(
                                title: Text("Showly Active Permissions "),
                                activeTrackColor: themeData.primaryColorDark,
                                inactiveTrackColor: themeData.accentColor,
                                inactiveThumbColor: themeData.hintColor,
                                value: model?.isActive ?? true,
                                onChanged: (value) {
                                  setState(() {
                                    model?.isActive = value;
                                    print(model.isActive);
                                  });
                                }),
                          ),
                          if (model.isActive == false)
                            _buildDateField("Period From", model?.periodFrom,
                                    (val) {
                                  model?.periodFrom = val;
                                }, (val) {
                                  print(model?.periodFrom);
                                  model?.periodFrom = val;
                                }),
                          if (model.isActive == false)
                            _buildDateField(
                              "Period To",
                              model?.periodTo,
                                  (val) {
                                model?.periodTo = val;
                              },
                                  (val) {
                                model?.periodTo = val;
                              },
                            ),
                          BaseTextField(
                            displayTitle: "TransNo",
                            initialValue: model?.transNo,
                            onChanged: (String value) {
                              model.transNo = value;
                            },
                            onSaved: (String value) {
                              model.transNo = value;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          BaseDialogField<AddBranchList>(
                            // isChangeHeight: false,
                            vector: AppVectors.transaction,
                            hint: "Tap select data",
                            displayTitle: "Branch",
                            // icon: icon ?? Icons.dashboard,
                            list: widget.viewModel?.branchList?.addBranchList,
                            initialValue: model?.branch,
                            isEnabled: true,
                            listBuilder: (val, pos) => DocumentTypeTile(
                              selected: true,
                              subTitle: val.code,
                              //isVector: true,,
                              // vector: vector,
                              icon: Icons.list,
                              title: val.name,
                              vector: AppVectors.transaction,
                              onPressed: () => Navigator.pop(context, val),
                            ),
                            fieldBuilder: (selected) => Text(
                              selected?.name ?? "",
                              style: BaseTheme.of(context).textfield,
                              textAlign: TextAlign.start,
                            ),

                            onChanged: (value) {
                              model?.branch = value;
                            },
                            onSaved: (value) {
                              model?.branch = value;
                            },
                            // validator: (val) =>
                            // (isMandatory && val == null) ? "Please select $title " : null,
                            // displayTitle: title + (isMandatory ? " * " : ""),
                            //
                            // onSaved: onSaved,
                            // onChanged: onChanged,
//          onSaved: (val) {}
                          ),
                          BaseDialogField<AddOptionList>(
                            // isChangeHeight: false,
                            vector: AppVectors.transaction,
                            hint: "Tap select data",
                            displayTitle: "Option",
                            // icon: icon ?? Icons.dashboard,
                            list: widget.viewModel.optionList.addOptionList,
                            initialValue: model?.option,
                            isEnabled: true,
                            listBuilder: (val, pos) => DocumentTypeTile(
                              selected: true,
                              subTitle: val.optioncode,
                              //isVector: true,,
                              // vector: vector,
                              icon: Icons.list,
                              title: val.optionname,
                              vector: AppVectors.transaction,
                              onPressed: () => Navigator.pop(context, val),
                            ),
                            fieldBuilder: (selected) => Text(
                              selected?.optionname ?? "",
                              style: BaseTheme.of(context).textfield,
                              textAlign: TextAlign.start,
                            ),

                            onChanged: (value) {
                              model?.option = value;
                            },
                            onSaved: (value) {
                              model?.option = value;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          _buildFilterButton(),
                          SizedBox(
                            height: 8,
                          ),
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

      widget.viewModel.onSaveFilter(model);
      widget.viewModel.onChangeViewData(model);
      Navigator.pop(context, model);
    }
  }
}

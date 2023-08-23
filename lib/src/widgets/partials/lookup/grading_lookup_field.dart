import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/utils/lookup/grading_and_costing/grade_lookup_dialog.dart';

class GradingLookupTextField extends BaseLookupTextField {
  final int flag;

  GradingLookupTextField({
    String hint,
    String displayTitle,
    @required this.flag,
    String vector,
    bool isVector = false,
    GradeLookupItem initialValue,
    ValueSetter<GradeLookupItem> onChanged,
    ValueSetter<GradeLookupItem> onSaved,
  }) : super(
            vector: vector,
            isVector: isVector,
            hint: hint,
            displayTitle: displayTitle,
            initialValue: initialValue,
            onChanged: (val) => onChanged(val),
            onSaved: (val) => onSaved(val),
            validator: (val) => val == null ? "Select an item " : null);

  @override
  ItemLookupState createState() => ItemLookupState();
}

class ItemLookupState
    extends BaseLookupState<GradingLookupTextField, GradeLookupItem> {
  @override
  Future<GradeLookupItem> loadLookupData() {
    return gradeLookupDialog(
      flag: widget.flag,
      context: context,
      title: widget.displayTitle.replaceAll("*", ""),
    );
  }

  @override
  Widget buildChild(BaseTheme theme) {
    return Text(
      isSelected ? selectedValue.name : "Tap to select data",
      style: theme.textfield,
      textAlign: TextAlign.start,
    );
  }
}

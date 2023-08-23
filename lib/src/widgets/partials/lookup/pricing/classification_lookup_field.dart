import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/item_group_lookup_model.dart';
import 'package:redstars/src/utils/lookup/pricing/classification_lookup_dialog.dart';

class ClassificationTextField extends BaseLookupTextField {
  final int flag;
  final String vector;
  final bool isVector;

  ClassificationTextField({
    String hint,
    String displayTitle,
    @required this.flag,
    this.isVector = false,
    this.vector,
    ItemGroupLookupItem initialValue,
    ValueSetter<ItemGroupLookupItem> onChanged,
    ValueSetter<ItemGroupLookupItem> onSaved,
  }) : super(
            isVector: isVector,
            hint: hint,
            displayTitle: displayTitle,
            initialValue: initialValue,
            onChanged: (val) => onChanged(val),
            onSaved: onSaved,
            validator: (val) => val == null ? "Select an item " : null);

  @override
  ClassificationLookupState createState() => ClassificationLookupState();
}

class ClassificationLookupState
    extends BaseLookupState<ClassificationTextField, ItemGroupLookupItem> {
  @override
  Future<ItemGroupLookupItem> loadLookupData() {
    return classificationLookupDialog(
      flag: widget.flag,
      context: context,
      title: widget.displayTitle.replaceAll("*", ""),
    );
  }

  @override
  Widget buildChild(BaseTheme theme) {
    return Text(
      isSelected ? selectedValue.description : "Tap to select data",
      style: theme.textfield,
      textAlign: TextAlign.start,
    );
  }
}

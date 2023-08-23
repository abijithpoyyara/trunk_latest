import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/utils/lookup/trans_type_lookup_dialog.dart';

class TransTypeLookupTextField extends BaseLookupTextField {
  final String flag;

  TransTypeLookupTextField({
    String hint,
    String displayTitle,
    @required this.flag,
    String vector,
    bool isVector=false,
    TransTypeLookupItem initialValue,
    ValueSetter<TransTypeLookupItem> onChanged,
    ValueSetter<TransTypeLookupItem> onSaved,

  }) : super(vector: vector,
            isVector: isVector,
            hint: hint,
            displayTitle: displayTitle,
            initialValue: initialValue,
            onChanged: (val) => onChanged(val),
            onSaved: onSaved,
            validator: (val) => val == null ? "Select an item " : null);

  @override
  ItemLookupState createState() => ItemLookupState();
}

class ItemLookupState
    extends BaseLookupState<TransTypeLookupTextField, TransTypeLookupItem> {
  @override
  Future<TransTypeLookupItem> loadLookupData() {
    return transTypeLookupDialog(
      flag: widget.flag,
      context: context,
      title: widget.displayTitle.replaceAll("*", ""),
    );
  }

  @override
  Widget buildChild(BaseTheme theme) {
    return Text(
      isSelected ? selectedValue.purchaseorderno : "Tap to select data",
      style: theme.textfield,
      textAlign: TextAlign.start,
    );
  }
}

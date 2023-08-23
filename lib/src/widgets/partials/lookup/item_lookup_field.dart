import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/utils/lookup/item_lookup_dialog.dart';

class ItemLookupTextField extends BaseLookupTextField {
  final String vector;
  final bool isVector;
  final bool isBorder;

  ItemLookupTextField({
    String hint,
    String displayTitle,
    ItemLookupItem initialValue,
    ValueSetter<ItemLookupItem> onChanged,
    ValueSetter<ItemLookupItem> onSaved,
    this.vector,
    this.isVector=false,
    this.isBorder=false,
  }) : super(
    isBorder: isBorder,
            isVector: isVector,
            vector: vector,
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
    extends BaseLookupState<ItemLookupTextField, ItemLookupItem> {
  @override
  Future<ItemLookupItem> loadLookupData() {
    return itemLookupDialog(
      actionFlag: widget.actionFlag,
      procName: widget.procName,
      context: context,
      title: widget.displayTitle.replaceAll("*", ""),
    );
  }
}

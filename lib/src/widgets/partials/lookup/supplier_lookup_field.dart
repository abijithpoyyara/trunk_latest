import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';
import 'package:redstars/src/utils/lookup/supplier_lookup_dialog.dart';

class SupplierLookupTextField extends BaseLookupTextField {
  final int flag;

  SupplierLookupTextField({
    String hint,
    String displayTitle,
    @required this.flag,
    String vector,
    bool isVector = false,
    SupplierLookupItem initialValue,
    ValueSetter<SupplierLookupItem> onChanged,
    ValueSetter<SupplierLookupItem> onSaved,
  }) : super(
          hint: hint,
          vector: vector,
          isVector: isVector,
          displayTitle: displayTitle,
          initialValue: initialValue,
          onChanged: (val) => onChanged(val),
          onSaved: onSaved,
          // validator: (val) => val == null ? "Select an item " : null
        );

  @override
  SupplierLookupState createState() => SupplierLookupState();
}

class SupplierLookupState
    extends BaseLookupState<SupplierLookupTextField, SupplierLookupItem> {
  @override
  Future<SupplierLookupItem> loadLookupData() {
    return supplierLookupDialog(
      flag: widget.flag,
      context: context,
      title: widget.displayTitle.replaceAll("*", ""),
    );
  }

  @override
  Widget buildChild(BaseTheme theme) {
    return Text(
      isSelected ? selectedValue?.name : "Tap to select data",
      style: theme.textfield,
      textAlign: TextAlign.start,
    );
  }
}

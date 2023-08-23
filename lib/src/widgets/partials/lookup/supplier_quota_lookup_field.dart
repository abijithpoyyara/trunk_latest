import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_quota_lookup.dart';
import 'package:redstars/src/utils/lookup/supplier_quota_lookup_dialog.dart';

class SupplierQuotaLookupTextField extends BaseLookupTextField {
  final String vector;
  final bool isVector;
  final bool isBorder;
  final isEnabled;

  SupplierQuotaLookupTextField({
    String hint,
    String displayTitle,
    SupplierQuotaItem initialValue,
    ValueSetter<SupplierQuotaItem> onChanged,
    ValueSetter<SupplierQuotaItem> onSaved,
    this.vector,
    this.isVector = false,
    this.isBorder = false,
    this.isEnabled = true,
  }) : super(
          isBorder: isBorder,
          isVector: isVector,
          vector: vector,
          hint: hint,
          isEnabled: isEnabled,
          displayTitle: displayTitle,
          initialValue: initialValue,
          onChanged: (val) => onChanged(val),
          onSaved: onSaved,
          // validator: (val) => val == null ? "Select an item " : null
        );

  @override
  SupplierQuotaLookupState createState() => SupplierQuotaLookupState();
}

class SupplierQuotaLookupState
    extends BaseLookupState<SupplierQuotaLookupTextField, SupplierQuotaItem> {
  @override
  Future<SupplierQuotaItem> loadLookupData() {
    return supplierQuotaDialog(
      actionFlag: widget.actionFlag,
      procName: widget.procName,
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

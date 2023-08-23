import 'package:base/widgets.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/po_ack_supplier_lookup_model.dart';
import 'package:redstars/src/utils/lookup/po_ack_supplier_lookup_dialog.dart';

class POAckSupplierLookupTextField extends BaseLookupTextField {

  POAckSupplierLookupTextField({
    String hint,
    String displayTitle,
    POAckSupplierLookupItem initialValue,
    ValueSetter<POAckSupplierLookupItem> onChanged,
    ValueSetter<POAckSupplierLookupItem> onSaved,
  }) : super(
            hint: hint,
            displayTitle: displayTitle,
            initialValue: initialValue,
            onChanged: (val) => onChanged(val),
            onSaved: onSaved,
            validator: (val) => val == null ? "Select Supplier " : null);

  @override
  POAckSupplierLookupState createState() => POAckSupplierLookupState();
}

class POAckSupplierLookupState extends BaseLookupState<
    POAckSupplierLookupTextField, POAckSupplierLookupItem> {
  @override
  Future<POAckSupplierLookupItem> loadLookupData() {
    return poAckSupplierLookupDialog(
        context: context,
        title: widget.displayTitle.replaceAll("*", ""));
  }

  @override
  Widget buildChild(BaseTheme theme) {
    return Text(
      isSelected ? selectedValue.description ?? "tap to select" : "tap to select",
      style: selectedValue.description != null ? theme.textfield : theme.bodyHint,
      textAlign: TextAlign.start,
    );
  }
}

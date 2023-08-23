import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/customer_lookup_model.dart';
import 'package:redstars/src/utils/lookup/customer_lookup_dialog.dart';

class CustomerLookUpTextField extends BaseLookupTextField {
  final int flag;

  CustomerLookUpTextField(
      {bool isEnabled,
      String hint,
      String displayTitle,
      @required this.flag,
      Customer initialValue,
      ValueSetter<Customer> onChanged,
      ValueSetter<Customer> onSaved,
      String vector,
      bool isVector = false})
      : super(
            isEnabled: isEnabled,
            vector: vector,
            isVector: isVector,
            hint: hint,
            displayTitle: displayTitle,
            initialValue: initialValue,
            onChanged: (val) => onChanged(val),
            onSaved: onSaved,
            validator: (val) => val == null ? "Select an item " : null);

  @override
  CustomerLookUpState createState() => CustomerLookUpState();
}

class CustomerLookUpState
    extends BaseLookupState<CustomerLookUpTextField, Customer> {
  @override
  Future<Customer> loadLookupData() {
    return customerLookupDialog(
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

import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/utils/lookup/service_lookup_dialog.dart';

class VoucherServiceLookupTextField extends BaseLookupTextField {
  final int flag;

  VoucherServiceLookupTextField({
    bool isEnabled,
    String hint,
    String displayTitle,
    @required this.flag,
    ServiceLookupItem initialValue,
    ValueSetter<ServiceLookupItem> onChanged,
    ValueSetter<ServiceLookupItem> onSaved,
    String vector,
    bool isVector=false
  }) : super(
      isEnabled: isEnabled,
      vector: vector,
      isVector:isVector,
      hint: hint,
      displayTitle: displayTitle,
      initialValue: initialValue,
      onChanged: (val) => onChanged(val),
       onSaved:(val)=> onSaved(val),
      validator: (val) => val == null ? "Select an item " : null);

  @override
  VoucherServiceLookupState createState() => VoucherServiceLookupState();
}

class VoucherServiceLookupState
    extends BaseLookupState<VoucherServiceLookupTextField, ServiceLookupItem> {
  @override
  Future<ServiceLookupItem> loadLookupData() {

    return serviceLookupDialog(
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

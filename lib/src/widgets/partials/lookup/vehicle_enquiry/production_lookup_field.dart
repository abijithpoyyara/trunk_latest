import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/vehicle_enquiry/vehicle_enquiry_production_lookup_model.dart';
import 'package:redstars/src/utils/lookup/vehicle_enquiry/vehicle_enquiry_dialog.dart';

class VehicleEnquiryProductionTextField extends BaseLookupTextField {
  final int flag;
  final String vector;
  final bool isVector;

  VehicleEnquiryProductionTextField({
    String hint,
    String displayTitle,
    @required this.flag,
    this.isVector = false,
    this.vector,
    VehicleFilterDetailListLookupItem initialValue,
    ValueSetter<VehicleFilterDetailListLookupItem> onChanged,
    ValueSetter<VehicleFilterDetailListLookupItem> onSaved,
  }) : super(
            isVector: isVector,
            hint: hint,
            displayTitle: displayTitle,
            initialValue: initialValue,
            onChanged: (val) => onChanged(val),
            onSaved: (val) => onSaved(val),
            validator: (val) => val == null ? "Select an item " : null);

  @override
  VehicleFilterDetailListLookupState createState() =>
      VehicleFilterDetailListLookupState();
}

class VehicleFilterDetailListLookupState extends BaseLookupState<
    VehicleEnquiryProductionTextField, VehicleFilterDetailListLookupItem> {
  @override
  Future<VehicleFilterDetailListLookupItem> loadLookupData() {
    return vehicleEnquiryLookupDialog(
      flag: widget.flag,
      context: context,
      title: widget.displayTitle.replaceAll("*", ""),
    );
  }

  @override
  Widget buildChild(BaseTheme theme) {
    return Text(
      isSelected ? selectedValue?.modelname ?? "" : "Tap to select data",
      style: theme.textfield,
      textAlign: TextAlign.start,
    );
  }
}

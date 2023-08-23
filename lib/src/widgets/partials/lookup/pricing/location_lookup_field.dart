import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/utils/lookup/pricing/location_lookup_dialog.dart';

class LocationLookupTextField extends BaseLookupTextField {
  final int flag;
  final String vector;
  final bool isVector;

  LocationLookupTextField({
    String hint,
    String displayTitle,
    @required this.flag,
    this.isVector = false,
    this.vector,
    LocationLookUpItem initialValue,
    ValueSetter<LocationLookUpItem> onChanged,
    ValueSetter<LocationLookUpItem> onSaved,
  }) : super(
            // isVector: isVector,
            hint: hint,
            displayTitle: displayTitle,
            initialValue: initialValue,
            onChanged: (val) => onChanged(val),
            onSaved: onSaved,
            validator: (val) => val == null ? "Select an item " : null);

  @override
  LocationLookupState createState() => LocationLookupState();
}

class LocationLookupState
    extends BaseLookupState<LocationLookupTextField, LocationLookUpItem> {
  @override
  Future<LocationLookUpItem> loadLookupData() {
    return locationLookupDialog(
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

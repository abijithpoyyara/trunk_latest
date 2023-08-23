import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/account_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/trans_type_lookup_model.dart';
import 'package:redstars/src/utils/lookup/account_lookup_dialog.dart';
import 'package:redstars/src/utils/lookup/service_lookup_dialog.dart';
import 'package:redstars/src/utils/lookup/trans_type_lookup_dialog.dart';

class AccountLookupTextField extends BaseLookupTextField {
  final int flag;
  final String vector;
  final bool isVector;

  AccountLookupTextField({
    String hint,
    String displayTitle,
    @required this.flag,
    this.isVector=false,
    this.vector,
    AccountLookupItem initialValue,
    ValueSetter<AccountLookupItem> onChanged,
    ValueSetter<AccountLookupItem> onSaved,
  }) : super(isVector:isVector ,
            hint: hint,
            displayTitle: displayTitle,
            initialValue: initialValue,
            onChanged: (val) => onChanged(val),
            onSaved: onSaved,
            validator: (val) => val == null ? "Select an item " : null);

  @override
  AccountLookupState createState() => AccountLookupState();
}

class AccountLookupState
    extends BaseLookupState<AccountLookupTextField, AccountLookupItem> {
  @override
  Future<AccountLookupItem> loadLookupData() {
    return accountLookupDialog(
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

import 'package:base/res/values/base_theme.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/services/model/response/lookups/analysis_code_user_lookup_model.dart';
import 'package:redstars/src/utils/lookup/analysis_code_user_lookup_dialog.dart';

class AnalysisCodeLookupField extends BaseLookupTextField{
  final String vector;
  final bool isVector;
  final bool isBorder;
  final isEnabled;
  final bool isClear;
  final Function() onPressed;

  AnalysisCodeLookupField({
    String hint,
    String displayTitle,
    AnalysisCodeModelItem initialValue,
    ValueSetter<AnalysisCodeModelItem> onChanged,
    ValueSetter<AnalysisCodeModelItem> onSaved,
    this.vector,
    this.isClear,
    this.onPressed,
    this.isVector,
    this.isBorder,
    this.isEnabled}) : super(
    isBorder: isBorder,
    isVector: isVector,
    vector: vector,
    hint: hint,
    isEnabled: isEnabled,
    displayTitle: displayTitle,
    initialValue: initialValue,
    onChanged: (val) => onChanged(val),
    onSaved: onSaved,
  );

  @override
  AnalysisCodeLookupState createState() => AnalysisCodeLookupState();
}

class AnalysisCodeLookupState
    extends BaseLookupState<AnalysisCodeLookupField, AnalysisCodeModelItem> {
  @override
  Future<AnalysisCodeModelItem> loadLookupData() {
    return analysisCodeUserDialog(
      actionFlag: widget.actionFlag,
      procName: widget.procName,
      context: context,
      title: widget.displayTitle.replaceAll("*", ""),
    );
  }

  @override
  Widget buildChild(BaseTheme theme) {
    return Text(
      isSelected ? selectedValue?.name??"" : "Tap to select data",
      style: theme.textfield,
      textAlign: TextAlign.start,
    );
  }
}
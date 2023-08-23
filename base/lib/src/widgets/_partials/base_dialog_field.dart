import 'package:base/resources.dart';
import 'package:base/src/widgets/_views/list_dialog.dart';
import 'package:flutter/material.dart';

import '../../../widgets.dart';
import 'base_fake_text_field.dart';

class BaseDialogField<U> extends StatefulWidget {
  BaseDialogField({
    Key key,
    @required this.list,
    @required this.listBuilder,
    @required this.fieldBuilder,
    this.hint,
    this.initialValue,
    @required this.displayTitle,
    this.onChanged,
    this.onSaved,
    this.autoValidate = false,
    this.validator,
    this.icon,
    this.isEnabled = true,
    this.vector,
    this.isVector = false,
    this.height,
    this.isChangeHeight = false,
    this.onBeforeChanged,
    this.userStyle,
  }) : super(key: key);

  final DialogListBuilder<U> listBuilder;
  final Widget Function(U) fieldBuilder;
  final List<U> list;
  final String hint;
  final String displayTitle;
  final U initialValue;
  final bool isEnabled;
  final ValueSetter<U> onChanged;
  final bool Function(U) onBeforeChanged;
  final ValueSetter<U> onSaved;
  final FormFieldValidator<U> validator;
  final bool autoValidate;
  final bool isVector;
  final String vector;
  final double height;
  final IconData icon;
  final bool isChangeHeight;
  final TextStyle userStyle;

  @override
  BaseDialogFieldState<U> createState() => BaseDialogFieldState<U>();
}

class BaseDialogFieldState<U> extends State<BaseDialogField<U>> {
  U selectedValue;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    isSelected = selectedValue != null;
  }

  @override
  Widget build(BuildContext context) {
    final _theme = BaseTheme.of(context);

    return BaseFakeTextField<U>(
      displayTitle: widget.displayTitle,
      initialValue: widget.initialValue,
      userStyle: widget.userStyle,
      child: isSelected
          ? widget.fieldBuilder(selectedValue)
          : Text(widget.hint ?? "tap to select", style: _theme.bodyHint),
      onTap: widget.isEnabled
          ? (FormFieldState<U> field) async {
              final value = await loadDialogData();
              if (value != null && value != selectedValue) {
                bool isvalid = true;
                if (widget.onBeforeChanged != null) {
                  isvalid = widget.onBeforeChanged(value);
                }
                if (isvalid) {
                  setState(() {
                    selectedValue = value;
                    isSelected = true;
                    if (widget.onChanged != null) {
                      widget.onChanged(value);
                    }
                    field.didChange(value);
                  });
                }
              }
            }
          : null,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidate: widget.autoValidate,
      icon: widget.icon,
      vector: widget.vector,
      isVector: widget.isVector,
      height: widget.height,
    );
  }

  Future<U> loadDialogData() {
    return showListDialog<U>(context, widget.list,
        title: widget.displayTitle,
        builder: (data, position) => widget.listBuilder(data, position),
        isChangeHeight: widget.isChangeHeight ?? false,
        height: widget.height);
  }
}

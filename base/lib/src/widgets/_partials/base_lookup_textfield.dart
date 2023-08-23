import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';

import 'base_fake_text_field.dart';

class BaseLookupTextField<T, U> extends StatefulWidget {
  BaseLookupTextField({
    Key key,
    this.hint,
    this.initialValue,
    @required this.displayTitle,
    this.onChanged,
    this.onSaved,
    this.autovalidate = false,
    this.validator,
    this.icon,
    this.isEnabled = true,
    this.actionFlag,
    this.procName,
    this.params,
    this.vector,
    this.subActionFlag,
    this.isVector = false,
    this.isBorder = true,
    this.isClear=false,
    this.onPressed,
    this.suffixIcon,
  }) : super(key: key);

  final String actionFlag;
  final String procName;
  final String hint;
  final String displayTitle;
  final U initialValue;
  final bool isEnabled;
  final ValueSetter<U> onChanged;
  final ValueSetter<U> onSaved;
  final FormFieldValidator<U> validator;
  final String subActionFlag;
  final List<Map<String, dynamic>> params;
  final bool autovalidate;
  final String vector;
  final bool isVector;
  final bool isBorder;
  final bool isClear;
  final Function() onPressed;
  final Widget suffixIcon;

  final IconData icon;

  @override
  BaseLookupState createState() => BaseLookupState();
}

class BaseLookupState<T extends BaseLookupTextField, U extends LookupItems>
    extends State<T> {
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

    return BaseFakeTextField<LookupItems>(
      vector: widget.vector,
      isVector: widget.isVector,
      isBorder: widget.isBorder,
      displayTitle: widget.displayTitle,
      initialValue: widget.initialValue,
      suffixIcon: widget.isClear == true
          ? IconButton(icon: Icon(Icons.clear,
        color: Colors.white,
        size: 21,),
        onPressed: (){
            setState(() {
              selectedValue = null;
              widget.onPressed();
            });}
        ,) : widget.suffixIcon,
      child: isSelected
          ? buildChild(_theme)
          : Text(
              widget.hint ?? "tap to select",
              style: _theme.bodyHint,
            ),
      onTap: widget.isEnabled
          ? (FormFieldState<LookupItems> field) async {
              final value = await loadLookupData();

              if (value != null && value != selectedValue) {
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
          : null,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidate: widget.autovalidate,
      icon: widget.icon,
    );
  }

  Future<U> loadLookupData() {
    return baseLookupDialog(
      actionFlag: widget.actionFlag,
      procName: widget.procName,
      context: context,
      title: widget.displayTitle.replaceAll("*", ""),
    );
  }

  Widget buildChild(BaseTheme theme) {
    return Text(
      isSelected ? selectedValue.description : "Tap to select data",
      style: theme.textfield,
      textAlign: TextAlign.start,
    );
  }
}

class GenericLookupTextField<T extends LookupItems>
    extends BaseLookupTextField {
  final String url;
  final List<Map<String, dynamic>> jssArr;

  final Widget Function(T) listBuilder;

  GenericLookupTextField({
    this.url,
    this.jssArr,
    String hint,
    String displayTitle,
    T initialValue,
    ValueSetter<T> onChanged,
    ValueSetter<T> onSaved,
    ValueSetter<T> validator,
    @required this.listBuilder,
  }) : super(
            hint: hint,
            displayTitle: displayTitle,
            initialValue: initialValue,
            onChanged: (val) => onChanged(val),
            onSaved: onSaved,
            validator: (val) => val == null ? "Select an item " : null);

  @override
  GenericLookupState createState() => GenericLookupState();
}

class GenericLookupState<T extends LookupItems>
    extends BaseLookupState<GenericLookupTextField<T>, T> {
  @override
  Future<T> loadLookupData() {
    return genericLookupDialog<T>(
      context: context,
      title: widget.displayTitle.replaceAll("*", ""),
      url: widget.url,
      jssArr: widget.jssArr,
      listBuilder: widget.listBuilder,
    );
  }
}

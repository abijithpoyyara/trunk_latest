import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';

class BaseDropDown<T> extends StatefulWidget {
  const BaseDropDown(this.builder, {
    Key key,
    this.hint,
    this.value,
    @required this.items,
    @required this.onChanged,
    this.isExpanded,
    this.label,
    this.iconDisabledColor,
    this.iconEnableColor,
    this.hasError = false,
    this.labelStyle,
    this.enabledBorder,
    this.contentPadding,
    this.style,
    this.errorStyle,
  }) : super(key: key);

  final String hint;
  final T value;
  final List<T> items;
  final FormFieldSetter<T> onChanged;
  final bool isExpanded;
  final bool hasError;
  final String label;
  final TextStyle labelStyle;
  final Color iconEnableColor;
  final Color iconDisabledColor;
  final InputBorder enabledBorder;
  final EdgeInsets contentPadding;
  final TextStyle style;
  final TextStyle errorStyle;

  final Widget Function(T) builder;

  @override
  BaseDropDownState createState() => BaseDropDownState<T>();
}

class BaseDropDownState<T> extends State<BaseDropDown<T>> {
  T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(BaseDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = BaseTheme.of(context),
        _style = _theme.body2.copyWith(fontSize: 15,color: Colors.white);
    ThemeData themeData = ThemeProvider.of(context);


    return Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<T>(
              dropdownColor:themeData.primaryColor,
              style: _style,
                iconEnabledColor: widget.iconEnableColor,
                iconDisabledColor:widget.iconDisabledColor ,

                decoration: InputDecoration(
                 errorStyle: widget.errorStyle,
                  enabledBorder:widget.enabledBorder,
                    labelStyle: widget.labelStyle,
                    labelText: widget.label,
                    contentPadding: widget.contentPadding),
                isDense: true,
                value: widget.items.contains(_value) ? _value : null,
                isExpanded: widget.isExpanded ?? true,
                // hint: Text(widget.hint ?? "Tap to select"),
                elevation: 1,
                items: widget.items
                    .map((value) =>
                    DropdownMenuItem<T>(
                        value: value, child: widget.builder(value)))
                    .toList(),
                onChanged: (T value) {
                  setState(() {
                    _value = value;
                    widget.onChanged(value);
                  });
                })));
  }
}

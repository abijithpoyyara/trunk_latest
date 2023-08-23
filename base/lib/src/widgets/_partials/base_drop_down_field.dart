import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseDropDownField<T> extends StatefulWidget {
  const BaseDropDownField({
    Key key,
    this.hint,
    @required this.items,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.autovalidate = false,
    this.onChanged,
    this.isExpanded,
    @required this.builder,
    this.label,
    this.labelStyle,
    this.iconEnableColor,
    this.iconDisabledColor,
    this.enabledBorder,
    this.contentPadding,
    this.style,
    this.errorStyle,
  }) : super(key: key);

  final FormFieldSetter<T> onSaved;
  final FormFieldValidator<T> validator;
  final T initialValue;
  final bool autovalidate;
  final String hint;
  final List<T> items;
  final FormFieldSetter<T> onChanged;
  final bool isExpanded;
  final Widget Function(T) builder;
  final String label;
  final TextStyle labelStyle;
  final Color iconEnableColor;
  final Color iconDisabledColor;
  final InputBorder enabledBorder;
  final EdgeInsets contentPadding;
  final TextStyle style;
  final TextStyle errorStyle;
  @override
  _BaseDropDownFieldState<T> createState() => _BaseDropDownFieldState<T>();
}

class _BaseDropDownFieldState<T> extends State<BaseDropDownField<T>> {
  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.initialValue,
      // autovalidate: widget.autovalidate,
      builder: (FormFieldState<T> field) {
        final child = BaseDropDown<T>(
          widget.builder,
          hint: widget.hint,
          value: field?.value ?? widget.initialValue,
          items: widget.items,
          hasError: field.hasError,
          label: widget.label,
          labelStyle: widget.labelStyle,
          iconDisabledColor: widget.iconDisabledColor,
          iconEnableColor: widget.iconEnableColor,
          enabledBorder: widget.enabledBorder,
          contentPadding: widget.contentPadding,
          errorStyle: widget.errorStyle,
          //style: widget.style,
          onChanged: (T value) {
            field.didChange(value);
            if (widget.onChanged != null) {
              widget.onChanged(value);
            }
          },
          isExpanded: widget.isExpanded,
        );
        return field.hasError
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                child,
                const SizedBox(height: 4.0),
                Text(field.errorText, style: widget.errorStyle)
              ])
            : child;
      },
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}

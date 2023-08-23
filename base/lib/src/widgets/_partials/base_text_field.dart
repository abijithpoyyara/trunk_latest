import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseTextField<T> extends StatefulWidget {
  BaseTextField(
      {Key key,
      this.initialValue,
      this.hint,
      this.icon,
      @required this.displayTitle,
      this.onChanged,
      this.onSaved,
      this.autovalidate = false,
      this.validator,
      this.padding,
      this.onEditingCompleted,
      this.isEnabled = true,
      this.isNumberField = false,
      this.autoFocus = false,
      this.isVector = false,
      this.vector,
      this.inputFormatters,
      this.onTap,
      this.minLines,
      this.maxLines,
      this.maxLength,
      this.controller})
      : super(key: key);

  final String initialValue;
  final String hint;
  final String displayTitle;

  final IconData icon;
  final EdgeInsets padding;
  final bool isEnabled;
  final bool autoFocus;

  final bool isNumberField;
  final ValueSetter<String> onChanged;
  final ValueSetter<String> onSaved;
  final ValueSetter<String> onEditingCompleted;
  final FormFieldValidator<String> validator;
  final bool autovalidate;
  final bool isVector;
  final String vector;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final void Function() onTap;
  final int minLines;
  final int maxLines;
  final int maxLength;

  @override
  BaseTextFieldState createState() => BaseTextFieldState();
}

class BaseTextFieldState<T> extends State<BaseTextField> {
  String initialValue;

  @override
  void initState() {
    super.initState();
    initialValue = widget.initialValue;
  }

  @override
  void dispose() {
    widget?.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = BaseTheme.of(context);
    return TextFormField(
      onTap: widget.onTap,
      maxLength: widget.maxLength,
      controller: widget.controller,
      style: _theme.body2.copyWith(color: _theme.colors.white),
      enabled: widget.isEnabled,
      inputFormatters: widget.inputFormatters,
      textInputAction: TextInputAction.done,
      initialValue: initialValue,
      autovalidate: widget.autovalidate,
      autofocus: widget.autoFocus,
      validator: widget.validator,
      maxLines:widget.maxLines ,
      minLines:widget.minLines ,
      onFieldSubmitted: widget.onEditingCompleted,
      keyboardType: widget.isNumberField
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      textAlign: widget.isNumberField ? TextAlign.end : TextAlign.start,
      decoration: InputDecoration(
          counterStyle: TextStyle(color: _theme.colors.accentColor),
          labelStyle: _theme.body2.copyWith(color: _theme.colors.white),
          hintStyle: _theme.body2.copyWith(color: _theme.colors.white),
          hintText: widget.hint,
          errorStyle:
              _theme.body2.copyWith(fontSize: 14, color: _theme.colors.white),
          errorBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: _theme.colors.white.withOpacity(0.70))),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: _theme.colors.white.withOpacity(0.70))),
          disabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: _theme.colors.white.withOpacity(0.70))),
          border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: _theme.colors.white.withOpacity(0.70))),
          focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: _theme.colors.white.withOpacity(0.70))),
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: _theme.colors.white.withOpacity(0.70))),
          labelText: widget.displayTitle,
          icon: widget.isVector || widget.icon != null
              ? Icon(widget.icon,
                  color: ThemeProvider.of(context).accentColor, size: 18)
              : SvgPicture.asset(widget.vector ?? BaseVectors.appearance),
          contentPadding: widget.padding,
          filled: !widget.isEnabled),
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
    );
  }
}

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseFakeTextField<T> extends StatefulWidget {
  BaseFakeTextField({
    Key key,
    @required this.onTap,
    this.initialValue,
    this.hint,
    this.child,
    @required this.icon,
    @required this.displayTitle,
    this.autovalidate = false,
    this.onSaved,
    this.padding,
    this.validator,
    this.vector,
    this.isVector = false,
    this.height,
    this.suffixIcon,
    this.isBorder = true,
    this.editingController,
    this.userStyle,
  }) : super(key: key);

  final FormFieldSetter<T> onSaved;
  final FormFieldValidator<T> validator;
  final ValueSetter<FormFieldState<T>> onTap;
  final T initialValue;
  final String hint;
  final String displayTitle;
  final Widget child;
  final IconData icon;
  final EdgeInsets padding;
  final bool autovalidate;
  final String vector;
  final bool isVector;
  final double height;
  final Widget suffixIcon;
  final bool isBorder;
  final TextEditingController editingController;
  final TextStyle userStyle;

  @override
  BaseFakeTextFieldState<T> createState() => BaseFakeTextFieldState<T>();
}

class BaseFakeTextFieldState<T> extends State<BaseFakeTextField<T>>
    with BaseKeyboardProvider {
  bool get isEnabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final _theme = BaseTheme.of(context);

    return FormField<T>(
      initialValue: widget?.initialValue,
      // autovalidate: widget.autovalidate,
      builder: (FormFieldState<T> field) {
        return InkWell(
          onTap: isEnabled
              ? () {
                  closeKeyboard();
                  widget.onTap(field);
                }
              : null,
          child: InputDecorator(
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon,
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
              errorBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: _theme.colors.white.withOpacity(0.70))),

              //contentPadding:
              // EdgeInsets.fromLTRB(0, height * .003, 0, height * .004),
              // labelText: displayTitle,
              labelStyle: widget.userStyle ??
                  _theme.smallMedium.copyWith(
                      fontSize: 16,
                      color: _theme.colors.white.withOpacity(0.70)),
              hintStyle: _theme.body2
                  .copyWith(fontSize: 18, color: _theme.colors.white),
              // hintStyle:BaseTheme.of(context).subhead1.copyWith(color: _theme.colors.white.withOpacity(.80)),
              //  border: UnderlineInputBorder(
              //    borderSide: BorderSide(
              //        color: (field.hasError ?? false)
              //            ? _theme.errorStyle.color
              //            : BaseColors.of(context).accentColor),
              //  ),
              filled: !isEnabled,
              errorStyle: _theme.body2
                  .copyWith(fontSize: 14, color: _theme.colors.white),

              labelText: widget.displayTitle,

              icon: widget.isVector
                  ? Visibility(
                      visible: widget.isBorder,
                      child: Icon(
                        widget.icon,
                        color: ThemeProvider.of(context).accentColor,
                        size: 18,
                      ),
                    )
                  : Visibility(
                      visible: widget.isBorder,
                      child: SvgPicture.asset(
                          widget.vector ?? BaseVectors.transaction)),
              errorText: field.errorText,
              contentPadding: widget.padding,
            ),
            child: widget.child ??
                Text(
                  () {
                    if (field.value != null) {
                      if (field.value is List) {
                        return (field.value as List).isNotEmpty
                            ? "Successfully Added!"
                            : widget.hint;
                      }
                      if (field.value is String) {
                        return (field.value as String).isNotEmpty
                            ? field.value.toString()
                            : widget.hint;
                      }
                      return field.value.toString();
                    }
                    return widget.hint;
                  }(),
                  style: () {
                    if (!isEnabled) {
                      return _theme.title;
                    }
                    if ((field.value != null &&
                            field.value is! List &&
                            field.value is! String) ||
                        (field.value is List &&
                            (field.value as List).isNotEmpty) ||
                        (field.value is String &&
                            (field.value as String).isNotEmpty)) {
                      return _theme.textfield;
                    }

                    return _theme.body2MediumHint;
                  }(),
                ),
          ),
        );
      },
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}

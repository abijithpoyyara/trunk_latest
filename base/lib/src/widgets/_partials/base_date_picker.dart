import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'base_fake_text_field.dart';

class BaseDatePicker extends StatefulWidget {
  BaseDatePicker({
    Key key,
    this.hint,
    this.initialValue,
    this.displayTitle = "Date",
    this.onChanged,
    this.onSaved,
    this.autovalidate = false,
    this.validator,
    this.isEnabled = true,
    this.isVector = false,
    this.vector,
    this.suffixIcon,
    this.icon,
    this.disablePreviousDates = false,
    this.disableFutureDate = false,
  }) : super(key: key);

  final String hint;
  final bool isEnabled;
  final String displayTitle;
  final DateTime initialValue;
  final ValueSetter<DateTime> onChanged;
  final ValueSetter<DateTime> onSaved;
  final FormFieldValidator<DateTime> validator;
  final bool autovalidate;
  final String vector;
  final bool isVector;
  final Widget suffixIcon;
  final IconData icon;
  final bool disablePreviousDates;
  final bool disableFutureDate;

  @override
  BaseDatePickerState createState() => BaseDatePickerState();
}

class BaseDatePickerState extends State<BaseDatePicker> {
  DateTime _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? DateTime.now();
  }

  String _format(DateTime date) => "${DateFormat.yMMMd().format(date)}";

  @override
  void didUpdateWidget(BaseDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return BaseFakeTextField<DateTime>(
      initialValue: _value,
      displayTitle: widget.displayTitle,
      validator: widget.validator,
      child: _value == null
          ? Text(
              widget.hint ?? "Select a date",
              style: _theme.bodyHint,
            )
          : Text(
              _format(_value),
              style: _theme.textfield,
              textAlign: TextAlign.start,
            ),
      onTap: widget.isEnabled
          ? (FormFieldState<DateTime> field) async {
              final DateTime value = await showDatePicker(
                initialDatePickerMode: DatePickerMode.day,
                context: context,
                initialDate: _value,
                firstDate: widget.disablePreviousDates
                    ?
                    //DateTime(1990, 1, 1).subtract(Duration(days: 0))
                    DateTime.now().subtract(Duration(days: 1))
                    : DateTime(1900, 8),
                lastDate: widget.disableFutureDate
                    ? DateTime.now().subtract(Duration(days: 1))
                    : DateTime(2101),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary:
                            themeData.primaryColor, // header background color
                        onPrimary: Colors.white,
                        // header text color// body text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          primary:
                              themeData.primaryColorDark, // button text color
                        ),
                      ),
                    ),
                    child: child,
                  );
                },
              );
              /*showDatePicker(
                context: context,
                initialDate: _value,
                firstDate: DateTime(1900, 8),
                lastDate: DateTime(2101),
              );*/

              if (value != null && value != _value) {
                setState(() {
                  _value = value;
                  field.didChange(value);
                  if (widget.onChanged != null) {
                    widget.onChanged(value);
                  }
                });
              }
            }
          : null,
      icon: widget.icon,
      onSaved: widget.onSaved,
      vector: widget.vector,
      isVector: widget.isVector,
      suffixIcon: widget.suffixIcon,
    );
  }
}

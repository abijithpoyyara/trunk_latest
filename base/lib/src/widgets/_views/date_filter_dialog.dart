import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';

showDateFilterDialog(BuildContext context,
    {@required void Function(DateTimeRange) onSubmit,
    DateTime fromDate,
    DateTime toDate}) async {
  final colors = BaseTheme.of(context).colors;
  ThemeData themeData = ThemeProvider.of(context);

  GlobalKey<_DateFilterDialogState> _childKey = GlobalKey();
  final now = DateTime.now();
  fromDate = fromDate ?? DateTime(now.year, now.month, 1);
  toDate = toDate ?? now;
  await baseShowChildDialog<void>(
    context: context,
    title: (_) => Text("Filter",
        style: BaseTheme.of(context)
            .title
            .copyWith(color: colors.white.withOpacity(.70))),
    childBuilder: (_) {
      return _DateFilterDialog(
          key: _childKey,
          onSubmit: onSubmit,
          fromDate: fromDate,
          toDate: toDate);
    },
    positiveBtnTitle: "Show Result",
    onPositiveButtonClick: () {
      if (_childKey.currentState.onSubmit()) Navigator.pop(context);
    },
    barrierDismissible: true,
  );
}

class _DateFilterDialog extends StatefulWidget {
  final Function(DateTimeRange) onSubmit;

  final DateTime fromDate;
  final DateTime toDate;

  const _DateFilterDialog({
    Key key,
    this.onSubmit,
    this.fromDate,
    this.toDate,
  }) : super(key: key);

  @override
  _DateFilterDialogState createState() => _DateFilterDialogState();
}

class _DateFilterDialogState extends State<_DateFilterDialog> {
  DateTime fromDate, toDate;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    fromDate = widget.fromDate;
    toDate = widget.toDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildDateField(
              "Start Date ", fromDate, (val) => setState(() => fromDate = val)),
          _buildDateField(
              "End Date ", toDate, (val) => setState(() => toDate = val)),
        ],
      ),
    );
  }

  Widget _buildDateField(
      String title, DateTime initialDate, Function(DateTime) onSaved) {
    return Container(
      color: ThemeProvider.of(context).scaffoldBackgroundColor,
      child: BaseDatePicker(
          isVector: true,
          hint: title,
          displayTitle: title,
          initialValue: initialDate,
          icon: Icons.calendar_today,
          autovalidate: true,
          validator: (val) => (val == null) ? "Please select date" : null,
          onSaved: onSaved),
    );
  }

  bool onSubmit() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      widget.onSubmit(DateTimeRange(start: fromDate, end: toDate));
      return true;
    }
    return false;
  }
}

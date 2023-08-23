import 'package:base/utility.dart';

import 'package:intl/intl.dart';

class AppDates extends BaseDates {
  AppDates(
    DateTime date, {
    String day = "EEE",
    String dd = "dd",
    String month = "MMMM",
    String year = "yyyy",
  }) : super(date ?? DateTime.now());

  String customFormat({String format = "dd-mm-yyyy"}) {
    DateFormat customDateFrmt = DateFormat(format);
    return customDateFrmt.format(date);
  }
}

import 'package:base/utility.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class
AppNumberFormat extends BaseNumberFormat {
  AppNumberFormat({@required num number}) : super(number: number);

  String formatCurrency() {
    final value = number ?? 0.000;
    final currencyFormat = new NumberFormat("###,###,##0.000");
    return currencyFormat.format(value.abs());
  }
 String thousandSeparator(){
    final formatter=new NumberFormat('#,##,000');
    return formatter.format(number);
  }
}

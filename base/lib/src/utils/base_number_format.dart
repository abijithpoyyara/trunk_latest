import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../utility.dart';

class BaseNumberFormat {
  final num number;

  BaseNumberFormat({@required this.number});

  String formatCurrency() {
    final value = number ?? 0.000;
    final currencyFormat = new NumberFormat("###,###,##0.00");
    return currencyFormat.format(value.abs());
  }

  String formatRate() {
    final value = number ?? 0.00000;
    final currencyFormat = new NumberFormat("#####,#####,####0.00000");
    return currencyFormat.format(value.abs());
  }

  String formatTotal() {
    final value = number ?? 0.00;
    final currencyFormat = new NumberFormat("##,##,#0.00");
    return currencyFormat.format(value.abs());
  }

  String thousandSeparator() {
    final formatter = new NumberFormat('#,##,000');
    return formatter.format(number);
  }
}

class BaseNumberFormat2 {
  static String _baseCurrencyFormat;

  static BaseNumberFormat2 _instance;

  factory BaseNumberFormat2() {
    _instance ??= BaseNumberFormat2._();
    return _instance;
  }

  BaseNumberFormat2._() {
    initConstants();
  }

  String get currencyFormat => _baseCurrencyFormat;

  initConstants() async {
    _baseCurrencyFormat = await BasePrefs.getString(BaseConstants.CURRENCY_KEY);
  }

  String formatCurrency(num number) {
    final value = number ?? 0.000;
    final formattedCurrency = new NumberFormat("###,###,###,##0.000");
    return formattedCurrency.format(value.abs());
  }
}

class BaseCurrencyField extends StatelessWidget {
  final num value;
  final TextStyle style;

  const BaseCurrencyField(this.value, {Key key, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(BaseNumberFormat2().formatCurrency(value), style: style);
  }
}

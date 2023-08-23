import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';

class TotalPayableCard extends StatelessWidget {
  final String totalRequestedAmnt;
  final String totalBudgetBooking;
  final String vatAmount;
  final String withHoldingTaxAmount;
  final bool hasTax;

  const TotalPayableCard(
      {Key key,
      this.totalRequestedAmnt,
      this.totalBudgetBooking,
      this.vatAmount,
      this.withHoldingTaxAmount,
      this.hasTax = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
          color: themeData.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (hasTax)
                    _TextTile(
                      title: "VAT",
                      value: vatAmount,
                    ),
                  if (hasTax)
                    _TextTile(
                      title: "WithHolding Tax",
                      value: withHoldingTaxAmount,
                    ),
                  _TextTile(
                    title: "Total Budget Booking",
                    value: totalBudgetBooking,
                  ),
                  _TextTile(
                    title: "Total Requested Amount",
                    value: totalRequestedAmnt,
                  ),
                ],
              ),
            ));
  }
}

class _TextTile extends StatelessWidget {
  final String title;
  final String value;

  const _TextTile({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? "",
              style: theme.body,
              textAlign: TextAlign.start,
            ),
            SizedBox(width: 4),
            Text(value ?? '0.0',
                style: theme.subhead1Bold, textAlign: TextAlign.end),
          ],
        ),

      ]),
    );
  }
}

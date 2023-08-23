import 'dart:ui';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';

class EmptyResultView extends StatelessWidget {
  const EmptyResultView({
    Key key,
    this.message = "No results",
    this.icon = Icons.equalizer,
    this.onRefresh,
  }) : super(key: key);

  final String message;
  final IconData icon;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final BaseTheme theme = BaseTheme.of(context);
    final ThemeData themeData = ThemeProvider.of(context);
    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SizedBox(height: height*.25,),
            Flexible(
              //  flex: FlexFit.loose,
              child: Icon(
                icon,
                color: BaseColors.of(context).accentColor,
                size: height * 1 / 18,
              ),
            ),
            //  const SizedBox(height: 8.0),
            Flexible(
                child: Text(
              message,
              style: theme.body2MediumHint.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            )),

            //  SizedBox(height: height * 1 / 32),
            if (onRefresh != null)
              RaisedButton.icon(
                  color: themeData.primaryColorDark,
                  shape: const StadiumBorder(),
                  colorBrightness: Brightness.dark,
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh")),
          ]),
    );
  }
}

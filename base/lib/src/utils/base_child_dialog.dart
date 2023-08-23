import 'dart:async' show Future;

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';

const double _borderRoundRadius = 32.0;

Future<T> baseShowChildDialog<T>({
  @required BuildContext context,
  Widget Function(BuildContext) childBuilder,
  Widget child,
  bool barrierDismissible = true,
  Widget Function(BuildContext) title,
  String positiveBtnTitle,
  String negativeBtnTitle,
  VoidCallback onPositiveButtonClick,
  VoidCallback onNegativeButtonClick,
}) {
  return childBuilder != null
      ? showDialog<T>(

          context: context,
          barrierDismissible: barrierDismissible,
          builder: (BuildContext context) => _BaseChoiceDialog(
                child: childBuilder,
                title: title,
                positiveBtnTitle: positiveBtnTitle,
                negativeBtnTitle: negativeBtnTitle,
                onPositiveButtonClick: onPositiveButtonClick,
                onNegativeButtonClick: onNegativeButtonClick,
              )
//          DialogAnimator(child: child)
          )
      : child != null
          ? showDialog<T>(

              context: context,
              barrierDismissible: barrierDismissible,
              builder: (BuildContext context) => child,
            )
          : null;
}

class _BaseChoiceDialog extends StatelessWidget {
  final Widget Function(BuildContext) title;
  final Widget Function(BuildContext) child;

  final String positiveBtnTitle;
  final String negativeBtnTitle;
  final VoidCallback onPositiveButtonClick;
  final VoidCallback onNegativeButtonClick;

  const _BaseChoiceDialog({
    Key key,
    this.title,
    @required this.child,
    this.positiveBtnTitle,
    this.negativeBtnTitle,
    this.onPositiveButtonClick,
    this.onNegativeButtonClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme _theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return AlertDialog(

      backgroundColor: themeData.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_borderRoundRadius))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (title != null) Center(child: title(context)),
            if (title != null) SizedBox(height: 22.0),
            Center(
                child: Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 24.0),
                    child: child(context))),
            SizedBox(height: 16.0),
            Container(
                decoration: BoxDecoration(
                  color: themeData.primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(_borderRoundRadius),
                      bottomRight: Radius.circular(_borderRoundRadius)),
                ),
                child: IntrinsicHeight(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      if (negativeBtnTitle != null)
                        Expanded(
                            child: _Button(
                          child: Text("$negativeBtnTitle",
                              style: _theme.body2
                                  .copyWith(color: _theme.colors.white)),
                          onPressed: () => onNegativeButtonClick(),
                        )),
                      if (negativeBtnTitle != null)
                        VerticalDivider(
                          color: _theme.colors.accentColor,
                          width: 2,
                          thickness: 1,
                        ),
                      Expanded(
                          child: _Button(
                        child: Text(positiveBtnTitle ?? "OK",
                            style: _theme.body
                                .copyWith(color: themeData.accentColor)),
                        onPressed: () => onPositiveButtonClick(),
                      ))
                    ]))),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const _Button({Key key, this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = BaseTheme.of(context).colors;
    ThemeData themeData = ThemeProvider.of(context);
    return FlatButton(
        // color: themeData.primaryColorDark,
        padding: EdgeInsets.zero,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
            margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
            child: child),
        onPressed: onPressed);
  }
}

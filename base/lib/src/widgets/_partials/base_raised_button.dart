import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';

class BaseRaisedButton extends StatelessWidget {
  const BaseRaisedButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color = Colors.white,
    this.backgroundColor,
    this.padding,
    this.shape,
    this.enabled = true,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Color color;
  final Color backgroundColor;
  final bool enabled;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return FlatButton(
        color: enabled
            ? backgroundColor ?? themeData.primaryColor
            : themeData.secondaryHeaderColor,
        padding: padding ?? EdgeInsets.all(2),
        child: DefaultTextStyle(
          style: BaseTheme.of(context).button.copyWith(color: color),
          child: child,
        ),
        onPressed: enabled ? onPressed : null,
        shape: shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)));
  }
}

class BaseRaisedRoundButton extends StatelessWidget {
  const BaseRaisedRoundButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color = Colors.white,
    this.backgroundColor,
    this.padding,
    this.radius,
    this.enabled = true,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Color color;
  final Color backgroundColor;
  final double radius;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor:
            enabled ? backgroundColor : Theme.of(context).disabledColor,
//        foregroundColor: color,
        radius: radius ?? 25,
        child: FlatButton(
//        color: backgroundColor ?? kPrimaryColor,
          padding: padding ?? EdgeInsets.all(8),
          child: DefaultTextStyle(
            style: BaseTheme.of(context).button.copyWith(color: color),
            child: child,
          ),
          onPressed: enabled ? onPressed : null,

//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23))
        ));
  }
}

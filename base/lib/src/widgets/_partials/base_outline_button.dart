import 'package:base/resources.dart';
import 'package:flutter/material.dart';

class BaseOutlineButton extends StatelessWidget {
  const BaseOutlineButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color,
    this.foregroundColor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Color color;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final _borderColor = BaseColors.of(context).primaryColor;
    return OutlineButton(
      highlightedBorderColor: color,
      disabledBorderColor: Colors.transparent,
      padding: padding,
      child: DefaultTextStyle(
        style: BaseTheme.of(context).button.copyWith(color: foregroundColor),
        child: child,
      ),
      onPressed: onPressed,
      borderSide: BorderSide(color: color ?? Colors.white, width: 2.0),
    );
  }
}

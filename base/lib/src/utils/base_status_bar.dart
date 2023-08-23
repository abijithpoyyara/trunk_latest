import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BaseStatusBar extends StatelessWidget {
  const BaseStatusBar({
    Key key,
    this.brightness = Brightness.dark,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: brightness == Brightness.dark
          ? SystemUiOverlayStyle.dark.copyWith()
          : SystemUiOverlayStyle.light
              .copyWith(statusBarIconBrightness: Brightness.dark),
      child: child,
    );
  }
}

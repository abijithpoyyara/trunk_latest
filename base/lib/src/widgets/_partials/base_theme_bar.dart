import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
class BaseThemeBar extends StatelessWidget {
  const BaseThemeBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*1.0,
      height:MediaQuery.of(context).size.width*.05,
        color: ThemeProvider.of(context).primaryColor ?? Colors.white,
    );
  }
}

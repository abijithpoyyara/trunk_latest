import 'package:base/res/values/base_colors.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

class ThemeBar extends StatelessWidget {
  const ThemeBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeProvider.of(context);
    return Container(
      width: MediaQuery.of(context).size.width*1.0,
      height:MediaQuery.of(context).size.width*.10,
      color: themeData.primaryColor,

    );
  }
}
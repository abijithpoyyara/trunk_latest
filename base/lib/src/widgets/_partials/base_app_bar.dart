import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'base_back_button.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key key,
    @required this.title,
    this.actions,
    this.leading,
    this.useLeading = true,
    this.elevation = 2.0,
    this.bottom,
    this.backcolor,
    this.brightness,
    this.centerTitle = false,
  }) : super(key: key);

  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final double elevation;
  final bool useLeading;
  final PreferredSizeWidget bottom;
  final Brightness brightness;
  final bool centerTitle;
  final Color backcolor;

  @override
  Widget build(BuildContext context) {
    final _style = BaseTheme.of(context).appBarTitle;

    return AppBar(
      brightness: brightness ?? Brightness.light,
      backgroundColor:ThemeProvider.of(context).primaryColor ?? Colors.white,
      automaticallyImplyLeading: useLeading,
      titleSpacing: 0,
      leading:
          useLeading ? leading ?? BaseBackButton(color: Colors.white) : null,
      title: DefaultTextStyle(
        child: title,
        style: _style,
      ),
      elevation: elevation,
      centerTitle: false,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom != null ? bottom.preferredSize.height : 0),
      );
}

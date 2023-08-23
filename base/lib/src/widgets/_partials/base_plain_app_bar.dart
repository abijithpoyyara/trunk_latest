import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';

class BasePlainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BasePlainAppBar({
    Key key,
    this.leading,
    this.title,
    this.actions,
  }) : super(key: key);

  final String title;
  final List<Widget> actions;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: leading ??
          const BaseBackButton(
            color: Colors.white,
          ),
      title: title != null
          ? Text(
              title,
              style: BaseTheme.of(context).appBarTitle.copyWith(
                    color: Colors.white,
                  ),
            )
          : null,
      actions: actions,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

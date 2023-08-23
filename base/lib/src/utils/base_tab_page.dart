import 'package:flutter/widgets.dart';

class BaseTabPage {
  const BaseTabPage(
      {@required this.title, this.icon, this.body, this.tabIndex});

  final int tabIndex;
  final String title;
  final Widget body;
  final Icon icon;
}

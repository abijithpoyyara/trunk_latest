import 'package:base/services.dart';
import 'package:flutter/widgets.dart';

class MenuModel {
  MenuModel(
      {Key key,
      this.icon,
      this.color,
      this.title,
      this.subTitle,
      this.rightFlag,
      this.enabled = true,
      this.onPressed,
      this.hasBadge = false,
      this.module,
      this.publicItem = false,
      this.vector});

  IconData icon;
  bool publicItem;
  Color color;
  String title;
  String subTitle;
  String rightFlag;
  bool enabled;
  bool hasBadge;
  Function onPressed;
  ModuleListModel module;
  String vector;

  @override
  String toString() {
    return 'title : $title  ' +
        'subTitle : $subTitle  ' +
        'publicItem : $publicItem  ' +
        'rightFlag : $rightFlag  ' +
        'enabled : $enabled  ';
  }
}

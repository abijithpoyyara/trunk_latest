import 'package:base/utility.dart';
import 'package:flutter/material.dart';

class AppSnackBar extends BaseSnackBar {
  AppSnackBar.of(BuildContext context)
      : assert(context != null),
        super.of(context);

  AppSnackBar.ofKey(GlobalKey<ScaffoldState> key)
      : assert(key != null),
        super.ofKey(key);
}

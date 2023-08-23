import 'package:base/utility.dart';
import 'package:flutter/material.dart';

abstract class BaseSnackBarProvider {
  GlobalKey<ScaffoldState> get scaffoldKey;

  void showInSnackBar(String value, [Duration duration]) =>
      BaseSnackBar.ofKey(scaffoldKey).show(
        value,
        duration: duration,
      );

  void closeLoadingSnackBar() => BaseSnackBar.ofKey(scaffoldKey).hide();

  void showLoadingSnackBar([Widget content]) =>
      BaseSnackBar.ofKey(scaffoldKey).loading(
        content: content,
      );
}

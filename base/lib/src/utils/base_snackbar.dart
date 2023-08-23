import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

class BaseSnackBar {
  BaseSnackBar.of(BuildContext context)
      : assert(context != null),
        state = Scaffold.of(context);

  BaseSnackBar.ofKey(GlobalKey<ScaffoldState> key)
      : assert(key != null),
        state = key.currentState;

  final ScaffoldState state;

  void show(String value, {Duration duration}) {
    hide();
    assert(value != null);
    state?.showSnackBar(
      SnackBar(
        backgroundColor: ThemeProvider.of(state.context).primaryColor,
        content: Text(
          value,
          style: BaseTheme.of(state.context)
              .body2Medium
              .copyWith(color: Colors.white),
        ),
        duration: duration ?? const Duration(seconds: 7),
      ),
    );
  }

  void hide() => state?.hideCurrentSnackBar();

  void loading({Widget content}) {
    hide();
    state?.showSnackBar(
      BaseLoadingSnackBar(content: content),
    );
  }
}

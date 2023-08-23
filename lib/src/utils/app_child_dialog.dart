import 'dart:async' show Future;

import 'package:base/utility.dart' as baseDialog;
import 'package:flutter/material.dart'
    show required, BuildContext, Widget, showDialog;

Future<T> appShowChildDialog<T>({
  @required BuildContext context,
  @required Widget child,
  bool barrierDismissible = true,
}) {
  return baseDialog.baseShowChildDialog<T>(
    context: context,
    child: child,
    barrierDismissible: barrierDismissible,
  );
}

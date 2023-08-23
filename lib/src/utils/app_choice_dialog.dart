import 'dart:async';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';

Future<bool> appChoiceDialog({
  String title,
  @required String message,
  @required BuildContext context,
}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => _AppChoiceDialog(
        title: title,
        message: message,
      ),
    );



class _AppChoiceDialog extends BaseChoiceDialog {
  const _AppChoiceDialog({
    Key key,
    @required String title,
    @required String message,
  }) : super(
          key: key,
          title: title,
          message: message,
        );
}

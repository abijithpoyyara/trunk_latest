import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';

class BaseCloseButton extends StatelessWidget {
  const BaseCloseButton({
    Key key,
    this.color,
    this.onPop,
  }) : super(key: key);

  final Color color;
  final VoidCallback onPop;

  @override
  Widget build(BuildContext context) {
    return BaseClearButton(
      child: Icon(
        Icons.close,
        color: color ?? BaseTheme.of(context).appBarTitle.color,
      ),
      onPressed: onPop ?? () => Navigator.maybePop(context),
    );
  }
}

import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';

class BaseBackButton extends StatelessWidget {
  const BaseBackButton({
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
        Icons.arrow_back,
        color: color ?? BaseTheme.of(context).appBarTitle.color,
        size: 18.0,
      ),
      onPressed: onPop ?? () => Navigator.maybePop(context),
    );
  }
}

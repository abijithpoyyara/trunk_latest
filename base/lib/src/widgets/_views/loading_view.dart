import 'package:base/res/values.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class BaseLoadingView extends StatelessWidget {
  final String message;
  final TextStyle style;

  const BaseLoadingView({Key key, this.message, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          BaseLoadingSpinner(size: 65),
          SizedBox(height: 20),
          Text(
            message ?? "",
            style: style ?? BaseTheme.of(context).body2,
          )
        ]);
  }
}

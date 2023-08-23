import 'package:base/resources.dart';
import 'package:flutter/material.dart';

class ErrorResultView extends StatelessWidget {
  const ErrorResultView({
    Key key,
    this.message = "Error occured",
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final BaseTheme theme = BaseTheme.of(context);
    return Opacity(
      opacity: .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            size: 50.0,
          ),
          const SizedBox(height: 16.0),
          Text(
            message,
            style: theme.small.copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

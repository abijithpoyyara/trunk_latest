import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';

Future<bool> baseChoiceDialog({
  String title,
  @required String message,
  @required BuildContext context,
}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => BaseChoiceDialog(
        title: title,
        message: message,
      ),
    );

class BaseChoiceDialog extends StatelessWidget {
  const BaseChoiceDialog({
    Key key,
    @required this.title,
    @required this.message,
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final _theme = BaseTheme.of(context);
    final _colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
        backgroundColor: themeData.scaffoldBackgroundColor,
        title: title != null ? Center(child: Text(title)) : null,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        content: Container(
            height: height * .2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        message != null
                            ? Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(message),
                              )
                            : Text("Are you sure to  save this"),
                        message != null ? Text("") : Text(" requisition ?")
                      ],
                    )),
                message != null
                    ? SizedBox(
                        height: 12,
                      )
                    : SizedBox(
                        height: height * .04,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: height * .07,
                      width: width * .3,
                      child: BaseClearButton(
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: themeData.primaryColorDark,
                        color: _colors.white.withOpacity(.70),
                        child: const Text("Yes"),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ),
                    Container(
                      height: height * .07,
                      width: width * .3,
                      child: BaseClearButton(
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: _colors.white,
                        color: themeData.primaryColorDark,
                        child: const Text("No"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ),
                  ],
                )
              ],
            ))
        //  Text(message),
        //  titleTextStyle: _theme.title.copyWith(color: _colors.primaryColor),
        //  contentTextStyle: _theme.subhead1Semi.copyWith(height: 1.5),
        //  contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
        //  elevation: 2,
        //  actionsPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        //  actions: <Widget>[
        // Align(alignment: Alignment.bottomLeft,
        //   child: BaseClearButton(
        //
        //       backgroundColor: _colors.selectedColor,
        //       color: _colors.white.withOpacity(.70),
        //       child: const Text("Close"),
        //       onPressed: () => Navigator.pop(context, false),
        //     ),
        // ), BaseClearButton(
        //     color: _colors.white,
        //     child: const Text("Continue"),
        //     onPressed: () => Navigator.pop(context, true),
        //   ),
        //
        //  ],
        );
  }
}

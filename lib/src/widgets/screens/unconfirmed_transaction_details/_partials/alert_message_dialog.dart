import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/widgets/screens/homepage/homepage.dart';

showAlertMessageDialog(BuildContext context, String message, String title,
    VoidCallback onSuccess, ) async {
  await baseShowChildDialog<bool>(

      context: context,
      child: AlertMessageDialog(title: title, message: message),
      barrierDismissible: true);
  onSuccess();
}

class AlertMessageDialog extends StatelessWidget {
  final String message;
  final String title;


  AlertMessageDialog({Key key, this.message, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTitleTheme = BaseTheme.of(context).subhead1Bold;
    final colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Material(
          color: themeData.primaryColor,
          borderRadius: BorderRadius.circular(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 22.0),
              Icon(
                Icons.announcement,
                size: 30,
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //   child:
                  Expanded(
                    child: Text(
                      title ?? 'Success ',
                      style: textTitleTheme.copyWith(
                          color: colors.white,
                          fontWeight: BaseTextStyle.semibold,
                          fontSize: 18,
                          letterSpacing: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //  ),
                ],
              ),
              const SizedBox(height: 18.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '$message',
                  textAlign: TextAlign.center,
                  style: BaseTheme.of(context).subhead1.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(.70)),
                ),
              ),
              const SizedBox(height: 22.0),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .5,
                    child: RaisedButton(
                      color: themeData.primaryColorDark,
                      onPressed: () {

                          Navigator.pop(context, false);

                      },
                      child: Text(
                        'OK',
                      ),
                      textColor: colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )),
              const SizedBox(height: 22.0),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UpdateSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTitleTheme = BaseTheme.of(context).subhead1Bold;

    final String statusMessage = "${'Record updated successfully'}";

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Material(
          color: ThemeProvider.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 22.0),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * .09),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 22.0),
                    SvgPicture.asset(BaseVectors.success),
                  ],
                ),
              ),
              const SizedBox(height: 13.0),
              Text(
                'Success ',
                style: textTitleTheme.copyWith(
                    color: Colors.white,
                    fontWeight: BaseTextStyle.semibold,
                    fontSize: 18,
                    letterSpacing: 1.5),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15.0),
              Text(
                '$statusMessage   ',
              ),
              const SizedBox(height: 15.0),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                    color:  ThemeProvider.of(context).primaryColorDark,
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'OK',
                    ),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )),
              const SizedBox(height: 22.0),
            ],
          ),
        ),
      ),
    );
  }
}

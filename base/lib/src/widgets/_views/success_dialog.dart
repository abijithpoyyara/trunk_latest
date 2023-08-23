import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

showSuccessDialog(BuildContext context, String message, String title,
    VoidCallback onSuccess) async {
  await baseShowChildDialog<bool>(
      context: context,
      child: SuccessDialog(title: title, message: message),
      barrierDismissible: true);
  onSuccess();
}

class SuccessDialog extends StatelessWidget {
  final String message;
  final String title;

  const SuccessDialog({Key key, this.message, this.title}) : super(key: key);

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
              SvgPicture.asset(BaseVectors.success),
              const SizedBox(height: 15.0),
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
              const SizedBox(height: 24.0),
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
                        Navigator.pop(context, true);
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

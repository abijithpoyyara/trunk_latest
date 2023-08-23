import 'package:base/res/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BaseTheme extends InheritedWidget {
  final BaseColors colors;
  final BaseTextStyle style;

  BaseTheme({
    @required this.style,
    @required this.colors,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(BaseTheme oldWidget) => false;

  factory BaseTheme.of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect: BaseTheme);
  }

  Widget build(BuildContext context) => BaseTheme(
        child: child,
        style: style,
        colors: colors,
      );

  ThemeData getDefaultTheme(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    return ThemeData(
      accentColor: colors.white,
      primaryColor: colors.primaryColor,
      brightness: null,
      scaffoldBackgroundColor: colors.secondaryColor,
      iconTheme: IconThemeData().copyWith(color: colors.secondaryDark),
      accentIconTheme: IconThemeData().copyWith(color: colors.secondaryDark),
      textTheme: BaseTextStyle(
        colors: colors,
        bodyText2: ThemeData().textTheme.bodyText2.merge(body2),
        bodyText1: ThemeData().textTheme.bodyText1.merge(body),
        caption: ThemeData().textTheme.bodyText2.merge(body2),
        headline1: ThemeData().textTheme.headline1.merge(headline),
        headline2: ThemeData().textTheme.headline2.merge(display2),
        headline3: ThemeData().textTheme.headline3.merge(display3),
        headline4: ThemeData().textTheme.headline4.merge(display4),
        headline5: ThemeData().textTheme.headline5.merge(display4Bold),
        headline6: ThemeData().textTheme.headline6.merge(title),
        subtitle1: ThemeData().textTheme.subtitle1.merge(subhead1),
        subtitle2: ThemeData().textTheme.subtitle2.merge(subhead2),
        button: ThemeData().textTheme.button.merge(button),
      ),

      // appBarTheme: AppBarTheme(
      //     iconTheme: IconThemeData().copyWith(color: colors.accentColor)),

      appBarTheme:
          AppBarTheme(iconTheme: IconThemeData().copyWith(color: colors.white)),
      canvasColor: colors.primaryColor,
      buttonColor: colors.secondaryDark,
      buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          buttonColor: colors.secondaryDark,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
//        ThemeData().buttonTheme.copyWith(height: 48.0),
      inputDecorationTheme: InputDecorationTheme(
          isDense: false,
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.accentColor, width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.accentColor, width: 2.0)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.accentColor)),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.borderSideErrorColor)),
          contentPadding: EdgeInsets.only(top: 13.0, bottom: 12.0),
          hintStyle: textfieldLabel.copyWith(color: colors.hintColor),
          labelStyle: textfieldLabel.copyWith(),
          errorStyle: errorStyle,
          counterStyle: textfieldLabel.copyWith(color: Colors.white)),
      cursorColor: colors.white,
//        fontFamily: AppFonts.base,
      hintColor: colors.hintColor,
      dividerColor: colors.borderColor,
    );
  }

//   ThemeData getGreenTheme(BuildContext context) {
//     BaseColors colors = BaseColors.of(context);
//     return ThemeData(
//       accentColor: colors.white,
//       primaryColor: Color(0xFF16C72E),
//       brightness: null,
//       scaffoldBackgroundColor: Color(0xFF45D258),
//       iconTheme: IconThemeData().copyWith(color: Color(0xFF0F8B20)),
//       accentIconTheme: IconThemeData().copyWith(color: Color(0xFF0F8B20)),
//       textTheme: BaseTextStyle(
//         colors: colors,
//         bodyText2: ThemeData().textTheme.bodyText2.merge(body2),
//         bodyText1: ThemeData().textTheme.bodyText1.merge(body),
//         caption: ThemeData().textTheme.bodyText2.merge(body2),
//         headline1: ThemeData().textTheme.headline1.merge(headline),
//         headline2: ThemeData().textTheme.headline2.merge(display2),
//         headline3: ThemeData().textTheme.headline3.merge(display3),
//         headline4: ThemeData().textTheme.headline4.merge(display4),
//         headline5: ThemeData().textTheme.headline5.merge(display4Bold),
//         headline6: ThemeData().textTheme.headline6.merge(title),
//         subtitle1: ThemeData().textTheme.subtitle1.merge(subhead1),
//         subtitle2: ThemeData().textTheme.subtitle2.merge(subhead2),
//         button: ThemeData().textTheme.button.merge(button),
//       ),
//
//       // appBarTheme: AppBarTheme(
//       //     iconTheme: IconThemeData().copyWith(color: colors.accentColor)),
//
//       appBarTheme:
//           AppBarTheme(iconTheme: IconThemeData().copyWith(color: colors.white)),
//       canvasColor: Color(0xFF16C72E),
//       buttonColor: Color(0xFF0F8B20),
//       buttonTheme: ButtonThemeData(
//           textTheme: ButtonTextTheme.normal,
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           buttonColor: Color(0xFF0F8B20),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(8)))),
// //        ThemeData().buttonTheme.copyWith(height: 48.0),
//       inputDecorationTheme: InputDecorationTheme(
//           isDense: false,
//           focusedErrorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: colors.accentColor, width: 2.0)),
//           focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: colors.accentColor, width: 2.0)),
//           enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: colors.accentColor)),
//           errorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: colors.borderSideErrorColor)),
//           contentPadding: EdgeInsets.only(top: 13.0, bottom: 12.0),
//           hintStyle: textfieldLabel.copyWith(color: colors.hintColor),
//           labelStyle: textfieldLabel.copyWith(),
//           errorStyle: errorStyle,
//           counterStyle: textfieldLabel.copyWith(color: Colors.white)),
//       cursorColor: colors.white,
// //        fontFamily: AppFonts.base,
//       hintColor: colors.hintColor,
//       dividerColor: colors.borderColor,
//     );
//   }
//
//   ThemeData getBlueTheme(BuildContext context) {
//     BaseColors colors = BaseColors.of(context);
//     return ThemeData(
//       accentColor: colors.white,
//       primaryColor: Color(0xFF367AFE),
//       brightness: null,
//       scaffoldBackgroundColor: Color(0xFF9BBDFF),
//       iconTheme: IconThemeData().copyWith(color: Color(0xFF0347CB)),
//       accentIconTheme: IconThemeData().copyWith(color: Color(0xFF0347CB)),
//       textTheme: BaseTextStyle(
//         colors: colors,
//         bodyText2: ThemeData().textTheme.bodyText2.merge(body2),
//         bodyText1: ThemeData().textTheme.bodyText1.merge(body),
//         caption: ThemeData().textTheme.bodyText2.merge(body2),
//         headline1: ThemeData().textTheme.headline1.merge(headline),
//         headline2: ThemeData().textTheme.headline2.merge(display2),
//         headline3: ThemeData().textTheme.headline3.merge(display3),
//         headline4: ThemeData().textTheme.headline4.merge(display4),
//         headline5: ThemeData().textTheme.headline5.merge(display4Bold),
//         headline6: ThemeData().textTheme.headline6.merge(title),
//         subtitle1: ThemeData().textTheme.subtitle1.merge(subhead1),
//         subtitle2: ThemeData().textTheme.subtitle2.merge(subhead2),
//         button: ThemeData().textTheme.button.merge(button),
//       ),
//
//       // appBarTheme: AppBarTheme(
//       //     iconTheme: IconThemeData().copyWith(color: colors.accentColor)),
//
//       appBarTheme:
//           AppBarTheme(iconTheme: IconThemeData().copyWith(color: colors.white)),
//       canvasColor: Color(0xFF367AFE),
//       buttonColor: Color(0xFF0347CB),
//       buttonTheme: ButtonThemeData(
//           textTheme: ButtonTextTheme.normal,
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           buttonColor: Color(0xFF0347CB),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(8)))),
// //        ThemeData().buttonTheme.copyWith(height: 48.0),
//       inputDecorationTheme: InputDecorationTheme(
//           isDense: false,
//           focusedErrorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: colors.accentColor, width: 2.0)),
//           focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: colors.accentColor, width: 2.0)),
//           enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: colors.accentColor)),
//           errorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: colors.borderSideErrorColor)),
//           contentPadding: EdgeInsets.only(top: 13.0, bottom: 12.0),
//           hintStyle: textfieldLabel.copyWith(color: colors.hintColor),
//           labelStyle: textfieldLabel.copyWith(),
//           errorStyle: errorStyle,
//           counterStyle: textfieldLabel.copyWith(color: Colors.white)),
//       cursorColor: colors.white,
// //        fontFamily: AppFonts.base,
//       hintColor: colors.hintColor,
//       dividerColor: colors.borderColor,
//     );
//   }

  /// Extra small text style with font size 10
  TextStyle get xxsmall => _text10Style;

  TextStyle get xxsmallHint => xxsmall.copyWith(color: colors.hintColor);

  TextStyle get xsmall => _text11Style;

  TextStyle get xsmallHint => xsmall.copyWith(color: colors.hintColor);

  TextStyle get small => _text12Style;

  TextStyle get smallMedium => small.copyWith(fontWeight: BaseTextStyle.medium);

  TextStyle get smallSemi => small.copyWith(fontWeight: BaseTextStyle.semibold);

  TextStyle get smallLight => small.copyWith(fontWeight: BaseTextStyle.light);

  TextStyle get smallHint => small.copyWith(color: colors.hintColor);

  TextStyle get body => _text13Style;

  TextStyle get bodyMedium => body.copyWith(fontWeight: BaseTextStyle.medium);

  TextStyle get bodySemi => body.copyWith(fontWeight: BaseTextStyle.semibold);

  TextStyle get bodyBold => body.copyWith(fontWeight: BaseTextStyle.bold);

  TextStyle get bodyHint => body.copyWith(color: colors.accentColor);

  TextStyle get body2 => _text14Style;

  TextStyle get body2Hint => body2.copyWith(color: colors.hintColor);

  TextStyle get body2Light => body2.copyWith(fontWeight: BaseTextStyle.light);

  TextStyle get body2Medium => body2.copyWith(fontWeight: BaseTextStyle.medium);

  TextStyle get body2MediumHint => body2Medium.copyWith(
      color: colors?.hintColor, fontWeight: BaseTextStyle.medium);

  TextStyle get button => body2Medium;

  TextStyle get title =>
      _text18Style.copyWith(fontWeight: BaseTextStyle.medium);

  TextStyle get subhead1 => _text15Style;

  TextStyle get subhead1Semi =>
      subhead1.copyWith(fontWeight: BaseTextStyle.semibold);

  TextStyle get subhead1Bold =>
      subhead1.copyWith(fontWeight: BaseTextStyle.medium);

  TextStyle get subhead1Light =>
      subhead1.copyWith(fontWeight: BaseTextStyle.light);

  TextStyle get subhead2 => _text14Style;

  TextStyle get subhead3 => _text16Style;

  TextStyle get headline =>
      _text20Style.copyWith(fontWeight: BaseTextStyle.medium);

  TextStyle get appBarTitle =>
      subhead1Bold.copyWith(letterSpacing: .35, color: Colors.white);

  TextStyle get display1 => _text20Style;

  TextStyle get display1Light =>
      display1.copyWith(fontWeight: BaseTextStyle.light);

  TextStyle get display1Semi =>
      display1.copyWith(fontWeight: BaseTextStyle.semibold);

  TextStyle get display2 => _text24Style.copyWith(height: 1.05);

  TextStyle get display2Semi =>
      display2.copyWith(fontWeight: BaseTextStyle.semibold);

  TextStyle get display2Bold =>
      display2.copyWith(fontWeight: BaseTextStyle.bold);

  TextStyle get display3 => _text28Style;

  TextStyle get display4 => _text30Style.copyWith(color: colors?.primaryColor);

  TextStyle get display4Light =>
      display4.copyWith(fontWeight: BaseTextStyle.light);

  TextStyle get display4Bold => _text32Style;

  TextStyle get textfield =>
      _text15Style.copyWith(fontWeight: BaseTextStyle.semibold);

  TextStyle get textfieldLabel =>
      body2.copyWith(fontWeight: BaseTextStyle.medium);

  TextStyle get errorStyle => small.copyWith(color: Colors.red[700]);

//  TextStyle get errorStyle =>      small.copyWith(color: colors?.borderSideErrorColor);

  TextStyle get _text10Style => style.appFontRegular(10.0);

  TextStyle get _text11Style => style.appFontRegular(11.0);

  TextStyle get _text12Style => style.appFontRegular(12.0);

  TextStyle get _text13Style => style.appFontRegular(13.0);

  TextStyle get _text14Style => style.appFontRegular(14.0);

  TextStyle get _text15Style => style.appFontRegular(15.0);

  TextStyle get _text16Style => style.appFontRegular(16.0);

  TextStyle get _text18Style => style.appFontMedium(18.0);

  TextStyle get _text20Style => style.appFontRegular(20.0);

  TextStyle get _text24Style => style.appFontRegular(24.0);

  TextStyle get _text28Style => style.appFontMedium(28.0);

  TextStyle get _text30Style => style.appFontRegular(30.0);

  TextStyle get _text32Style => style.appFontMedium(32.0);
}

import 'package:base/res/values/base_colors.dart';
import 'package:flutter/material.dart';

const double kBaseScreenHeight = 896.0;
const double kBaseScreenWidth = 414.0;

const double kButtonHeight = 60.0;
const double kButtonMinWidth = 200.0;

const BorderRadius kBorderRadius = const BorderRadius.all(Radius.circular(4.0));

class BaseBorderSide extends BorderSide {
  const BaseBorderSide({
    Color color,
    BorderStyle style,
    double width,
  }) : super(
          color: color ?? border_color,
          style: style ?? BorderStyle.solid,
          width: width ?? 1.0,
        );
}

class _BaseStyle extends TextStyle {
  const _BaseStyle.appFont({
    double fontSize,
    FontWeight fontWeight,
    Color color,
  }) : super(
    fontFamily:'Roboto' ,
          inherit: false,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight ?? BaseTextStyle.regular,
          letterSpacing: -0.5,
          textBaseline: TextBaseline.alphabetic,
        );
}

class BaseTextStyle extends TextTheme {
  static const FontWeight light = FontWeight.w200;
  static const FontWeight regular = FontWeight.w300;
  static const FontWeight medium = FontWeight.w600;
  static const FontWeight semibold = FontWeight.w700;
  static const FontWeight bold = FontWeight.w900;
  final BaseColors colors;

  BaseTextStyle(
      {@required this.colors,
      TextStyle headline1,
      TextStyle headline2,
      TextStyle headline3,
      TextStyle headline4,
      TextStyle headline5,
      TextStyle headline6,
      TextStyle subtitle1,
      TextStyle subtitle2,
      TextStyle bodyText1,
      TextStyle bodyText2,
      TextStyle caption,
      TextStyle button,
      TextStyle overline})
      : super(
          headline1: headline1,
          headline2: headline2,
          headline3: headline3,
          headline4: headline4,
          headline5: headline5,
          headline6: headline6,
          subtitle1: subtitle1,
          subtitle2: subtitle2,
          bodyText1: bodyText1,
          bodyText2: bodyText2,
          caption: caption,
          button: button,
          overline: overline,
        );

  TextStyle appFont(double fontSize, Color color, FontWeight fontWeight) =>
      _BaseStyle.appFont(
          fontSize: fontSize, color: color, fontWeight: fontWeight);

  TextStyle appFontSize(double fontSize) =>
      _BaseStyle.appFont(fontSize: fontSize);

  TextStyle appFontColor(Color color) => _BaseStyle.appFont(color: color);

  TextStyle appFontLight(double fontSize, [Color color]) => _BaseStyle.appFont(
      fontSize: fontSize,
      fontWeight: light,
      color: color ?? colors.kTextBaseColor);

  TextStyle appFontRegular(double fontSize, [Color color]) =>
      _BaseStyle.appFont(
          fontSize: fontSize,
          fontWeight: regular,
          color: color ?? colors.kTextBaseColor);

  TextStyle appFontMedium(double fontSize, [Color color]) => _BaseStyle.appFont(
      fontSize: fontSize,
      fontWeight: medium,
      color: color ?? colors.kTextBaseColor);

  TextStyle appFontSemi(double fontSize, [Color color]) => _BaseStyle.appFont(
      fontSize: fontSize,
      fontWeight: semibold,
      color: color ?? colors.kTextBaseColor);

  TextStyle appFontBold(double fontSize, [Color color]) => _BaseStyle.appFont(
      fontSize: fontSize,
      fontWeight: bold,
      color: color ?? colors.kTextBaseColor);
}

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

class MyAppTheme {

  bool isDark;


  /// Default constructor
  MyAppTheme({@required this.isDark});

  ThemeData get defaultTheme {
    final primaryColor = Color(0xFFDF7D3E);
    final secondaryColor = Color(0xFFFA8F4B);
    final secondaryDark = Color(0xFF96562D);
    final accentColor=Colors.white;

    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme txtTheme = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    Color txtColor = txtTheme.bodyText1.color;
    TextStyle textStyle = TextStyle(fontWeight: FontWeight.normal);


    // ColorScheme colorScheme = ColorScheme(
    // // Decide how you want to apply your own custom them, to the MaterialApp
    // brightness: isDark ? Brightness.dark : Brightness.light,
    // primary: primaryColor,
    // primaryVariant: primaryColor,
    // secondary: secondaryColor,
    // secondaryVariant: secondaryDark,
    // background: secondaryColor,
    // surface: secondaryColor,
    // onBackground: secondaryColor,
    // onSurface: secondaryColor,
    // onError: Colors.red,
    // onPrimary: Colors.white,
    // onSecondary: Colors.white,
    // error: Colors.red.shade400);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    var t = ThemeData(textTheme: txtTheme,
        primaryColor : primaryColor,
        accentColor: Colors.white,
      scaffoldBackgroundColor: secondaryColor,
        brightness: null,
      primaryColorDark: secondaryDark,
     // canvasColor:primaryColor ,
      appBarTheme:
      AppBarTheme(iconTheme: IconThemeData().copyWith(color:accentColor)),
      buttonTheme:ButtonThemeData(
        textTheme: ButtonTextTheme.normal,
        //padding: EdgeInsets.symmetric(horizontal: 16),
    buttonColor:secondaryDark,
    //shape: RoundedRectangleBorder(
   // borderRadius: BorderRadius.all(Radius.circular(8)))
    ),
      cursorColor: accentColor,
      inputDecorationTheme:  InputDecorationTheme(
    isDense: false,
    focusedErrorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: accentColor)),
    focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: accentColor)),
    enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color:accentColor)),
    errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: accentColor)),
    contentPadding: EdgeInsets.only(top: 13.0, bottom: 12.0),
   // hintStyle: textfieldLabel.copyWith(color: colors.hintColor),
    //labelStyle: textfieldLabel.copyWith(),
   // errorStyle: errorStyle,
    //counterStyle: textfieldLabel.copyWith(color: Colors.white)
    ),

//        ThemeData().buttonTheme.copyWith(height: 48.0),
      iconTheme: IconThemeData(color: secondaryDark),
    ).copyWith(textTheme: TextTheme(bodyText1: textStyle));


    // We can also add on some extra properties that ColorScheme seems to miss

    /// Return the themeData which MaterialApp can now use
    return t;
  }

  ThemeData get blueTheme {
    final primaryColor = Color(0xFF367AFE);
    final secondaryColor = Color(0xFF9BBDFF);
    final secondaryDark = Color(0xFF0347CB);
    final  accentColor=Colors.white;

    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme txtTheme = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    Color txtColor = txtTheme.bodyText1.color;
    TextStyle textStyle = TextStyle(fontWeight: FontWeight.normal);



    // ColorScheme colorScheme = ColorScheme(
    // // Decide how you want to apply your own custom them, to the MaterialApp
    // brightness: isDark ? Brightness.dark : Brightness.light,
    // primary: primaryColor,
    // primaryVariant: primaryColor,
    // secondary: secondaryColor,
    // secondaryVariant: secondaryDark,
    // background: secondaryColor,
    // surface: secondaryColor,
    // onBackground: secondaryColor,
    // onSurface: secondaryColor,
    // onError: Colors.red,
    // onPrimary: Colors.white,
    // onSecondary: Colors.white,
    // error: Colors.red.shade400);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    var t = ThemeData(textTheme: txtTheme,
        primaryColor : primaryColor,
        accentColor: Colors.white,
        scaffoldBackgroundColor: secondaryColor,
      brightness: null,
      primaryColorDark: secondaryDark,
     // canvasColor:primaryColor ,
      appBarTheme:
      AppBarTheme(iconTheme: IconThemeData().copyWith(color:accentColor)),
      buttonTheme:ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
         // padding: EdgeInsets.symmetric(horizontal: 16),
          buttonColor:secondaryDark,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(8)))
      ),
      cursorColor: accentColor,
      inputDecorationTheme:  InputDecorationTheme(
        isDense: false,
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: accentColor)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: accentColor)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:accentColor,style: BorderStyle.solid)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: accentColor)),
        contentPadding: EdgeInsets.only(top: 13.0, bottom: 12.0),
        // hintStyle: textfieldLabel.copyWith(color: colors.hintColor),
        //labelStyle: textfieldLabel.copyWith(),
        // errorStyle: errorStyle,
        //counterStyle: textfieldLabel.copyWith(color: Colors.white)
      ),

//        ThemeData().buttonTheme.copyWith(height: 48.0),
//       iconTheme: IconThemeData(color: secondaryDark),
//     ).copyWith(textTheme: TextTheme(bodyText1: textStyle));


      iconTheme: IconThemeData(color: secondaryDark),
    ).copyWith(textTheme: TextTheme(bodyText1: textStyle));    // We can also add on some extra properties that ColorScheme seems to miss

    /// Return the themeData which MaterialApp can now use
    return t;
  }

  ThemeData get greenTheme {
    final primaryColor =  Color(0xFF16C72E);
    final secondaryColor = Color(0xFF45D258);
    final secondaryDark = Color(0xFF0F8B20);
    final accentColor =Colors.white;

    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme txtTheme = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    Color txtColor = txtTheme.bodyText1.color;
    TextStyle textStyle = TextStyle(fontWeight: FontWeight.normal);

    // ColorScheme colorScheme = ColorScheme(
    // // Decide how you want to apply your own custom them, to the MaterialApp
    // brightness: isDark ? Brightness.dark : Brightness.light,
    // primary: primaryColor,
    // primaryVariant: primaryColor,
    // secondary: secondaryColor,
    // secondaryVariant: secondaryDark,
    // background: secondaryColor,
    // surface: secondaryColor,
    // onBackground: secondaryColor,
    // onSurface: secondaryColor,
    // onError: Colors.red,
    // onPrimary: Colors.white,
    // onSecondary: Colors.white,
    // error: Colors.red.shade400);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    var t = ThemeData(textTheme: txtTheme,
        primaryColor : primaryColor,
        accentColor: Colors.white,
        scaffoldBackgroundColor: secondaryColor,
        brightness: null,
        primaryColorDark: secondaryDark,
      //canvasColor:primaryColor ,
      appBarTheme:
      AppBarTheme(iconTheme: IconThemeData().copyWith(color:accentColor)),
      buttonTheme:ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
         // padding: EdgeInsets.symmetric(horizontal: 16),
          buttonColor:secondaryDark,
          //shape: RoundedRectangleBorder(
             // borderRadius: BorderRadius.all(Radius.circular(8)))
      ),
      cursorColor: accentColor,
      inputDecorationTheme:  InputDecorationTheme(
        isDense: false,
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: accentColor)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: accentColor, )),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:accentColor)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: accentColor)),
        contentPadding: EdgeInsets.only(top: 13.0, bottom: 12.0),
        // hintStyle: textfieldLabel.copyWith(color: colors.hintColor),
        //labelStyle: textfieldLabel.copyWith(),
        // errorStyle: errorStyle,
        //counterStyle: textfieldLabel.copyWith(color: Colors.white)
      ),

      iconTheme: IconThemeData(color: secondaryDark),
    ).copyWith(textTheme: TextTheme(bodyText1: textStyle));    // We can also add on some extra properties that ColorScheme seems to miss

    /// Return the themeData which MaterialApp can now use
    return t;
  }

}
import 'package:base/res/values.dart';
import 'package:base/src/widgets/_partials/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../theme_config.dart';


const double itemHeight = 150;

class Appearance extends StatefulWidget {
  @override
  _AppearanceState createState() => _AppearanceState();
}

class _AppearanceState extends State<Appearance> {



  saveTheme(String themeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', themeName);
  }

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double itemWidth = width + itemHeight;

    print('@@@@@@@@@@@@@@');
    //   print(ThemeProvider.of(context));
    print(BaseTheme.of(context).getDefaultTheme(context));

    return Scaffold(
        appBar: BaseAppBar(
          title: Text("Appearance"),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white,width: 3),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        height: 150,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFFDF7D3E),
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Color(0xFFFA8F4B),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFF96562D),
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Default',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  ThemeSwitcher(
                                    builder: (context) {
                                      return Checkbox(
                                        shape: CircleBorder(),
                                        activeColor: Colors.black87,
                                        value: ThemeProvider.of(context) ==
                                            MyAppTheme(isDark: true)
                                                .defaultTheme,
                                        onChanged: (needDefault) {

                                          saveTheme('default');

                                          ThemeSwitcher.of(context)
                                              .changeTheme(
                                                  theme: needDefault
                                                      ? MyAppTheme(
                                                              isDark: true)
                                                          .defaultTheme
                                                      : MyAppTheme(
                                                              isDark: true)
                                                          .defaultTheme);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white,width: 3),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        height: 150,
                        child: Center(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xFF367AFE),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                              )),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Color(0xFF9BBDFF),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xFF0347CB),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Blue',
                                        style:
                                            TextStyle(color: Colors.black87)),
                                    ThemeSwitcher(
                                      builder: (context) {
                                        return Checkbox(
                                          shape: CircleBorder(),
                                          activeColor: Colors.black87,
                                          value: ThemeProvider.of(context) ==
                                              MyAppTheme(isDark: true)
                                                  .blueTheme,
                                          onChanged: (needBlue) {

                                            saveTheme('blue');

                                            ThemeSwitcher.of(context)
                                                .changeTheme(
                                                    theme: needBlue
                                                        ? MyAppTheme(
                                                                isDark: true)
                                                            .blueTheme
                                                        : MyAppTheme(
                                                                isDark: true)
                                                            .defaultTheme);
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white,width: 3),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        height: 150,
                        child: Center(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xFF16C72E),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                              )),
                                        ),
                                      ),
                                      Container(color: Colors.red),
                                      Expanded(
                                        child: Container(
                                          color: Color(0xFF45D258),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xFF0F8B20),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Green',
                                        style:
                                            TextStyle(color: Colors.black87)),
                                    ThemeSwitcher(
                                      builder: (context) {
                                        return Checkbox(
                                          shape: CircleBorder(),
                                          activeColor: Colors.black87,
                                          value: ThemeProvider.of(context) ==
                                              MyAppTheme(isDark: true)
                                                  .greenTheme,
                                          onChanged: (needGreen) {

                                            saveTheme('green');

                                            ThemeSwitcher.of(context)
                                                .changeTheme(
                                                    theme: needGreen
                                                        ? MyAppTheme(
                                                                isDark: true)
                                                            .greenTheme
                                                        : MyAppTheme(
                                                                isDark: true)
                                                            .defaultTheme);
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(flex: 1, child: Container()),
                ],
              )
            ],
          ),
        )
        // body: GridView.count(
        //   crossAxisCount: 2,
        //   childAspectRatio:height/itemWidth ,
        //   children: [
        //     ThemeStack(
        //       primaryColor: theme.colors.primaryColor,
        //       secondaryColor: theme.colors.secondaryColor,
        //       secondaryDark: theme.colors.secondaryDark,
        //       colorThemeTitle: "Default",
        //     ),
        //     ThemeStack(
        //       primaryColor: Color(0xFF367AFE),
        //       secondaryColor: Color(0xFF9BBDFF),
        //       secondaryDark: Color(0xFF0347CB),
        //       colorThemeTitle: "blue",
        //     ),
        //     ThemeStack(
        //       primaryColor: Color(0xFF16C72E),
        //       secondaryColor: Color(0xFF45D258),
        //       secondaryDark: Color(0xFF0F8B20),
        //       colorThemeTitle: "green",
        //     ),
        //   ],
        // ),
        );
  }


}

class ThemeStack extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color secondaryDark;
  final String colorThemeTitle;

  ThemeStack(
      {Key key,
      this.primaryColor,
      this.secondaryColor,
      this.secondaryDark,
      this.colorThemeTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    BaseTheme theme = BaseTheme.of(context);
    return Container(
        width: width * .11,
        height: height * .10,
        margin: EdgeInsets.all(height * .02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ],
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: width * .144,
                  height: height * .12,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(8)),
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: width * .144,
                  height: height * .12,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: width * .144,
                  height: height * .12,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(8)),
                    color: secondaryDark,
                  ),
                ),
              ),
            ),
            Positioned(
              left: width * .04,
              top: height * .113,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Text(
                      colorThemeTitle,
                      style:
                          theme.subhead1Semi.copyWith(color: theme.colors.dark),
                    ),
                    SizedBox(
                      width: width * .13,
                    ),
                    IconButton(
                        disabledColor: theme.colors.white,
                        icon: Icon(Icons.check_circle_rounded),
                        onPressed: () {})
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

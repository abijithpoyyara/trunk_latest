import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_colors.dart';
import 'package:base/res/values/base_style.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/src/widgets/_partials/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/home/home_viewmodel.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';

import 'helpers.dart';

class AccountSetting extends StatefulWidget {
  final HomeViewModel viewModel;
  final VoidCallback onLogout;

  const AccountSetting({Key key, this.viewModel, this.onLogout})
      : super(key: key);

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeData.primaryColor,
        appBar: BaseAppBar(
          title: Text(""),
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: height * .4,
                width: width,
                color: themeData.primaryColor,
                child: Stack(
                  children: [
                    Positioned(
                      left: width * .055,
                      top: height * .05,
                      child: Container(
                        width: width*.9,
                        height: height*.35,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                    width: width * .9,
                                    height: height * .26,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x05000000),
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                      color: themeData.scaffoldBackgroundColor,
                                    ),
                                    // padding: EdgeInsets.symmetric(vertical:40,horizontal: 2),
                                    padding: EdgeInsets.only(
                                      left: width*.05,
                                      right: width*.052,
                                      top: height*.075,
                                      bottom: height*.06,
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(flex:20,
                                          child: Text(
                                              widget.viewModel?.user?.userName ??
                                                  "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              softWrap: false),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                       Expanded(flex:10,
                                           child:Text(

                                         widget.viewModel?.user?.companyName ??
                                             "",
                                         textAlign: TextAlign.center,
                                         style: TextStyle(fontSize: 14.0),
                                         maxLines: 1,
                                         overflow: TextOverflow.fade,
                                         softWrap: false,
                                       )) ,
                                       Expanded(flex:10,
                                           child: Text(
                                         widget.viewModel?.user
                                             ?.companyLocation ??
                                             "",
                                         textAlign: TextAlign.center,
                                         style: TextStyle(fontSize: 14.0),
                                         maxLines: 1,
                                         overflow: TextOverflow.fade,
                                         softWrap: false,
                                       )),
                                      ],
                                    )),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: width * .3,
                                  height: height * .16,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: width * .3,
                                        height: height * .16,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: width * .3,
                                              height: height * .16,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: themeData.primaryColor,
                                                  width: 3,
                                                ),
                                                color: themeData.scaffoldBackgroundColor,
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: width * .28,
                                                  height: height * .14,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: themeData.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: width * .4,
                                            height: height * .12,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      width: width * .4,
                                                      height: height * .12,
                                                      child: Center(
                                                          child:
                                                              SvgPicture.asset(
                                                                  AppVectors
                                                                      .user))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Container(

                  height: MediaQuery.of(context).size.height * .08,
                  margin: EdgeInsets.all(15),
                  child: FlatButton(
                      color: themeData.primaryColorDark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        await _confirmLogout(context);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        child: Text(
                          // color: Colors.red,
                          // icon: Icons.power_settings_new,
                          "LOGOUT ALL",
                          style: style.subhead1.copyWith(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.17),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 6),
                      ))),
          ],
        ));
  }

  _confirmLogout(BuildContext context) async {
    final response = await appChoiceDialog(
      context: context,
      message: "Are you sure you want to logout ?",
    );

    if (response == true) {
      widget.onLogout();
    }
  }
}

import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/viewmodels/home/home_viewmodel.dart';
import 'package:redstars/src/utils/app_choice_dialog.dart';
import 'package:redstars/src/widgets/screens/company_listing_screen/company_listing.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/account_settings.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/home_screen.dart';
import 'package:redstars/src/widgets/screens/production_plan/production_plan_notification_detail_screen.dart';

enum AccountOptions {
  logout,
  aboutUs,
}

class TopButtonBar extends StatelessWidget {
  const TopButtonBar( {
    Key key,
    this.viewModel,
    @required this.onLogout,
  }) : super(key: key);

  final VoidCallback onLogout;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final BaseTheme theme = BaseTheme.of(context);
    final BaseColors colors = BaseColors.of(context);

    String Username = viewModel.user.userName;
    String Companyname = viewModel.user.companyName;
    return Align(
        alignment: Alignment.topRight,
        child: SafeArea(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(children: [
                SizedBox.fromSize(
                  size: const Size.square(63.0),
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.center,
                    child: Visibility(
                      visible:
                          viewModel?.isHasDisplayNotificationRight ?? false,
                      child: IconButton(
                          onPressed: () {
                            BaseNavigate(
                                context, Production_plan_notification_detail());
                          },
                          iconSize: 45,
                          color: Colors.white,
                          icon: Icon(Icons.notifications_active_outlined)),
                    ),
                  ),
                ),
                        SizedBox(width: 3),
                        SizedBox.fromSize(
                          size: const Size.square(48.0),
                          child: Container(
                            padding: const EdgeInsets.all(1.5),
                            alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: _onTapSettings(context),
                                child: SvgPicture.asset(
                                  AppVectors.settings,
                                  width: MediaQuery.of(context).size.width * .05,
                                  height: MediaQuery.of(context).size.height * .06,
                                )),
                          ),
                        ),
                        SizedBox(width: 4),
                        SizedBox.fromSize(
                            size: const Size.square(48.0),
                            child: Container(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                    onTap: _onTapAccount(context),
                                    child: SvgPicture.asset(
                                      AppVectors.user,
                              width: MediaQuery.of(context).size.width * .06,
                              height: MediaQuery.of(context).size.height * .065,
                                    )))),
                        SizedBox(width: 4),
                        SizedBox.fromSize(
                            size: const Size.square(48.0),
                            child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.add_business_outlined), //RD2199-22
                                  color: Colors.white,
                                  iconSize: 40,
                                  onPressed: () {
                                    BaseNavigate(context, SavedCompanyListPage());


                                  },
                                ))),
                        SizedBox.fromSize(//new home screen
                            size: const Size.square(48.0),
                            child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.home_outlined), //RD2199-22
                                  color: Colors.white,
                                  iconSize: 40,
                                  onPressed: () {
                                    BaseNavigate(context, Center(
                                      child: HomeScreen(),
                                    ));
                                  },
                                ))),

                      ]))
                ])));
  }

  VoidCallback _onTapAccount(BuildContext context) {
    return () {
      BaseNavigate(
          context,
          AccountSetting(
            viewModel: viewModel,
            onLogout: onLogout,
          ));
    };
  }

  VoidCallback _onTapSettings(BuildContext context) {
    return () {
      BaseNavigate(context, BaseSettingsView());
    };
  }

  _confirmLogout(BuildContext context) async {
    final response = await appChoiceDialog(
      context: context,
      message: "Are you sure you want to logout ?",
    );

    if (response == true) {
      onLogout();
    }
  }
}

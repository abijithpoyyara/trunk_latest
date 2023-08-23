  // import 'package:cybertrade_app/scr/home/demo.dart';
  // import 'package:cybertrade_app/scr/home/dashboard/home_head_widget.dart';
  // import 'package:cybertrade_app/scr/home/home_controller.dart';
  // import 'package:cybertrade_app/util/colors.dart';


  import 'package:flutter/material.dart';

  import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/home_head_widget.dart';
  import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/demo.dart';
import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/settings/settings.dart';
  // import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/home_controller.dart';
  import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/util/colors.dart';



  import 'package:flutter/material.dart';
  import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/dashboard/home_head_widget.dart';
  import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/scr/home/demo.dart';
  import 'package:redstars/src/widgets/screens/homepage/_partials/new_home_lib/util/colors.dart';


  GlobalKey oriantionKey =GlobalKey();

  class HomeScreen extends StatefulWidget {
    @override
    _HomeScreenState createState() => _HomeScreenState();
  }


  class _HomeScreenState extends State<HomeScreen> {


    int _currentIndex = 0;

    final List<Widget> _screens = [
      const HomeHeadWidget(),
      const Demo1(),
      const SettingsScreen(),
      const Demo3(),
      // Add other screens here
    ];

    void _changeTab(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      return OrientationBuilder(

        key: oriantionKey,
          builder:(context, orientation){
        return Scaffold(
          body: _screens[_currentIndex], // Show the current screen
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _changeTab, // Call the method to change tab
              backgroundColor: bottumNavigationBarColor,

              unselectedItemColor: bottumNavigationBarIconColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 0.0,
              selectedItemColor:  bottumNavigationIconColor2,

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 40,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.sim_card_alert_outlined,
                    size: 40,
                  ),
                  label: 'Alert',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings_outlined,
                    size: 40,
                  ),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.login_outlined,
                    size: 40,
                  ),
                  label: 'Logout',
                ),
              ],
            ),
          ),
        );
      });
    }
  }

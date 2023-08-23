import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/theme_config.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redstars/res/navigation/app_routes.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/widgets/screens/homepage/homepage.dart';
import 'package:redstars/src/widgets/screens/splash/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  final Store<AppState> store;

  static ThemeData initTheme = MyAppTheme(isDark: true).defaultTheme;

  App(this.store) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  static Future<void> initApp() async {

    try {
      await Settings.initVersion();


      SharedPreferences prefs = await SharedPreferences.getInstance();
      String themeName = prefs.getString('theme');
      print('@@@@@@@@@@@@@@@@@@');
      print(themeName);
      switch (themeName) {
        case 'default':
          initTheme = MyAppTheme(isDark: true).defaultTheme;
          break;
        case 'blue':
          initTheme = MyAppTheme(isDark: true).blueTheme;
          break;
        case 'green':
          initTheme = MyAppTheme(isDark: true).greenTheme;
          break;
        default:
          initTheme = MyAppTheme(isDark: true).defaultTheme;
      }
    } catch (e) {
      print("Error while init version");
    }
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver{
initTrue()async{
  await BasePrefs.setString("isTransUnblockInit", "");
  await BasePrefs.setString("isUnconfirmedInit", "");
  await BasePrefs.setString("isUnconfirmedDetailInit", "");
  await BasePrefs.setString("isDocInit", "");
  await BasePrefs.setString("isDocDetailInit", "");
  await BasePrefs.setString("IsCompanyInit", "");
  await BasePrefs.setString("IsCompanyDetailInit", "");
  await BasePrefs.setString("isHomeInit", "");
}
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initTrue();
    pushNotification();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.paused)
    {  await BasePrefs.setString("AppLife", "Minimized");
      print("App Minimized");
    }
    else if(state == AppLifecycleState.resumed)
    {  await BasePrefs.setString("AppLife", "Resumed");
      print("App Resumed");}
    else if(state == AppLifecycleState.inactive)
    {  await BasePrefs.setString("AppLife", "Inactive");
      print("App Inactive");
    await BasePrefs.setString("AutoLogin", "true");
    }
    else if(state == AppLifecycleState.detached)
    {  await BasePrefs.setString("AppLife", "Detached");
      print("App Detached");}
  }

  @override
  Widget build(BuildContext context) {
    final _colors = BaseColors.of(context);



    // return ThemeProvider(
    //   initTheme: initTheme,
    //   builder: (_, myTheme) {
    //     return MaterialApp(
    //       title: 'Flutter Demo',
    //       theme: myTheme,
    //       home: MyHomePage(),
    //     );
    //   },
    // );

    return ThemeProvider(
        initTheme: App.initTheme,
        builder: (_, myTheme) {
          return StoreProvider<AppState>(
            store: widget.store,
            child: BaseApp(
              app: (context) => MaterialApp(
                //   theme: BaseTheme.of(context).getDefaultTheme(context),
                theme: myTheme,
                debugShowCheckedModeBanner: false,
                title: BaseStrings.instance.appName,
                //  color: Color(0xFFDF7D3E),
                navigatorKey: Keys.navKey,
                onGenerateRoute: (settings) => BaseNavigateRoute<dynamic>(
                  builder: (_) => SplashPage(isColdStart: true),
                  settings: settings.copyWith(name: AppRoutes.login),
                ),
              ),
            ),
          );
        });
  }
}

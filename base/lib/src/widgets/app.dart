import 'package:base/redux.dart';
import 'package:base/res/navigation/base_routes.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/src/redux/models/_keys.dart';
import 'package:base/src/utils/base_app_badge.dart';
import 'package:base/src/utils/base_firebase.dart';
import 'package:base/src/utils/base_navigate.dart';
import 'package:base/src/widgets/screens/splash/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

typedef AppBuilder = MaterialApp Function(BuildContext);

class BaseApp extends StatelessWidget {
  final AppBuilder app;

  const BaseApp({Key key, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _App(child: app, key: key);
  }
}

class App extends StatefulWidget {
  final Store<BaseAppState> store;

  App(this.store) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  static Future<void> initApp() async {
    try {
      await Settings.initVersion();
    } catch (e) {
      print("Error while init version");
    }
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with AppBadgeMixin {
  @override
  void initState() {
    initBadge();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<BaseAppState>(
        store: widget.store,
        child: BaseApp(
            app: (context) => MaterialApp(
                //   theme: getTheme(),
                debugShowCheckedModeBanner: false,
                title: BaseStrings.instance.appName,
                color: Colors.white,
                navigatorKey: Keys.navKey,
                onGenerateRoute: (settings) => BaseNavigateRoute<dynamic>(
                    builder: (_) => SplashPage(isColdStart: true),
                    settings: settings.copyWith(name: BaseRoutes.login)))));
  }
}

class _App extends StatefulWidget {
  final AppBuilder child;

  const _App({Key key, this.child}) : super(key: key);

  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<_App>
    with FireBaseNotificationMixin, AppBadgeMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseColors(child: Builder(builder: (BuildContext context) {
      final _colors = BaseColors.of(context);

      return BaseTheme(
          style: BaseTextStyle(colors: _colors),
          colors: _colors,
          child: Builder(builder: (context) => widget.child(context)));
    }));
  }

  @override
  void onMessage(RemoteMessage message) {
    super.onMessage(message);
    print('APP MESSAGE CALLED!!!!!!!!!!!!!!');
    print('APP MESSAGE :$message');
  }

  @override
  void onResume(RemoteMessage message) {
    super.onResume(message);
    print('APP RESUME CALLED!!!!!!!!!!!!!!');
    print('APP RESUME :$message');
  }
}

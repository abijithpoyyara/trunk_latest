import 'package:base/redux.dart';
import 'package:base/src/widgets/app.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await App.initApp();
  Store<BaseAppState> store = await createStore();
  runApp(App(store));
}

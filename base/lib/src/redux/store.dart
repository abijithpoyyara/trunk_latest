import 'dart:async';

import 'package:base/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'middleware/scan_middleware.dart';

/// Base Store
///
/// Store control whole state pf the app and controls and manipulate application state

Future<Store<BaseAppState>> createStore() async {
  var prefs = await SharedPreferences.getInstance();
  return Store(
    appReducer,
    initialState: BaseAppState.initial(),
    middleware: [LocalStorageMiddleware(prefs), thunkMiddleware,ScanMiddleware()],
  );
}

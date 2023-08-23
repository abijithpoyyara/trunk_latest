import 'dart:async';

import 'package:base/redux.dart' as baseRedux show ScanMiddleware;
import 'package:redstars/src/redux/reducers/app_reducer.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'middleware/local_storage_middleware.dart';

Future<Store<AppState>> createStore() async {
  var prefs = await SharedPreferences.getInstance();
  return Store(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      LocalStorageMiddleware(prefs),
      thunkMiddleware,
      baseRedux.ScanMiddleware()
    ],
  );
}

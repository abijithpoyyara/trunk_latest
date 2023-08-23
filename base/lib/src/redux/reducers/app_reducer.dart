import 'package:base/redux.dart';
import 'package:base/src/redux/reducers/scan_reducer.dart';

/// Base reducer handles application [BaseAppState]
BaseAppState appReducer(BaseAppState state, dynamic action) => new BaseAppState(
    signInState: signinReducer(state.signInState, action),
    homeState: homeReducer(state.homeState, action),
    scanState: scanReducer(state.scanState, action));

import 'package:base/redux.dart';
import 'package:flutter/material.dart';

import 'scan_state.dart';

@immutable
class BaseAppState {
  final SignInState signInState;
  final HomeState homeState;
  final ScanState scanState;

  BaseAppState({
    @required this.signInState,
    @required this.homeState,
    @required this.scanState,
  });

  factory BaseAppState.initial() {
    return BaseAppState(
      signInState: SignInState.initial(),
      homeState: HomeState.initial(),
      scanState: ScanState.initial(),
    );
  }

  BaseAppState copyWith({
    SignInState signInState,
    HomeState homeState,
    ScanState scanState,
  }) {
    return BaseAppState(
      homeState: homeState ?? this.homeState,
      signInState: signInState ?? this.signInState,
      scanState: scanState ?? this.scanState,
    );
  }
}

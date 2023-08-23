import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';

/// Base view-model for whole app
///
/// view-model for states that extends from [BaseState] can extend base view-model
/// Commonly used components are defined.

class BaseViewModel {
  final LoadingStatus loadingStatus;
  final String loadingMessage;
  final String loadingError;
  final String filePath;

  BaseViewModel(
      {@required this.loadingStatus,
        @required this.loadingMessage,
        @required this.loadingError,
        this.filePath});
}

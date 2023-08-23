import 'package:base/redux.dart';

/// Base State defined for whole app.
///
///
/// Commonly used objects are defined here.

abstract class BaseState {
  final LoadingStatus loadingStatus;
  final String loadingMessage;
  final String loadingError;
  final String filePath;

  BaseState(
      {this.loadingStatus,
        this.loadingMessage,
        this.loadingError,
        this.filePath});
}
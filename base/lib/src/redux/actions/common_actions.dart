import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';

/// Commonly used Redux Actions.

/// Called from Redux [Store.onDispose]
class OnClearAction {
  dynamic type;

  OnClearAction([this.type]);
}

/// Common action indicating a background process and indicating a loading
class LoadingAction {
  /// Loading status defined in[LoadingStatus]
  final LoadingStatus status;
  final String message;
  final type;

  LoadingAction({@required this.status, @required this.message, this.type});
}

/// Common Action called for saving the file path in [Pref]
class SetFilePathAction {
  final String filePath;

  SetFilePathAction({this.filePath});
}

/// Common Action called for retrieving saved file path from [Pref]
class InitFilePathAction {
  final Function(String filePath) hasTokenCallback;

  InitFilePathAction({this.hasTokenCallback});
}

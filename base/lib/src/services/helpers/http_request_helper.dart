import 'package:base/services.dart';
import 'package:flutter/material.dart';

import '_post_request_helper.dart';

/// Utility class for handling app related [http] requests.

class HttpRequestHelper {
  final Map<String, dynamic> requestParams;

  final Function(Map<String, dynamic> response) onRequestSuccess;
  final Function(AppException exception) onRequestFailure;

  final String service;

  /// Callback [onRequestSuccess] pass the result of consumed request and
  /// callback[onRequestFailure]  calls when the request fails and pass [AppException].
  HttpRequestHelper(
      {@required this.requestParams,
      @required this.onRequestSuccess,
      @required this.onRequestFailure,
      this.service = "getdata"});

  /// calls [PostServiceHelper.postRequest] for result of  [requestParams].
  Future<void> post() async {
    await PostServiceHelper(httpRequest: this).postRequest();
  }
}

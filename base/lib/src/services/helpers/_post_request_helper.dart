import 'dart:convert';
import 'dart:io';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'http_request_helper.dart';

/// Class that handle all [http-Post] requests.
class PostServiceHelper {
  final HttpRequestHelper httpRequest;

  PostServiceHelper({@required this.httpRequest});

  /// perform http post request from param [httpRequest]
  /// params for post request are generated from [httpRequest]
  /// url generated from [connection_props.generateUri] and the service from [httpRequest]
  /// throws a 500 Exception if the cookies are not correctly handled.
  /// perform [httpRequest.onRequestSuccess] on request success and [httpRequest.onRequestFailure] on failure.
  Future<dynamic> postRequest() async {
    String url = Connections().generateUri() + httpRequest.service + "?";

    String formBody = "";
    httpRequest.requestParams.forEach((key, value) => {
          formBody +=
              key + '=' + Uri.encodeQueryComponent(value.toString()) + '&'
        });

    List<int> bodyBytes = utf8.encode(formBody);

    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.cookieHeader:
          await BasePrefs.getString(BaseConstants.COOKIE_KEY),
    HttpHeaders.acceptCharsetHeader:"utf-8"
    };

    // try {
    final response = await http.post(
     Uri.parse(url) ,
      headers: headers,
      body: bodyBytes,
 //encoding: convert.Encoding.getByName("utf-8"),
    );

    final parsedResponse = _parseResponse(response);

    if (parsedResponse is AppException)
      httpRequest.onRequestFailure(parsedResponse);
    else
      httpRequest.onRequestSuccess(parsedResponse);
    // } on SocketException {
    //   httpRequest
    //       .onRequestFailure(FetchDataException('No Internet connection'));
    // } catch (e) {
    //   print(e);
    //   httpRequest.onRequestFailure(e);
    // }
    return;
  }

  authenticateRequest() async {
    String url = Connections().generateUri() + httpRequest.service + "?";

    String formBody = "";
    httpRequest.requestParams.forEach((key, value) => {
          formBody +=
              key + '=' + Uri.encodeQueryComponent(value.toString()) + '&'
        });

    print("request: " + httpRequest.requestParams.toString());

    List<int> bodyBytes = utf8.encode(formBody);

    final headers = {
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded; charset=UTF-8",
      'X-Requested-With': 'XMLHttpRequest',
    };

    try {
      final response = await http.post(
        Uri.parse(url) ,
        headers: headers,
        body: bodyBytes,
      );

      var header = response.headers;
      await BasePrefs.setString(BaseConstants.COOKIE_KEY, header["set-cookie"]);
      final parsedResponse = _parseResponse(response);

      if (parsedResponse is AppException)
        httpRequest.onRequestFailure(parsedResponse);
      else
        httpRequest.onRequestSuccess(parsedResponse);
    } on SocketException {
      httpRequest
          .onRequestFailure(FetchDataException('No Internet connection'));
    } catch (e) {
      httpRequest.onRequestFailure(e);
    }
  }

  /// Function return formatted [http.Response] for app return [AppException] if the request failures and Map<String,dynamic> if success
  /// called after getting response [postRequest],[authenticateRequest].

  dynamic _parseResponse(http.Response response) {
    try {
      _printRequest(response);
    } catch (e) {
      print(e.toString());
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
    switch (response.statusCode) {
      case 200:
        try {
          return json.decode(utf8.decode(response.bodyBytes));
        } catch (e) {
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
        }
        break;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  void _printRequest(http.Response response) {
    var result, header, request, requestHeaders;
    request = httpRequest.requestParams.toString();
    requestHeaders = response.request.headers.toString();
    result = json.decode(response.body);
 var  data= utf8.decode(response.bodyBytes);
    header = response.headers;

    print(
        '*********************  Request Body     ****************************');
    print('Request query : $request');
    print('Request path : ${response.request.toString()}');
    print('Request headers  : $requestHeaders');
    print('*********************  ****************************');
    print('*********************  Responce Body    **************************');
    print('headers : $header');
    print('result : $result');
    print('dataresult $data');
    print('********************  ****************************');
  }
}

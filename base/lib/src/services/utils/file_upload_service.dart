import 'dart:convert';
import 'dart:io';

import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'app_exceptions.dart';

class MultipartService {
  final MultipartBody params;

  final Function(ImageModel file) onUploadSuccess;
  final Function(AppException exception) onUploadFailure;

  final Function(int progress) onUploadProgress;

  MultipartService(
      {@required this.params,
      @required this.onUploadSuccess,
      @required this.onUploadFailure,
      this.onUploadProgress});

  Future<Null> uploadImage() async {
    String url = Connections().generateUri() + "uploadfileformobile?";
    File image = params.filedata;
    print("upload request : " + params.toMap().toString());
    print("pdf path ${image.path}");

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(url));

    final file = await http.MultipartFile.fromPath('filedata', image.path);

    imageUploadRequest.fields['filename'] = params.filename;
    imageUploadRequest.fields["overwriteFile"] = "true";
    imageUploadRequest.fields["ssnidn"] = params.ssnidn;
    imageUploadRequest.fields["uploadurl"] = params.uploadurl;
    imageUploadRequest.files.add(file);

    print("Started uploading file ");
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("Completed uploading file");
      onUploadSuccess(_returnResponse(response));
    } catch (e) {
      print(e);
      onUploadFailure(FetchDataException("Failed to upload image" + e ?? ""));
    }

    return null;
  }

/* IB0080-20 deleted
  Future<void> uploadFileWithName() async {
    String url = generateUri() + "uploadfilewithnameformobile?";
    File image = params.filedata;
    print("upload request : " + params.toMap().toString());

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(url));

    final file = await http.MultipartFile.fromPath('filedata', image.path);

    imageUploadRequest.fields['filename'] = params.filename;
    imageUploadRequest.fields["overwriteFile"] = "true";
    imageUploadRequest.fields["ssnidn"] = params.ssnidn;
    imageUploadRequest.fields["uploadurl"] = params.uploadurl;
    imageUploadRequest.fields["newfilename"] = params.filename;
    imageUploadRequest.files.add(file);

    print("Started uploading file ");
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("Completed uploading file");
      onUploadSuccess(_returnResponse(response));
    } catch (e) {
      print(e);
      onUploadFailure(FetchDataException("Failed to upload image" + e ?? ""));
    }
  }

IB0080-20 ends */

  dynamic _returnResponse(Response response) {
    print(response.body);
    print(response.headers);
    print(response.request.toString());
    print(response.statusCode);

    switch (response.statusCode) {
      case 0:
        var responseJson = json.encode(response.body);
        print(responseJson);
        return responseJson;
      case 200:
        ImageModel responseJson =
            ImageModel.fromJson(jsonDecode(response.body));
        if (responseJson.success.contains("true"))
          return responseJson;
        else {
          print("Exception Thrown");
          throw FetchDataException(
              'Error occured while Communication with Server : ${responseJson.data.statusMessage}');
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
}

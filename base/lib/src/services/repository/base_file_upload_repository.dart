import 'dart:io';

import 'package:base/constants.dart';
import 'package:base/services.dart';
import 'package:base/src/widgets/screens/item_attachment/_model/item_attachment_model.dart';
import 'package:base/utility.dart';
import 'package:flutter/widgets.dart';

class FileUploadRepository {
  final Function(List<ItemAttachmentModel> documents) onRequestSuccess;
  final Function(AppException exception) onRequestFailure;

  FileUploadRepository(
      {@required this.onRequestSuccess, @required this.onRequestFailure});

/*
  uploadDocumentsWithName(List<File> files, List<String> fileName,
      {Function(double progress) uploadProgress}) async {
    List<ImageModel> uploadedImages = List();
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    MultipartBody requestBody;
    var _response;
    String uploadPath =
    await BasePrefs.getString(FILE_DS_ATTACHMENT_TEMP_PATH_KEY);

    print("uploadPath " + uploadPath);

    try {
      for (int i = 0; i < files.length; i++) {
        requestBody = MultipartBody(
            ssnidn: ssnId,
            filedata: files[i],
            filename: fileName[i],
            overwriteFile: true,
            uploadurl: uploadPath);

        MultipartService(
            params: requestBody,
            onUploadFailure: onRequestFailure,
            onUploadSuccess: (file) => uploadedImages.add(file));
//            .uploadFileWithName();
        uploadedImages
            .add(_response is ImageModel ? _response : ImageModel("false"));
      }
      onRequestSuccess(uploadedImages);
    } catch (e) {
      print(e.toString());
      onRequestFailure(FetchDataException("Failed to upload image" + e ?? ""));
    }
  }*/

  void uploadDocuments(
    List<ItemAttachmentModel> documents, {
    Function(int progress) uploadProgress,
  }) async {
    List<String> fileNames;
    String fileName;

    String ssnId = await BasePrefs.getString(BaseConstants.SSNIDN_KEY);
    MultipartBody requestBody;

    String uploadPath = await BasePrefs.getString(BaseConstants.FILE_UPLOAD_PATH_KEY);

    print("uploadPath " + uploadPath);
    try {
      List<ItemAttachmentModel> uploadedDocs = [];

      for (var value in documents) {
        List<String> filePaths = value.scannedDocuments;

        List<ImageModel> uploadedImages = List();

        for (int i = 0; i < filePaths.length; i++) {
          fileNames = filePaths[i].split("/");
          fileName = fileNames[fileNames.length - 1];
          fileNames = fileName.split(".");

          requestBody = MultipartBody(
              ssnidn: ssnId,
              filedata: File(filePaths[i]),
              filename: fileName,
              overwriteFile: true,
              uploadurl: uploadPath);

          await MultipartService(
                  params: requestBody,
                  onUploadFailure: onRequestFailure,
                  onUploadProgress: (progress) => {},
                  onUploadSuccess: (file) => uploadedImages.add(file))
              .uploadImage();

          uploadProgress((i + 1 ~/ filePaths.length) * 100);
        }
        value.uploadedImages = uploadedImages;
        uploadedDocs.add(value);
      }

      if (uploadedDocs.isNotEmpty)
        onRequestSuccess(uploadedDocs);
      else
        onRequestFailure(FetchDataException("Failed to upload image" + ""));
    } catch (e) {
      onRequestFailure(FetchDataException("Failed to upload image"));
    }
  }

/* void uploadDocument(String filePath, {
    Function(int progress) uploadProgress,
  }) async {
    String fileName;

    List<ImageModel> uploadedImages = List();
    String ssnId = await BasePrefs.getString(SSNIDN_KEY);
    MultipartBody requestBody;

    String uploadPath =
    await BasePrefs.getString(FILE_DS_ATTACHMENT_TEMP_PATH_KEY);

    print("uploadPath " + uploadPath);

    try {
      fileName = filePath
          .split("/")
          .last;

      requestBody = MultipartBody(
          ssnidn: ssnId,
          filedata: File(filePath),
          filename: fileName,
          overwriteFile: true,
          uploadurl: uploadPath);

      await MultipartService(
          params: requestBody,
          onUploadFailure: onRequestFailure,
          onUploadProgress: uploadProgress,
          onUploadSuccess: (file) => uploadedImages.add(file)).uploadImage();
      if (uploadedImages.isNotEmpty)
        onRequestSuccess(uploadedImages);
      else
        onRequestFailure(FetchDataException("Failed to upload image" + ""));
    } catch (e) {
      onRequestFailure(FetchDataException("Failed to upload image" + ""));
    }
  }*/
}
